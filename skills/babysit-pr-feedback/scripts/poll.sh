#!/usr/bin/env bash
# Deterministic job state for babysit-pr-feedback: new-feedback detection, deadline, and quiet timer.
set -euo pipefail
# Keeps errexit inside command substitutions so a failed fetch cannot read as idle.
shopt -s inherit_errexit

QUIET_SECONDS=1800
DEFAULT_MAX_RUNTIME=4h

usage() {
  cat >&2 <<EOF
usage: $0 check OWNER/REPO PR_NUMBER [MAX_RUNTIME]
       $0 deadline OWNER/REPO PR_NUMBER
       $0 mark-processed OWNER/REPO PR_NUMBER ID...
       $0 mark-pending OWNER/REPO PR_NUMBER ID...
       $0 reply OWNER/REPO PR_NUMBER ID BODY
       $0 mark-fix OWNER/REPO PR_NUMBER
       $0 reset OWNER/REPO PR_NUMBER

check exits 0 (WORK), 3 (NOOP), or 4 (STOP); deadline exits 0 or 4.
EOF
  exit 2
}

[[ $# -ge 3 ]] || usage

action=$1
repository=$2
pull_request=$3
shift 3
host=${GITHUB_HOST:-github.com}

[[ $repository =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] || usage
[[ $pull_request =~ ^[1-9][0-9]*$ ]] || usage

export GH_PROMPT_DISABLED=1
# Pins repo context so account-selecting gh wrappers use the right identity for GraphQL and replies.
export GH_REPO=$repository

state_dir=${XDG_STATE_HOME:-$HOME/.local/state}/babysit-pr-feedback
state_file=$state_dir/${repository//\//__}__$pull_request.json
now=$(date +%s)

parse_duration() {
  [[ $1 =~ ^([1-9][0-9]*)([mh])$ ]] || {
    echo "error: invalid max_runtime: $1 (expected e.g. 90m or 6h)" >&2
    exit 2
  }
  local unit=60
  [[ ${BASH_REMATCH[2]} == h ]] && unit=3600
  echo $((BASH_REMATCH[1] * unit))
}

write_state() {
  mkdir -p "$state_dir"
  local tmp
  tmp=$(mktemp "$state_dir/.state.XXXXXX")
  jq "$@" >"$tmp"
  mv "$tmp" "$state_file"
}

# The first check fixes the deadline; later MAX_RUNTIME arguments never extend it.
init_state() {
  [[ -f $state_file ]] && return
  local max_seconds
  max_seconds=$(parse_duration "${1:-$DEFAULT_MAX_RUNTIME}")
  write_state -n --argjson now "$now" --argjson max "$max_seconds" \
    '{started_at: $now, max_runtime_seconds: $max, last_fix_at: null, processed_ids: [], pending_replies: []}'
}

require_state() {
  [[ -f $state_file ]] || {
    echo "error: no job state for $repository#$pull_request; run check first" >&2
    exit 2
  }
}

deadline_passed() {
  jq -e --argjson now "$now" '$now >= .started_at + .max_runtime_seconds' "$state_file" >/dev/null
}

stop() {
  echo "STOP $1"
  exit 4
}

# Emits [{id, kind, author, url}] for open feedback: unresolved, non-outdated thread comments, PR comments, and review bodies.
fetch_feedback() {
  local owner=${repository%/*} name=${repository#*/}
  local open_roots thread_comments issue_comments reviews
  # GraphQL only identifies open threads by root comment; REST paginates every comment, which nested GraphQL connections cannot.
  open_roots=$(gh api graphql --hostname "$host" --paginate --slurp \
    -F owner="$owner" -F name="$name" -F number="$pull_request" -f query='
      query($owner: String!, $name: String!, $number: Int!, $endCursor: String) {
        repository(owner: $owner, name: $name) {
          pullRequest(number: $number) {
            reviewThreads(first: 100, after: $endCursor) {
              pageInfo { hasNextPage endCursor }
              nodes { isResolved isOutdated comments(first: 1) { nodes { databaseId } } }
            }
          }
        }
      }' | jq '[.[].data.repository.pullRequest.reviewThreads.nodes[]
        | select(.isResolved | not) | select(.isOutdated | not)
        | .comments.nodes[0].databaseId]')
  thread_comments=$(gh api --hostname "$host" --paginate --slurp \
    "repos/$repository/pulls/$pull_request/comments" \
    | jq --argjson roots "$open_roots" '[.[][] | select((.in_reply_to_id // .id) as $root | $roots | index($root))
        | {id: "thread:\(.id)", kind: "thread", author: .user.login, url: .html_url}]')
  issue_comments=$(gh api --hostname "$host" --paginate --slurp \
    "repos/$repository/issues/$pull_request/comments" \
    | jq '[.[][] | {id: "issue:\(.id)", kind: "issue", author: .user.login, url: .html_url}]')
  reviews=$(gh api --hostname "$host" --paginate --slurp \
    "repos/$repository/pulls/$pull_request/reviews" \
    | jq '[.[][] | select(.body != "") | {id: "review:\(.id)", kind: "review", author: .user.login, url: .html_url}]')
  jq -n --argjson a "$thread_comments" --argjson b "$issue_comments" --argjson c "$reviews" '$a + $b + $c'
}

# Marking an item processed also clears any pending reply for it.
mark_processed() {
  write_state '.processed_ids = (.processed_ids + $ARGS.positional | unique)
    | .pending_replies = ((.pending_replies // []) - $ARGS.positional)' "$state_file" --args "$@"
}

# Records reply targets before publishing so an interrupted reply keeps the job working even if its thread goes outdated.
mark_pending() {
  write_state '.pending_replies = ((.pending_replies // []) + $ARGS.positional | unique)' "$state_file" --args "$@"
}

# Posts a reply to a feedback item and records both IDs so the job's own replies never surface as new feedback.
reply() {
  [[ $# -eq 2 && $1 =~ ^(thread|issue|review):[0-9]+$ ]] || usage
  local target=$1 body=$2 reply_id
  if [[ $target == thread:* ]]; then
    # GitHub only accepts replies to a thread's top-level comment.
    local root_id
    root_id=$(gh api --hostname "$host" "repos/$repository/pulls/comments/${target#thread:}" --jq '.in_reply_to_id // .id')
    reply_id=$(gh api --hostname "$host" -X POST \
      "repos/$repository/pulls/$pull_request/comments/$root_id/replies" -f body="$body" --jq '"thread:\(.id)"')
  else
    reply_id=$(gh api --hostname "$host" -X POST \
      "repos/$repository/issues/$pull_request/comments" -f body="$body" --jq '"issue:\(.id)"')
  fi
  mark_processed "$target" "$reply_id"
  echo "$reply_id"
}

check() {
  init_state "${1:-}"
  # Checked before any remote call so an outage or auth failure cannot outlive max_runtime.
  deadline_passed && stop max_runtime

  local pr_state head_ref
  read -r pr_state head_ref < <(gh pr view "$pull_request" --repo "$repository" --json state,headRefName --jq '"\(.state) \(.headRefName)"')
  [[ $pr_state == OPEN ]] || stop "pr_$(tr '[:upper:]' '[:lower:]' <<<"$pr_state")"

  local new_items unpushed
  new_items=$(fetch_feedback \
    | jq --slurpfile state "$state_file" '$state[0] as $s
        | [.[] | select(.id as $id | $s.processed_ids | index($id) | not)] as $new
        | $new + [($s.pending_replies // [])[] | select(. as $id | $new | map(.id) | index($id) | not)
            | {id: ., kind: (split(":")[0]), pending_reply: true}]')
  # Compares against the PR head on origin so a missing upstream fails loudly instead of reading as zero.
  unpushed=$(git rev-list --count "refs/remotes/origin/$head_ref..HEAD")

  if [[ $(jq length <<<"$new_items") -gt 0 || $unpushed -gt 0 ]]; then
    echo "WORK new_feedback=$(jq length <<<"$new_items") unpushed_commits=$unpushed"
    jq . <<<"$new_items"
    exit 0
  fi

  jq -e --argjson now "$now" --argjson quiet "$QUIET_SECONDS" \
    '$now - (.last_fix_at // .started_at) >= $quiet' "$state_file" >/dev/null && stop quiet
  echo "NOOP"
  exit 3
}

case $action in
  check) check "$@" ;;
  deadline)
    # A job without state has not started, so it has no deadline yet.
    [[ -f $state_file ]] && deadline_passed && stop max_runtime
    echo "OK"
    ;;
  mark-processed)
    require_state
    [[ $# -gt 0 ]] || usage
    mark_processed "$@"
    ;;
  reply)
    require_state
    reply "$@"
    ;;
  mark-pending)
    require_state
    [[ $# -gt 0 ]] || usage
    mark_pending "$@"
    ;;
  mark-fix)
    require_state
    write_state --argjson now "$now" '.last_fix_at = $now' "$state_file"
    ;;
  reset) rm -f "$state_file" ;;
  *) usage ;;
esac

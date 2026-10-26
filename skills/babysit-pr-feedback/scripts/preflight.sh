#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "usage: $0 OWNER/REPO PR_NUMBER" >&2
  exit 2
}

[[ $# -eq 2 ]] || usage

repository=$1
pull_request=$2
host=${GITHUB_HOST:-github.com}

[[ $repository =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] || usage
[[ $pull_request =~ ^[1-9][0-9]*$ ]] || usage

for command in gh git gs; do
  command -v "$command" >/dev/null || {
    echo "error: required command is unavailable: $command" >&2
    exit 10
  }
done

export GH_PROMPT_DISABLED=1
export GIT_TERMINAL_PROMPT=0

gh auth status --active --hostname "$host" >/dev/null || {
  echo "error: gh authentication is unavailable for $host" >&2
  exit 20
}

permissions=$(gh api --hostname "$host" "repos/$repository" --jq '.permissions.push') || {
  echo "error: cannot access $repository with gh" >&2
  exit 21
}

[[ $permissions == true ]] || {
  echo "error: gh does not have push access to $repository" >&2
  exit 22
}

# Unset GH_REPO so gh resolves the checkout's own repository instead of the requested one.
local_repository=$(env -u GH_REPO gh repo view --json nameWithOwner --jq '.nameWithOwner') || {
  echo "error: the current checkout is not a GitHub repository accessible to gh" >&2
  exit 23
}

local_repository_lower=$(printf '%s' "$local_repository" | tr '[:upper:]' '[:lower:]')
repository_lower=$(printf '%s' "$repository" | tr '[:upper:]' '[:lower:]')
[[ $local_repository_lower == "$repository_lower" ]] || {
  echo "error: current checkout is $local_repository, not $repository" >&2
  exit 24
}

origin=$(git remote get-url origin) || {
  echo "error: the current checkout has no origin remote" >&2
  exit 25
}

git ls-remote --exit-code "$origin" HEAD >/dev/null || {
  echo "error: Git authentication failed for the existing origin remote" >&2
  exit 26
}

[[ -z $(git status --porcelain) ]] || {
  echo "error: the checkout contains uncommitted changes" >&2
  exit 27
}

pr_branch=$(gh pr view "$pull_request" --repo "$repository" --json headRefName --jq '.headRefName') || {
  echo "error: cannot access PR #$pull_request in $repository" >&2
  exit 28
}

current_branch=$(git branch --show-current)
[[ $current_branch == "$pr_branch" ]] || {
  echo "error: current branch is $current_branch, but PR #$pull_request uses $pr_branch" >&2
  exit 29
}

echo "preflight passed for $repository#$pull_request"

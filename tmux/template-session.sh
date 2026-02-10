#!/usr/bin/env bash
# ~/.tmux/template-session.sh
#
# Creates a 4-window layout for the most recently created session that opted in
# via @template=1:
#   Home (~)
#   Git  (project dir, runs lazygit)
#   AI   (project dir, runs claude)
#   App  (project dir)
#
# The project dir is taken from @template_dir (recommended), otherwise falls back
# to zoxide query of the session name.

set -euo pipefail

LOG="${HOME}/.tmux/template.log"
timestamp() { date '+%Y-%m-%d %H:%M:%S'; }

log() { echo "$(timestamp) $*" >>"$LOG"; }

# Determine the session to template: newest session by creation time.
S="$(
  tmux list-sessions -F "#{session_created} #{session_name}" 2>/dev/null |
    sort -n |
    tail -1 |
    cut -d' ' -f2-
)"

if [[ -z "${S:-}" ]]; then
  log "ERROR: could not determine newest session name"
  exit 2
fi

log "INFO: template script invoked; newest session=$S"

# Gate: only run if the session explicitly opted in.
TEMPLATE_FLAG="$(tmux show -v -t "$S" @template 2>/dev/null || true)"
if [[ "$TEMPLATE_FLAG" != "1" ]]; then
  log "INFO: session=$S not opted-in (@template=$TEMPLATE_FLAG); exiting"
  exit 0
fi

# Idempotency: if Git window already exists, assume the template was applied.
if tmux list-windows -t "$S" -F '#W' 2>/dev/null | grep -qx 'Git'; then
  log "INFO: session=$S already templated (Git window exists); exiting"
  exit 0
fi

# Resolve target dir: prefer explicit @template_dir, fallback to zoxide query.
TARGET_DIR="$(tmux show -v -t "$S" @template_dir 2>/dev/null || true)"

if [[ -z "${TARGET_DIR:-}" ]]; then
  # Try common zoxide locations on macOS/homebrew first (tmux server PATH can differ)
  ZOXIDE_BIN=""
  if command -v zoxide >/dev/null 2>&1; then
    ZOXIDE_BIN="$(command -v zoxide)"
  elif [[ -x /opt/homebrew/bin/zoxide ]]; then
    ZOXIDE_BIN="/opt/homebrew/bin/zoxide"
  elif [[ -x /usr/local/bin/zoxide ]]; then
    ZOXIDE_BIN="/usr/local/bin/zoxide"
  fi

  if [[ -n "$ZOXIDE_BIN" ]]; then
    TARGET_DIR="$("$ZOXIDE_BIN" query -- "$S" 2>/dev/null || true)"
  else
    log "ERROR: @template_dir unset and zoxide not found (PATH in tmux server may be missing it)"
    exit 1
  fi
fi

if [[ -z "${TARGET_DIR:-}" ]] || [[ ! -d "$TARGET_DIR" ]]; then
  log "ERROR: could not resolve target dir for session='$S' (got: '$TARGET_DIR')"
  exit 1
fi

log "INFO: session=$S target_dir=$TARGET_DIR"

# Detect whether tmux supports `new-window -c`.
supports_c=false
if tmux new-window -t "$S" -n __tmpltest -c "$TARGET_DIR" "true" >/dev/null 2>&1; then
  supports_c=true
  tmux kill-window -t "$S:__tmpltest" >/dev/null 2>&1 || true
fi
log "INFO: session=$S supports_-c=$supports_c"

# Rename the session's current/initial window to Home (works with base-index 0 or 1).
tmux rename-window -t "$S:" Home >/dev/null 2>&1 || true
tmux send-keys -t "$S:Home" "cd ~" C-m

create_window() {
  local wname="$1"
  local run_cmd="$2" # command to run in a login shell

  if tmux list-windows -t "$S" -F '#W' 2>/dev/null | grep -qx "$wname"; then
    log "INFO: session=$S window=$wname already exists; skipping"
    return 0
  fi

  if [[ "$supports_c" == "true" ]]; then
    tmux new-window -t "$S:" -n "$wname" -c "$TARGET_DIR" "bash -lc '$run_cmd || exec \$SHELL'"
  else
    # Fallback for old tmux: cd inside the shell command
    tmux new-window -t "$S:" -n "$wname" "bash -lc 'cd \"${TARGET_DIR}\" && $run_cmd || exec \$SHELL'"
  fi

  log "INFO: session=$S created_window=$wname"
}

create_window "Git" "lazygit"
create_window "AI" "claude"
create_window "App" "exec \$SHELL"

tmux select-window -t "$S:Home" >/dev/null 2>&1 || true

log "INFO: session=$S template complete"
exit 0

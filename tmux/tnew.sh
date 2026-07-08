# tnew function, tmux templater that calls ~/.tmux/template-session.sh
# Usage: tnew <dir-name>
#        tnew -w|--worktree <dir-name> <branch>
tnew() {
  local worktree_mode=0
  local -a positional
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -w|--worktree) worktree_mode=1 ;;
      --) shift; positional+=("$@"); break ;;
      -*) echo "tnew: unknown option: $1" >&2; return 2 ;;
      *) positional+=("$1") ;;
    esac
    shift
  done

  local name="${positional[1]}"
  if [[ -z "$name" ]]; then
    echo "usage: tnew <dir-name>" >&2
    echo "       tnew (-w|--worktree) <dir-name> <branch>" >&2
    return 2
  fi

  # Resolve directory with zoxide, fallback to literal/tilde expansion
  local dir
  if command -v zoxide >/dev/null 2>&1; then
    dir="$(zoxide query -- "${name}" 2>/dev/null || true)"
  fi
  if [[ -z "$dir" ]]; then
    # fallback to literal path expansion
    dir="${name/#\~/$HOME}"
  fi

  if [[ ! -d "$dir" ]]; then
    echo "tnew: target directory not found: $dir" >&2
    return 1
  fi

  # Ensure template script exists
  local tmpl="$HOME/.tmux/template-session.sh"
  if [[ ! -x "$tmpl" ]]; then
    echo "tnew: template script not found or not executable: $tmpl" >&2
    return 1
  fi

  if [[ $worktree_mode -eq 1 ]]; then
    local branch="${positional[2]}"
    if [[ -z "$branch" ]]; then
      echo "tnew: -w requires a branch name" >&2
      return 2
    fi

    local repo_root
    repo_root="$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null)" || {
      echo "tnew: $dir is not inside a git repository" >&2
      return 1
    }

    # Sanitize branch name: / → -, strip leading -
    local sanitized="${branch//\//-}"
    sanitized="${sanitized##-}"

    # Branch suffix: the part after the last '/' (whole branch if no '/')
    local suffix="${branch##*/}"

    local repo_name wt_path session
    repo_name="$(basename "$repo_root")"
    wt_path="$HOME/worktrees/${repo_name}/${sanitized}"
    session="${name}-${suffix}"

    # Create worktree only if the path doesn't already exist
    if [[ ! -d "$wt_path" ]]; then
      mkdir -p "$(dirname "$wt_path")"
      # Try checking out an existing branch first; create new branch if it doesn't exist
      git -C "$repo_root" worktree add "$wt_path" "$branch" 2>/dev/null || \
        git -C "$repo_root" worktree add -b "$branch" "$wt_path" || {
          echo "tnew: failed to create worktree at $wt_path for branch '$branch'" >&2
          return 1
        }
    fi

    # Attach to existing session if present, otherwise create a fresh one
    if tmux has-session -t "$session" 2>/dev/null; then
      if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$session"
      else
        tmux attach -t "$session"
      fi
      return 0
    fi

    if [[ -n "$TMUX" ]]; then
      tmux new-session -d -s "$session" \; \
        set -t "$session" @template 1 \; \
        set -t "$session" @template_name "$session" \; \
        set -t "$session" @template_dir "$wt_path" \; \
        run-shell -b "$tmpl" \; \
        switch-client -t "$session"
    else
      tmux new -d -s "$session" \; \
        set -t "$session" @template 1 \; \
        set -t "$session" @template_name "$session" \; \
        set -t "$session" @template_dir "$wt_path" \; \
        run-shell -b "$tmpl" \; \
        attach -t "$session"
    fi
    return 0
  fi

  # If session already exists, just switch/attach (don't recreate)
  if tmux has-session -t "$name" 2>/dev/null; then
    if [[ -n "$TMUX" ]]; then
      tmux switch-client -t "$name"
    else
      tmux attach -t "$name"
    fi
    return 0
  fi

  # Build the tmux command chain that:
  #  - creates session detached
  #  - sets @template and @template_dir on that session
  #  - runs the template script via tmux run-shell (so it runs on the server)
  #  - then either switches client (if inside tmux) or attaches (if outside)
  if [[ -n "$TMUX" ]]; then
    tmux new-session -d -s "$name" \; \
      set -t "$name" @template 1 \; \
      set -t "$name" @template_name "$name" \; \
      set -t "$name" @template_dir "$dir" \; \
      run-shell -b "$tmpl" \; \
      switch-client -t "$name"
  else
    tmux new -d -s "$name" \; \
      set -t "$name" @template 1 \; \
      set -t "$name" @template_name "$name" \; \
      set -t "$name" @template_dir "$dir" \; \
      run-shell -b "$tmpl" \; \
      attach -t "$name"
  fi
}

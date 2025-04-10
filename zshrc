# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Plugins
source ~/.zsh/antigen/antigen.zsh
antigen bundles <<EOBUNDLES
	djui/alias-tips
	command-not-found
  Aloxaf/fzf-tab
	git
	zsh-users/zsh-autosuggestions
	zsh-users/zsh-history-substring-search
	zsh-users/zsh-completions
	jeffreytse/zsh-vi-mode
	zsh-users/zsh-syntax-highlighting
EOBUNDLES
antigen theme romkatv/powerlevel10k
antigen apply
# zsh-vi-mode recommends using zvm_bindkey instead of bindkey
# zsh-vi-mode changes bindkey mode from emacs (default) to vicmd (Normal mode) and viins (Insert mode)
# Therefore, bindkey commands must be set for all relevant modes
# See https://github.com/jeffreytse/zsh-vi-mode?tab=readme-ov-file#custom-widgets-and-keybindings
# Lastly, avoid using ^J ^K and ^L keybindings as they are overriden by vim-tmux-navigator (when inside tmux)
for keymap in main emacs viins vicmd; do
  zvm_bindkey $keymap '^N' history-search-forward
  zvm_bindkey $keymap '^P' history-search-backward
  zvm_bindkey $keymap '^A' autosuggest-accept
  zvm_bindkey $keymap '^Y' autosuggest-execute
done
# Start new shell in Normal mode, default is ZVM_MODE_LAST (last mode)
ZVM_LINE_INIT_MODE=$ZVM_MODE_NORMAL

# Options
setopt AUTO_CD # Automatic change directory
setopt NO_CASE_GLOB # Case-insensitive globbing
setopt EXTENDED_HISTORY # Add timestamp and elapsed time of command to history
setopt NO_SHARE_HISTORY # Don't share history across multiple zsh sessions
setopt APPEND_HISTORY # Append to history
setopt INC_APPEND_HISTORY # Add commands as they are typed, not at shell exit
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first
setopt HIST_IGNORE_DUPS # Do not store duplicates
setopt HIST_REDUCE_BLANKS # Remove blank lines from history
export VISUAL='/opt/homebrew/bin/nvim' # Set graphical editor to vim
export EDITOR='/opt/homebrew/bin/nvim' # Set command-line editor to vim (non-graphical)
export MANPAGER='nvim +Man!'  # Set man pager to nvim (for `man` commands)

# GPG
# export GPG_TTY=$(tty)

# Google Cloud SDK
# if [ -f '/Applications/google-cloud-sdk/path.zsh.inc' ]; then
# . '/Applications/google-cloud-sdk/path.zsh.inc'; # Update PATH
# fi
# if [ -f '/Applications/google-cloud-sdk/completion.zsh.inc' ]; then
# . '/Applications/google-cloud-sdk/completion.zsh.inc'; # Enable shell command completion
# fi

# Rancher Desktop
# export PATH="$HOME/.rd/bin:$PATH"

# DOTNET
# export PATH="$HOME/.dotnet/tools:$PATH"

# NVM
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # Load nvm
# export PATH="/usr/local/opt/openssl/bin:$PATH"
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # Load nvm bash completion

# FZF
source <(fzf --zsh)
if type rg &> /dev/null; then
	export FZF_DEFAULT_COMMAND='rg --files'
	export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

# Completions
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

# General Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias 'cd ...'='cd ../..'
alias ....='cd ../../..'
alias 'cd ....'='cd ../../..'
alias .....='cd ../../../..'
alias 'cd .....'='cd ../../../..'
alias c='clear'
alias h='history'
alias k='kubectl'
alias n='nvim'
alias r='source ~/.zshrc'
alias v='vim'
alias lg='lazygit'
alias ls='ls -AF --color=auto'
alias grep='grep --color'
alias home='cd ~'
alias tmux='tmux -2' # Fix terminal colors inside tmux
alias vimrc='nvim ~/.vimrc'
alias zshrc='nvim ~/.zshrc'

# Global Aliases
alias -g L='| less'
alias -g G='| grep --color'

# Hidden Aliases
if [ -f ~/.zsh/zsh_hidden_aliases ]; then
	source ~/.zsh/zsh_hidden_aliases
fi

# zoxide
eval "$(zoxide init --cmd cd zsh)" # Aliases cd to zoxide
# Also adds cdi command for interactive selection using fzf

# Set OpenAI API key
# To set/update, run `security add-generic-password -a ${USER} -s openai_api_key -w "your_api_key"`
export OPENAI_API_KEY="$(security find-generic-password -a ${USER} -s openai_api_key -w 2>/dev/null || echo '')"
export GROQ_API_KEY="$(security find-generic-password -a ${USER} -s groq_api_key -w 2>/dev/null || echo '')"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

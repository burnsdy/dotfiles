# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Options
setopt AUTO_CD						# automatic change directory
setopt NO_CASE_GLOB					# case-insensitive globbing
setopt EXTENDED_HISTORY				# add timestamp and elapsed time of command to history
setopt SHARE_HISTORY				# share history across multiple zsh sessions
setopt APPEND_HISTORY				# append to history
setopt INC_APPEND_HISTORY			# add commands as they are typed, not at shell exit
setopt HIST_EXPIRE_DUPS_FIRST		# expire duplicates first
setopt HIST_IGNORE_DUPS				# do not store duplicates
setopt HIST_REDUCE_BLANKS			# remove blank lines from history
export VISUAL='/usr/local/bin/nvim'	# set graphical editor to nvim
export EDITOR='/usr/bin/vim'			# set command-line editor to vim (non-graphical)

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
export PATH="/usr/local/opt/openssl/bin:$PATH"

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if type rg &> /dev/null; then
	export FZF_DEFAULT_COMMAND='rg --files'
	export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

# Completions
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

# Plugins
source ~/.zsh/antigen/antigen.zsh
antigen bundles <<EOBUNDLES
    git
    command-not-found
    djui/alias-tips
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-syntax-highlighting
    zsh-users/zsh-history-substring-search
    zsh-users/zsh-completions
    jeffreytse/zsh-vi-mode
EOBUNDLES
antigen theme romkatv/powerlevel10k
antigen apply
bindkey '^A' autosuggest-accept		# Bind Ctrl-A to accept current autosuggestion

# General Aliases
alias ls='ls -AF'
alias grep='grep --color'
alias v='vim'
alias n='nvim'
alias c='clear'
alias h='history'
alias r='source ~/.zshrc'
alias ..='cd ..'
alias ...='cd ../..'
alias 'cd ...'='cd ../..'
alias ....='cd ../../..'
alias 'cd ....'='cd ../../..'
alias .....='cd ../../../..'
alias 'cd .....'='cd ../../../..'
alias home='cd ~'
alias tmux='tmux -2'				# Fix terminal colors inside tmux
alias vimrc='nvim ~/.vimrc'
alias zshrc='nvim ~/.zshrc'

# Global Aliases
alias -g L='| less'
alias -g G='| grep --color'

# Hidden Aliases
if [ -f ~/.zsh/zsh_hidden_aliases ]; then
	source ~/.zsh/zsh_hidden_aliases
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

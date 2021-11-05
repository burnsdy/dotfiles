# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Options
setopt AUTO_CD                  # automatic change directory
setopt NO_CASE_GLOB             # case-insensitive globbing
setopt EXTENDED_HISTORY         # add timestamp and elapsed time of command to history
setopt SHARE_HISTORY            # share history across multiple zsh sessions
setopt APPEND_HISTORY           # append to history
setopt INC_APPEND_HISTORY       # add commands as they are typed, not at shell exit
setopt HIST_EXPIRE_DUPS_FIRST   # expire duplicates first
setopt HIST_IGNORE_DUPS         # do not store duplicates
setopt HIST_REDUCE_BLANKS       # remove blank lines from history

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
autoload -Uz compinit && compinit

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
alias cd ...='cd ../..'
alias ....='cd ../../..'
alias cd ....='cd ../../..'
alias .....='cd ../../../..'
alias cd .....='cd ../../../..'
alias home='cd ~'
alias zshrc='vim ~/dotfiles/zshrc'

# Global Aliases
alias -g L='| less'
alias -g G='| grep --color'

# Hidden Aliases
if [ -f ~/.zsh/zsh_hidden_aliases ]; then
	source ~/.zsh/zsh_hidden_aliases
fi

# Git Aliases
# alias g='git'
# alias gs='git status'
# alias ga='git add'
# alias gr='git restore'
# alias gc='git commit -v'
# alias gca='git commit --amend --no-edit -v'
# alias gf='git fetch'
# alias gl='git log --all --decorate --oneline --graph'
# alias gd='git diff'
# alias gp='git pull'
# alias gm='git merge'
# alias gps='git push'
# alias gb='git branch'
# alias gco='git checkout'
# alias gsh='git stash'
# alias gsp='git stash pop'
# alias gcl='git clean -di'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

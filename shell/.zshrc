# --- Zinit bootstrap (unchanged) ---
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33}%F{220}Installing %F{33}Zinit%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" \
    && print -P "%F{34}Installation successful.%f" || print -P "%F{160}Clone failed.%f"
fi
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit; (( ${+_comps} )) && _comps[zinit]=_zinit

# --- Zinit annexes (unchanged) ---
zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust

# --- Prompt early (keep high for instant prompt benefit) ---
zinit ice depth=1; zinit light romkatv/powerlevel10k
# Quiet p10k wizard unless you call `p10k configure`
typeset -g POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Pretty system summary only in interactive shells
[[ -o interactive ]] && command -v fastfetch >/dev/null && fastfetch

# --- Plugins that add *completion definitions* must load BEFORE compinit ---
zinit light zsh-users/zsh-completions

# --- Initialize completion system (cached + secure) ---
# cache speeds startup; versioned dump avoids stale caches across upgrades
ZCOMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump-$ZSH_VERSION"
mkdir -p "${ZCOMPDUMP:h}"
autoload -Uz compinit
# If compaudit ever warns, run the one-time fix shown below in Step 3.
compinit -d "$ZCOMPDUMP"

# --- Completion helpers that hook into compinit go AFTER compinit ---
zinit light Aloxaf/fzf-tab

# --- Suggestions & highlighting (order matters) ---
# Use turbo mode (wait"0") to defer loading for faster startup
zinit ice wait"0" atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait"0" atinit"zpcompinit; zpcdreplay"
zinit light zsh-users/zsh-syntax-highlighting  # MUST be last among plugins

# --- OMZ snippets (avoid duplicates) ---
# The plugin already sources needed libs; no need for OMZL::git.zsh separately.
# Load these in turbo mode for faster startup
zinit ice wait"0"
zinit snippet OMZP::git

zinit ice wait"0"
zinit snippet OMZP::sudo

zinit ice wait"0"
zinit snippet OMZP::archlinux

zinit ice wait"0"
zinit snippet OMZP::aws

zinit ice wait"0"
zinit snippet OMZP::kubectl

zinit ice wait"0"
zinit snippet OMZP::kubectx

zinit ice wait"0"
zinit snippet OMZP::command-not-found   # uses `pkgfile` on Arch

# --- Your extra config files ---
source ~/.config/zshrc.d/dots-hyprland.zsh

# --- History & UX ---
HISTSIZE=500000
SAVEHIST=$HISTSIZE
HISTFILE=$HOME/.zsh_history
setopt appendhistory sharehistory
setopt hist_ignore_space hist_find_no_dups hist_save_no_dups hist_ignore_dups
setopt interactivecomments extendedglob nocaseglob
setopt auto_cd autopushd pushdignoredups
unsetopt beep
KEYTIMEOUT=1
typeset -U path fpath        # de-dup PATH/FPATH entries

# --- FZF & Zoxide integration (canonical init) ---
# Use fast defaults for fzf
export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
command -v fzf >/dev/null && eval "$(fzf --zsh)"
# Canonical arg order; override `cd` safely
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd cd)"

# --- Useful aliases ---
# Enhanced ls/eza aliases
if command -v eza >/dev/null; then
  alias ls='eza --color=auto --icons'
  alias ll='eza -lah --icons --git'
  alias la='eza -a --icons'
  alias lt='eza --tree --level=2 --icons'
  alias lta='eza --tree --level=2 --icons -a'
else
  alias ls='ls --color'
  alias ll='ls -lah'
  alias la='ls -A'
fi

# Modern CLI replacements
command -v bat >/dev/null && alias cat='bat --style=plain --paging=never'
command -v rg >/dev/null && alias grep='rg'
command -v fd >/dev/null && alias find='fd'

# Git aliases (complement OMZ git plugin)
# Note: OMZ already provides: gs, ga, gc, gp, gl, gd, gco, gcb
# Keeping these for clarity, but they may already exist from OMZ
alias glog='git log --oneline --decorate --graph --all'
alias gst='git status'
alias gdiff='git diff'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# System shortcuts
alias c='clear'
alias h='history'
alias j='jobs -l'
alias ports='netstat -tulanp'
alias myip='curl ifconfig.me'

# Package management (Arch specific)
alias pacu='sudo pacman -Syu'
alias paci='sudo pacman -S'
alias pacr='sudo pacman -R'
alias pacs='pacman -Ss'
alias pacq='pacman -Q | grep'

# Help with bat
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# --- fzf-tab preview styles (works with the load order above) ---
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# Enhanced completion settings
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' complete-options true
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Better directory completion
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' accept-exact '*(N)'

# fzf-tab previews (use eza if available, fallback to ls)
if command -v eza >/dev/null; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always --icons $realpath'
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
fi

# Preview for other commands
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'

# --- Replay cd hooks that zinit tracks (optional; quiet) ---
zinit cdreplay -q

# --- Optional: Auto-launch Hyprland from tty1 (put this in ~/.zprofile, not here) ---
# if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then exec Hyprland; fi

# --- Enhanced key bindings ---
# Word navigation
bindkey '^[[1;5D' backward-word   # Ctrl+Left  -> move one word left
bindkey '^[[1;5C' forward-word    # Ctrl+Right -> move one word right

# Line navigation
bindkey '^A' beginning-of-line    # Ctrl+A -> beginning of line
bindkey '^E' end-of-line          # Ctrl+E -> end of line

# Delete operations
bindkey '^[[3;5~' kill-word       # Ctrl+Delete -> delete word forward
bindkey '^H' backward-kill-word   # Ctrl+Backspace -> delete word backward
bindkey '^U' backward-kill-line   # Ctrl+U -> delete to beginning of line
bindkey '^K' kill-line            # Ctrl+K -> delete to end of line

# History search (with already-typed text)
bindkey '^[[A' history-beginning-search-backward  # Up arrow
bindkey '^[[B' history-beginning-search-forward   # Down arrow
bindkey '^P' history-beginning-search-backward    # Ctrl+P
bindkey '^N' history-beginning-search-forward     # Ctrl+N

# Undo/Redo
bindkey '^_' undo                 # Ctrl+/ -> undo
bindkey '^Y' redo                 # Ctrl+Y -> redo

# --- Useful functions ---
# Quick directory bookmark system
hash -d dots=~/.config
hash -d hypr=~/.config/hypr
hash -d mind=~/mind/mind
hash -d dl=~/Downloads
hash -d proj=~/Projects

# Extract any archive type
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.tar.xz)    tar xJf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Find and kill process by name
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}

# Quick git commit with message (use 'gcmsg' from OMZ instead, or this shortcut)
gcmm() {
  git commit -m "$*"
}

# Quick git add all and commit
gacam() {
  git add -A && git commit -m "$*"
}

# Search shell history with fzf
fh() {
  print -z $(fc -ln 1 | fzf --tac --no-sort)
}

# Quick file search and edit
fe() {
  local file
  file=$(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}')
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

# CD to git repository root
cdgr() {
  cd "$(git rev-parse --show-toplevel 2>/dev/null || echo .)"
}

export PATH=$PATH:/home/lofi/.spicetify

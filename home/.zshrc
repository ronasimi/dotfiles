# Enable Powerlevel10k instant prompt at the absolute top (skipped in TTY)
if [[ "$TERM" != "linux" ]] && [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#           _
#   _______| |__  _ __ ___
#  |_  / __| '_ \| '__/ __|
# _ / /\__ \ | | | | | (__
#(_)___|___/_| |_|_|  \___|
#
#

# Exit early for non-interactive shells
[[ $- != *i* ]] && return

# ENVIRONMENT VARIABLES
export PATH="/home/ron/.bin:/usr/local/bin:$PATH"
export EDITOR="nano"
export VISUAL=$EDITOR
export USE_CCACHE=1
export CCACHE_DIR=/home/ron/.ccache
export CCACHE_SLOPPINESS=include_file_mtime
export AIRCRACK_LIBEXEC_PATH=/usr/lib/aircrack-ng

# PERL ENV
export PATH="/home/ron/.perl5/bin:$PATH"
export PERL5LIB="/home/ron/.perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
export PERL_LOCAL_LIB_ROOT="/home/ron/.perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_MB_OPT="--install_base \"/home/ron/.perl5\""
export PERL_MM_OPT="INSTALL_BASE=/home/ron/.perl5"

# SET TTY COLORS AND LOAD PROMPTS
if [ "$TERM" = "linux" ]; then
  # SET TTY COLORS
  _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
  for i in $(sed -n "$_SEDCMD" $HOME/.Xresources | awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
    echo -en "$i"
  done
  clear

  # TTY NATIVE PROMPT SETUP
  autoload -Uz vcs_info
  autoload -Uz add-zsh-hook

  # Configure Git integration
  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:git:*' formats '%F{blue}git:(%b)%f'
  zstyle ':vcs_info:git:*' actionformats '%F{blue}git:(%b|%a)%f'

  # Hook vcs_info to run before every command
  function tty_precmd() { vcs_info }
  add-zsh-hook precmd tty_precmd

  # LEFT PROMPT (Flush left, pure ASCII)
  # Line 1: [White Dir] [Blue Git Status]
  # Line 2: [Green >]
  PROMPT=$'%F{white}%~%f ${vcs_info_msg_0_}\n%F{green}>%f '

  # RIGHT PROMPT (Pure ASCII)
  # Shows exit code (! 1) in red if a command fails, plus current time (HH:MM) in cyan
  RPROMPT='%(?::%F{red}! %?%f )%F{cyan}%D{%H:%M}%f'
else
  # POWERLEVEL10K (GUI)
  if [[ -f /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]]; then
    source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
  fi
  export SUDO_PROMPT="$(tput setaf 1)*sudo*$(tput setaf 0) password for %p: $(tput sgr0)"
  POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

# HISTORY SETTINGS
HISTFILE=~/.histfile
HISTSIZE=12000
SAVEHIST=10000
setopt appendhistory
setopt extended_history
setopt inc_append_history
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_reduce_blanks
setopt hist_verify

# GENERAL OPTIONS
setopt autocd
setopt extendedglob
setopt nomatch
setopt notify
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent
setopt pushd_to_home
setopt rm_star_wait
setopt magic_equal_subst
setopt multios
setopt prompt_subst
setopt ignore_eof
unsetopt beep

# MODULES & COMPLETION
autoload -U colors zsh-mime-setup select-word-style
colors
zsh-mime-setup
select-word-style bash

autoload -Uz compinit
compinit -C
zmodload -i zsh/complist

setopt hash_list_all
setopt completealiases
setopt COMPLETE_ALIASES
setopt always_to_end
setopt complete_in_word
setopt correct_all
setopt list_ambiguous
setopt interactivecomments
CORRECT_IGNORE_FILE='.*'

# COMPLETION STYLING
zstyle ':completion::complete:*' use-cache on
zstyle ':completion:*' rehash true
zstyle ":completion:*:commands" rehash true
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} =
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes
zstyle ':completion:*' verbose yes
zstyle ':completion:*' force-list always
zstyle ':completion:*:descriptions' format $'\e[00;34m%d'
zstyle ':completion:*:messages' format $'\e[00;31m%d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=29=34"
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always
zstyle ':completion:*:*:killall:*:processes' list-colors "=(#b) #([0-9]#)*=29=34"
zstyle ':completion:*' users ron root

# ALIASES
alias ls='eza --group-directories-first --git --header --icons=never'
alias cd='z'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias orphans='[[ -n $(pacman -Qdt) ]] && sudo pacman -Rs $(pacman -Qdtq) || echo "no orphans to remove"'
alias help=run-help

# FUNCTIONS
xterm_title_precmd () {
  print -Pn -- '\e]2;%n@%m %~\a'
  [[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

xterm_title_preexec () {
  print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
  [[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}

zshalias() {
  grep "^alias" ~/.zshrc > ~/.zshenv
}

google() {
  local search=""
  echo "Googling: $@"
  for term in $@; do search="$search%20$term"; done
  xdg-open "http://www.google.com/search?q=$search"
}

# HOOKS & TERMINAL TITLES
autoload -Uz add-zsh-hook
if [[ "$TERM" == (alacritty*|gnome*|konsole*|putty*|rxvt*|screen*|tmux*|xterm*) ]]; then
  add-zsh-hook -Uz precmd xterm_title_precmd
  add-zsh-hook -Uz preexec xterm_title_preexec
fi

# KEY BINDINGS & ZLE
bindkey -v
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey '\eOA' up-line-or-beginning-search
bindkey '\eOB' down-line-or-beginning-search
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc"  emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd"  emacs-backward-word
bindkey "\eeOC" forward-word
bindkey "\eeOD" backward-word
bindkey "^H"    backward-delete-word
bindkey "^R" history-incremental-search-backward
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey '^i' expand-or-complete-prefix
bindkey -M vicmd "^[[2~" vi-insert
bindkey -M viins "^[[2~" vi-cmd-mode

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init () { printf '%s' "${terminfo[smkx]}" }
  function zle-line-finish () { printf '%s' "${terminfo[rmkx]}" }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

if [[ "$TERM" == "xterm-kitty" || -n "$KITTY_PID" \
      || "$TERM" == "alacritty" || -n "$ALACRITTY_LOG" \
      || -n "$ITERM_SESSION_ID" || -n "$WEZTERM_PANE" \
      || "$TERM" == "foot" || "$TERM" == "foot-extra" \
      || "$TERM" == "kmscon" || "$TERM" == "xterm-256color" ]]; then

    function zle-keymap-select() {
        if [[ ${KEYMAP} == vicmd ]]; then
            echo -ne "\e[6 q"
        else
            echo -ne "\e[2 q"
        fi
    }
    zle -N zle-keymap-select

    function zle-line-init() {
        echo -ne "\e[2 q"
    }
    zle -N zle-line-init
fi

# INTEGRATIONS (FZF, THEFUCK, ZOXIDE, PKGFILE)
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
[[ -f /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh

command -v thefuck >/dev/null 2>&1 && eval "$(thefuck --alias)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;38;5;74m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;33;246m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;38;5;146m'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# AUTOSUGGESTIONS & SYNTAX HIGHLIGHTING (MUST BE LAST)
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  export ZSH_AUTOSUGGEST_USE_ASYNC=1
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

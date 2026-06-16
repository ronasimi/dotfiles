#           _
#   _______| |__  _ __ ___
#  |_  / __| '_ \| '__/ __|
# _ / /\__ \ | | | | | (__
#(_)___|___/_| |_|_|  \___|
#
#

# vi mode
bindkey -v

# Exit early for non-interactive shells
[[ $- != *i* ]] && return

# SET TTY COLORS AND LOAD PROMPTS
if [ "$TERM" = "linux" ]; then
  # Cache the sed/awk output to prevent blocking startup
  if [[ ! -f $HOME/.cache/xres_colors ]]; then
    _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    sed -n "$_SEDCMD" $HOME/.Xresources | awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}' > $HOME/.cache/xres_colors
  fi
  echo -en "$(cat $HOME/.cache/xres_colors)"
  clear
  autoload -Uz promptinit
  promptinit
  prompt walters
else
  # POWERLEVEL10K
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
  if [[ -f /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]]; then
    source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
  fi
  # POWERLINE STYLE SUDO
  export SUDO_PROMPT="$(tput setaf 1)*sudo*$(tput setaf 0) password for %p: $(tput sgr0)"
  POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
  [[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh
fi

# WINDOW TITLE
autoload -Uz add-zsh-hook
function xterm_title_precmd () {
	print -Pn -- '\e]2;%n@%m %~\a'
	[[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}
function xterm_title_preexec () {
	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}
if [[ "$TERM" == (alacritty*|gnome*|konsole*|putty*|rxvt*|screen*|tmux*|xterm*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

# HISTORY
HISTFILE=$HOME/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory extended_history inc_append_history share_history hist_expire_dups_first hist_ignore_all_dups hist_find_no_dups hist_ignore_space hist_save_no_dups hist_reduce_blanks hist_verify hist_beep autocd extendedglob nomatch notify
autoload -U colors zsh-mime-setup select-word-style
colors
zsh-mime-setup
select-word-style bash

# FZF & ZLE
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh

# KEY BINDINGS & ZSTYLE
zstyle :compinstall filename '$HOME/.zshrc'
ZLE_RPROMPT_INDENT=0
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[3~" delete-char
bindkey "^H" backward-delete-word
bindkey '^i' expand-or-complete-prefix

# COMPLETION & ALIASES
autoload -Uz compinit
compinit -C
setopt hash_list_all completealiases always_to_end complete_in_word correct_all list_ambiguous interactivecomments
alias ls='eza --group-directories-first --git --header --icons=auto'
alias cd='z'
alias grep='grep --color=auto'

# IMPROVED SUDO ALIAS (Functions handle arguments correctly)
sudo() {
    command sudo env PATH=$PATH "$@"
}

# THE FUCK (Cached)
if command -v thefuck >/dev/null 2>&1; then
  [[ ! -f $HOME/.cache/thefuck-init.zsh ]] && thefuck --alias > $HOME/.cache/thefuck-init.zsh
  source $HOME/.cache/thefuck-init.zsh
fi

# ZOXIDE (Cached)
if command -v zoxide >/dev/null 2>&1; then
  [[ ! -f $HOME/.cache/zoxide-init.zsh ]] && zoxide init zsh > $HOME/.cache/zoxide-init.zsh
  source $HOME/.cache/zoxide-init.zsh
fi

# EXPORTS
export PATH=/usr/local/bin:$HOME/.bin:$PATH
export EDITOR="nano"
export VISUAL=$EDITOR
export USE_CCACHE=1
export CCACHE_DIR=$HOME/.ccache

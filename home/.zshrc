#           _
#   _______| |__  _ __ ___
#  |_  / __| '_ \| '__/ __|
# _ / /\__ \ | | | | | (__
#(_)___|___/_| |_|_|  \___|
#
#

# vi mode
bindkey -v

# SET TTY COLORS AND LOAD PROMPTS DEPENDING ON WHERE WE ARE
if [ "$TERM" = "linux" ]; then
    _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    for i in $(sed -n "$_SEDCMD" $HOME/.Xresources | awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
      echo -en "$i"
    done
    clear
  autoload -Uz promptinit
  promptinit
  prompt walters
else
  # POWERLEVEL10K
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
  source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
  # POWERLINE STYLE SUDO
  export SUDO_PROMPT="$(tput setaf 1)*sudo*$(tput setaf 0) password for %p: $(tput sgr0)"
  POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
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

HISTFILE=~/.histfile
HISTSIZE=10000
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
setopt hist_beep
setopt autocd
setopt extendedglob
setopt nomatch
setopt notify
autoload -U colors zsh-mime-setup select-word-style
colors          # colors
zsh-mime-setup  # run everything as if it's an executable
select-word-style bash # ctrl+w on words

# History search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# FZF
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# FOR URXVT
#bindkey "^[[A" up-line-or-beginning-search # Up
#bindkey "^[[B" down-line-or-beginning-search # Down

# FOR ALACRITTY
bindkey '\eOA' up-line-or-beginning-search # or ^[OA
bindkey '\eOB' down-line-or-beginning-search # or ^[OB
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

zstyle :compinstall filename '/home/ron/.zshrc'

ZLE_RPROMPT_INDENT=0

# Transient prompt works similarly to the builtin transient_rprompt option. It trims down prompt
# when accepting a command line. Supported values:
#
#   - off:      Don't change prompt when accepting a command line.
#   - always:   Trim down prompt when accepting a command line.
#   - same-dir: Trim down prompt when accepting a command line unless this is the first command
#               typed after changing current working directory.
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

# Key bindings
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
# for rxvt
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "eOH" beginning-of-line
bindkey "eOF" end-of-line
# for freebsd console
bindkey "e[H" beginning-of-line
bindkey "e[F" end-of-line
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# Help functions
autoload -Uz run-help
unalias run-help &>/dev/null
alias help=run-help
autoload -Uz run-help-git
autoload -Uz run-help-ip
autoload -Uz run-help-openssl
autoload -Uz run-help-p4
autoload -Uz run-help-sudo
autoload -Uz run-help-svk
autoload -Uz run-help-svn

# AUTOCOMPLETION
autoload -Uz compinit
compinit
zmodload -i zsh/complist
setopt hash_list_all            # hash everything before completion
setopt completealiases          # complete aliases
setopt COMPLETE_ALIASES		      # complete command line switches
setopt always_to_end            # when completing from the middle of a word, move the cursor to the end of the word
setopt complete_in_word         # allow completion from within a word/phrase
setopt correct_all              # spelling correction for commands
setopt list_ambiguous           # complete as much of a completion until it gets ambiguous.
setopt interactivecomments	    # bash style interactive comments
CORRECT_IGNORE_FILE='.*'

zstyle ':completion::complete:*' use-cache on               # completion caching, use rehash to clear
zstyle ':completion:*' rehash true
zstyle ":completion:*:commands" rehash true
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # ignore case
zstyle ':completion:*' menu select=2                        # menu if nb items > 2
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} =     # colorz !
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate # list of completers to use

zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# sections completion !
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu yes select
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
users=(ron root)           # because I don't care about others
zstyle ':completion:*' users $users

# generic completion with --help
compdef _gnu_generic gcc
compdef _gnu_generic gdb

# Tab host completion for programs
compctl -k ping telnet host nslookup rlogin ftp

# Make completion (yeah im getting fucking lazy)
compile=(install clean remove uninstall deinstall)
compctl -k compile make

# some (useful) completions
compctl -j -P '%' fg jobs disown
compctl -g '*.(mp3|MP3|ogg|OGG|temp|TEMP)' + -g '*(-/)'  mpg123
compctl -g "*.html *.htm" + -g "*(-/) .*(-/)" + -H 0 '' w3m wget chromium
compctl -g '*.(pdf|PDF)' + -g '*(-/)'  mupdf
compctl -g '*(-/)' + -g '.*(/)' cd chdir dirs pushd rmdir dircmp cl tree
compctl -g '*.(jpg|JPG|jpeg|JPEG|gif|GIF|png|PNG|bmp)' + -g '*(-/)' gimp feh
compctl -g '[^.]*(-/) *.(c|C|cc|c++|cxx|cpp)' + -f cc CC c++ gcc g++
compctl -g '[^.]*(-/) *(*)' + -f strip ldd gdb
compctl -s '$(<~/.vim/tags)' vimhelp

# pushd
setopt auto_pushd               # make cd push old dir in dir stack
setopt pushd_ignore_dups        # no duplicates in dir stack
setopt pushd_silent             # no dir stack after pushd or popd
setopt pushd_to_home            # `pushd` = `pushd $HOME`

# AUTOCOLOR
#alias ls='ls --color=auto'
alias ls='eza --group-directories-first --git --header --icons=auto'
alias cd='z'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# colored make output
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# run zshalias to export aliases to .zshenv
function zshalias()
{
  grep "^alias" ~/.zshrc > ~/.zshenv
}

# THE FUCK
eval "$(thefuck --alias)"

# SYNTAX HIGHLIGHTING
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Modified dark color scheme
# ------------------------------------
function color
{
   if [ "$TERM" = "linux" ]; then
  /bin/echo -e "
  \e]P05f5f5f
  \e]P1a54242
  \e]P28c9440
  \e]P3de935f
  \e]P45f819d
  \e]P585678f
  \e]P65e8d87
  \e]P7afafaf
  \e]P86f6f6f
  \e]P9cc6666
  \e]PAb5bd68
  \e]PBf0c674
  \e]PC81a2be
  \e]PDb294bb
  \e]PE8abeb7
  \e]PFc5c8c6
  "
  # get rid of artifacts
  clear
fi

}

# Autosuggestions
export ZSH_AUTOSUGGEST_USE_ASYNC=1
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# PATHS
export PATH=/usr/local/bin:$PATH
export PATH=/home/ron/.bin:$PATH

# EDITOR
export EDITOR="nano"

# CCACHE
export USE_CCACHE=1
export CCACHE_DIR=/home/ron/.ccache
export CCACHE_SLOPPINESS=include_file_mtime

#PKGFILE HOOK
source /usr/share/doc/pkgfile/command-not-found.zsh

# COLORED MAN PAGES
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;38;5;74m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;33;246m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;38;5;146m'

# ZOXIDE
eval "$(zoxide init zsh)"

# AIRCRACK-NG
export AIRCRACK_LIBEXEC_PATH=/usr/lib/aircrack-ng

# 'GOOGLE' function
  google() {
    search=""
    echo "Googling: $@"
    for term in $@; do
      search="$search%20$term"
    done
  xdg-open "http://www.google.com/search?q=$search"
}
# SETUP PERL ENV
PATH="/home/ron/.perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/ron/.perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/ron/.perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/ron/.perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/ron/.perl5"; export PERL_MM_OPT;

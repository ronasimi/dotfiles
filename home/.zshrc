
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
  source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
  # POWERLINE STYLE SUDO
  export SUDO_PROMPT="$(tput setab 1)$(tput setaf 7) sudo $(tput setab 4)$(tput setaf 1)$(echo "\uE0B0")$(tput setab 4)$(tput setaf 0) password for %p $(tput sgr0)$(tput setaf 4)$(echo "\uE0B0")$(tput sgr0) "
fi


# WINDOW TITLE
case $TERM in
  termite|*xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
    precmd () { print -Pn "\e]0;%n@%m: %~\a" }
    preexec () { print -Pn "\e]0;$1\a" }
  ;;
  screen|screen-256color|tmux|tmux-256color)
    precmd () {
      print -Pn "\e]83;title \"$1\"\a"
      print -Pn "\e]0;$TERM\a"
      }
    preexec () {
      print -Pn "\e]83;title \"$1\"\a"
      print -Pn "\e]0;$TERM - $1\a"
      }
  ;;
esac

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

bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

zstyle :compinstall filename '/home/ron/.zshrc'

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
bindkey "\ee[C" forward-word
bindkey "\ee[D" backward-word
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
setopt completealiases          # complete alisases
setopt COMPLETE_ALIASES		# complete command line switches
setopt always_to_end            # when completing from the middle of a word, move the cursor to the end of the word
setopt complete_in_word         # allow completion from within a word/phrase
setopt correct_all              # spelling correction for commands
setopt list_ambiguous           # complete as much of a completion until it gets ambiguous.
setopt interactivecomments	# bash style interactive comments
CORRECT_IGNORE_FILE='.*'

zstyle ':completion::complete:*' use-cache on               # completion caching, use rehash to clear
zstyle ':completion:*' rehash true
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
alias ls='exa'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

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
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# PATHS
export PATH=/usr/local/bin:$PATH
export PATH=/home/ron/.bin:$PATH

# EDITOR
export EDITOR="nano"

# CCACHE
export USE_CCACHE=1
export CCACHE_DIR=/mnt/storage/ccache
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

# AIRCRACK-NG
export AIRCRACK_LIBEXEC_PATH=/usr/lib/aircrack-ng

# POWERLEVEL10K OPTIONS
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir_writable context dir)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs vcs)
DEFAULT_USER="ron"
POWERLEVEL9K_CONTEXT_TEMPLATE="%n@`hostname -f`"
POWERLEVEL9K_ALWAYS_SHOW_USER=true
POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind git-stash git-remotebranch git-tagname)
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="white"
POWERLEVEL9K_CONTEXT_SUDO_FOREGROUND="black"
POWERLEVEL9K_CONTEXT_SUDO_BACKROUND="orange"
POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="white"
POWERLEVEL9K_CONTEXT_ROOT_BACKROUND="red"
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND="white"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="white"
POWERLEVEL9K_VCS_BRANCH_ICON=$'\uF62C'
POWERLEVEL9K_VCS_GIT_GITHUB_ICON=$'\uF6DA '
POWERLEVEL9K_VCS_GIT_GITLAB_ICON=$'\uFB7C '
POWERLEVEL9K_VCS_GIT_ICON=$'\uF2A2 '
POWERLEVEL9K_VCS_STAGED_ICON=$'\uF415'
POWERLEVEL9K_VCS_STASH_ICON=$'\uF4E7'
POWERLEVEL9K_BACKGROUND_JOBS_ICON=$'\uF493'
POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON=$'\uF736'
POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON=$'\uF72D'
POWERLEVEL9K_VCS_REMOTE_BRANCH_ICON=$'\uF055'
POWERLEVEL9K_VCS_UNSTAGED_ICON=$'\uFA4A'
POWERLEVEL9K_VCS_UNTRACKED_ICON=$'\uF751'
POWERLEVEL9K_OK_ICON=$'\uF12C'
POWERLEVEL9K_FAIL_ICON=$'\uF026'
POWERLEVEL9K_ROOT_ICON=$'\uF005'
POWERLEVEL9K_SUDO_ICON=$'\uF005'
POWERLEVEL9K_SSH_ICON=$'\uF011'
POWERLEVEL9K_HOME_ICON=$'\uF2DC'
POWERLEVEL9K_HOME_SUB_ICON=$'\uF24b'
POWERLEVEL9K_LOCK_ICON=$'\uF33E'
POWERLEVEL9K_FOLDER_ICON=$'\uF256'
POWERLEVEL9K_ETC_ICON=$'\uF493'
POWERLEVEL9K_EXECUTION_TIME_ICON=$'\uF78B'

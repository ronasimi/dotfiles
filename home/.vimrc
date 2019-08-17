set shell=zsh
filetype plugin on
filetype indent on
syntax on
colo pablo
set encoding=utf-8
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set mouse=a
set ttymouse=xterm
set number
let g:airline_powerline_fonts=1
let g:airline_theme='angr'
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
:hi Comment cterm=italic

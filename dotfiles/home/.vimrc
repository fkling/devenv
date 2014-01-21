set shell=/bin/sh
"This must be first, because it changes other options as a side effect.
set nocompatible

" Vundle init
filetype off                  " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" let Vundle manage Vundle
Bundle 'gmarik/vundle'

" Include bundles
source ~/.vim_bundles

"allow backspacing over everything in insert mode
set backspace=indent,eol,start

"always show status line
set laststatus=2

"store lots of :cmdline history
set history=1000

set showcmd "show incomplete cmds down the bottom
set showmode "show current mode down the bottom

set number "show line numbers

"display tabs and trailing spaces
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅,eol:¬

set incsearch "find the next match as we type the search
set hlsearch "hilight searches by default

set wrap "dont wrap lines
set linebreak "wrap lines at convenient points


"load ftplugins and indent files
filetype plugin on
filetype indent on

"turn on syntax highlighting
syntax on

"set colorscheme
set background=light
colorscheme solarized

" For coding
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set number
set ruler
set autoindent

"statusline setup
set statusline =%#identifier#
set statusline+=[%f] "path of the filename
set statusline+=%*

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

""display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h "help file flag
set statusline+=%y "filetype

"read only flag
set statusline+=%#identifier#
set statusline+=%r
set statusline+=%*

""modified flag
set statusline+=%#identifier#
set statusline+=%m
set statusline+=%*

" Mark column 81
set cc=81
set cursorline

" Syntastic
let g:syntastic_javascript_checkers=['jshint']
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" misc
set exrc            " enable per-directory .vimrc files
set secure          " disable unsafe commands in local .vimrc files

" Better gep
set grepprg=grep\ -nH\ $*

"Fix for terminal
imap <C-@> <C-Space>
"make <c-space> clear the highlight as well as redraw
nnoremap <Space> :nohls<CR><Space>
inoremap <C-Space> <C-O>:nohls<CR>

"<S-T> to trim line endings
nmap <S-T> :%s/\s\+$//<CR>

"map Q to something useful
noremap Q gq

"make Y consistent with C and D
nnoremap Y y$

let mapleader=","
inoremap <leader>, <C-N>

" edit and load vimrc
nnoremap <leader>ev :vsp $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" map esc key
inoremap jk <esc>

" easy tabs
nnoremap H :tabp<cr>
nnoremap L :tabn<cr>
nnoremap T :tabe<cr>
" open split in new tab
nnoremap eT :tabe %<cr>:tabp<cr>:q<cr>:tabn<cr>

"Since we have a custom status line, we have to add the ruler options
set statusline+=%=%-14.(%l,%c%V%)\ %P

"Add spellcheck
set spell spelllang=en_us

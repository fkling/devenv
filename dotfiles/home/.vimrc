"This must be first, because it changes other options as a side effect.
set nocompatible

set nocompatible               " Be iMproved
filetype off                  " required!
let mapleader=","

" Required
set rtp+=~/.vim/bundle/vundle
call vundle#begin()
source ~/.vim_bundles
call vundle#end()

""""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""""
" Display.
set ruler " show cursor coordinates
set title " show filename
set number " show line numbers
set showcmd " show normal mode commands as they are entered
set showmode " show editing mode in status line
set showmatch " flash matching delimiters

set cc=81 " Mark column 81
set cursorline

set nolist " no metacharacters
set listchars=tab:»·,trail:·,eol:¬ " tabs, trailing ws, eol character

" Autocomplete.
set wildmode=longest,list,full
set wildmenu
set wildignore+=*.o,*.pyc,*.aux,*.cmi,*.cmo,*.cmx
set completeopt=menu,menuone,preview

" Search.
set nohlsearch " don't persist search highlighting
set incsearch " search with a typeahead
set magic " use (some) regexp special characters
set ignorecase " ignore case...
set smartcase " ...iff all characters are lower case
set infercase " case-sensitive completion

" Scrolling.
set wrap " wrap overlong lines
set scrolloff=0 " don't scroll unless necessary
set scrolljump=5 " scroll five lines at a time
set linebreak "wrap lines at convenient points

" Turn things off.
set nofoldenable " no folding
set mouse= " no mouse
set noerrorbells " no error bells
set vb t_vb= " no visual bells

" Backspace over everything.
set backspace=indent,eol,start

" Get rid of security holes.
set nomodeline
set modelines=0

" Add mouse support
set mouse=a
set ttymouse=xterm2


""""""""""""""""""""""""""""""""""""""""""
" Syntax highlighting and indent
""""""""""""""""""""""""""""""""""""""""""
" Turn on syntax highlighting and enable filetype stuff.
syntax enable
filetype plugin indent on

" Use solarized for color.
" set t_Co=16
set background=light
colorscheme solarized

" Tab and indent.
set autoindent " carry indent over to new lines
set shiftwidth=2 " two spaces per indent
set tabstop=2 " number of spaces per tab when viewing
set softtabstop=2 " number of spaces per tab when inserting
set expandtab " sub spaces for tabs
set smarttab " make tab key obey indent rules specified above

" Highlight trailing whitespace.
hi ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * hi ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/


""""""""""""""""""""""""""""""""""""""""""
" Cache and backups
""""""""""""""""""""""""""""""""""""""""""

" Save marks for ' files, registers for " files, and : lines of history.
set viminfo='20,"20,:50

" History and undo caches.
set history=50        " not too much history
set undolevels=1000   " lots of undo!

" Keep backup junk out of cwd.
set directory=~/tmp//,/tmp//,.
set backupdir=~/tmp//,/tmp//,.

" Save cursor position for reopening.
au BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif


""""""""""""""""""""""""""""""""""""""""""
" Buffers and windows
""""""""""""""""""""""""""""""""""""""""""

" Settings.
set hidden            " keep hidden buffers around
set noautoread          " no automatically re-read modified files
set splitright        " hsplit to the right
set splitbelow        " vsplit to the left
set laststatus=2      " always show a status line

" Window navigation.
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l

" Buffer navigation.
nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprev<CR>

" Quickfix and preview windows.
nnoremap <leader>co :copen<CR>
nnoremap <leader>cc :cclose<CR>
nnoremap <leader>zz :pclose<CR>


""""""""""""""""""""""""""""""""""""""""""
" Maps
""""""""""""""""""""""""""""""""""""""""""

" Switch modes more easily.
nnoremap ; :
inoremap jk <Esc>
inoremap kjk <Esc>

" Make Y behave more like other operators.
nnoremap Y y$

" Make Q formatting; replace Ex mode with <leader>q.
noremap  Q gq
nnoremap <leader>q Q

" Replace <C-a> to accommodate screen escape character.
inoremap <C-z> <C-a>
nnoremap <leader>a <C-a>
nnoremap <leader>x <C-x>

" Move by display line rather than file line.
nnoremap j gj
nnoremap k gk

" Jump to matching delimiters more easily.
nnoremap <leader><Tab> %
vnoremap <leader><Tab> %

" Jump to next or previous error
nnoremap [[ :lnext<CR>
nnoremap ]] :lprevious<CR>

" Other useful leader maps.
nnoremap <leader>m  :make<CR>
nnoremap <leader>l  <C-l>
nnoremap <leader>v  <C-w>v

" Toggle spellchecking and paste.
nnoremap <leader>s  :setl spell!<CR>:setl spell?<CR>
nnoremap <leader>p  :setl paste!<CR>:setl paste?<CR>
nnoremap <leader>t  :setl list!<CR>:setl list?<CR>
nnoremap <leader>n  :setl number!<CR>:setl number?<CR>

" Remove trailing whitespace.
nnoremap <silent> <leader>w :%s/\s\+$//<CR>:let @/=''<CR>''

" Convert filetype to unix.
nnoremap <leader>ff :e ++ff=dos<CR>:setlocal ff=unix<CR>
"
" Edit and reload vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Only cabbrev actual commands (rather than also, say, search terms).
fu! SingleQuote(str)
  return "'" . substitute(copy(a:str), "'", "''", 'g') . "'"
endfu
fu! Cabbrev(key, value)
  exe printf('cabbrev <expr> %s (getcmdtype() == ":" && getcmdpos() <= %d) ? %s : %s',
    \ a:key, 1+len(a:key), SingleQuote(a:value), SingleQuote(a:key))
endfu

" Plugins
" Open gundo
nnoremap <leader>u :GundoToggle<CR>


""""""""""""""""""""""""""""""""""""""""""
" Tags
""""""""""""""""""""""""""""""""""""""""""

" Search up the directory tree for tags.
set tags=tags;/

" Use cscope along with ctags if it's available.
if has("cscope")
  " Defer to ctags.
  set cscopetagorder=1

  " Use :cstag instead of :tag and friends (<C-]>, etc.).
  set cscopetag

  " Add cscope databases in `pwd` or in $CSCOPE_DB.
  set nocscopeverbose
  if filereadable("cscope.out")
    cs add cscope.out
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif
  set cscopeverbose
else
  " Use :tjump behavior for :tag and friends even without cscope.
  call Cabbrev('tag', 'tjump')
  nnoremap <C-]> g<C-]>
  vnoremap <C-]> g<C-]>
  nnoremap <C-W>] <C-W>g<C-]>
endif

command! -nargs=1 -complete=tag Vstag vsp | tag <args>
call Cabbrev('vstag', 'Vstag')


""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""

" Airline - Use powerline glyphs.
let g:airline_powerline_fonts=1

" Syntastic
let g:syntastic_javascript_checkers=['jsxhint']
let g:syntastic_javascript_jsxhint_args = '--harmony'
let g:syntastic_php_checkers=['php']
" let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1

" signify
let  g:signify_vcs_list = [ 'git' ]

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" incsearch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

""""""""""""""""""""""""""""""""""""""""""
" Miscellaneous
""""""""""""""""""""""""""""""""""""""""""

" Set language defaults.
let g:tex_flavor='latex'
let g:sql_type_default='mysql'

" Set maximum line length.
au FileType liquid,markdown,readme,tex,text setl tw=79

" Kill any trailing whitespace on save.
fu! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfu
au FileType c,cabal,cpp,haskell,javascript,ocaml,php,python,ruby,readme,tex,text
  \ au BufWritePre <buffer>
  \ :call <SID>StripTrailingWhitespaces()

" enable per-directory .vimrc files
set exrc
" disable unsafe commands in local .vimrc files
set secure

" Better gep
set grepprg=grep\ -nH\ $*

" signify
let g:signify_vcs_list = [ 'hg', 'git' ]

set spell spelllang=en_us

" clipper
nnoremap <leader>y :call system('nc localhost 8377', @0)<CR>


""""""""""""""""""""""""""""""""""""""""""
" Local settings
""""""""""""""""""""""""""""""""""""""""""
if (filereadable(glob("~/.vimrc.local")))
  source ~/.vimrc.local
endif

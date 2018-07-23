syntax on
syntax enable
let c_comment_strings=1
set ruler
set ts=4
set sw=4
set expandtab
set smarttab
set shiftround
set nojoinspaces
set visualbell
set hlsearch
set nocp
set smartindent
set shiftround
set nojoinspaces
set autoindent
set incsearch
set backspace=2
set foldmethod=indent
set nofoldenable
set pastetoggle=<F2>
set mouse=a
"set cmdheight=2

inoremap jk <Esc>

nmap :W :w
nmap :Q :q

au BufEnter *.hs,*.m,*.c,*.h,*.pl,*.cpp,*.cc,*.i,*.ml,*.java,*.js,*.html,*.idr,*.tpl,*.clj,*.rs :set nu
nmap <silent> <F11> :set nu! nu?<CR>

let mapleader = "\<SPACE>"

noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

noremap <leader>w :w<CR>
noremap <leader>f :fin
noremap <leader>k :bdelete<CR>
noremap <leader>n :bnext<CR>
noremap <leader>p :bprev<CR>
noremap <leader>b :ls<CR>

" Vim-Plug
call plug#begin('~/.vim/plugged')

Plug 'ndmitchell/ghcid'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'

call plug#end()

" ale config
let g:ale_set_quickfix = 1

let g:ale_linters = {
\   'haskell': ['hlint', 'stack-ghc'],
\}

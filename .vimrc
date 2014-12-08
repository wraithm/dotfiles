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
"set cmdheight=2

nmap :W :w
nmap :Q :q

au BufEnter *.hs,*.m,*.c,*.h,*.pl,*.cpp,*.cc,*.i,*.ml,*.java,*.js,*.html,*.idr,*.tpl,*.clj,*.rs :set nu
nmap <silent> <F11> :set nu! nu?<CR>

let mapleader = ","

" nmap <F5> :tabe 
" nmap <F6> gT
" nmap <F7> gt
" imap <F5> <ESC>:tabe 
" imap <F6> <ESC>gTi
" imap <F7> <ESC>gti

noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

map gz :bdelete<CR>
map gb :bnext<CR>
map gB :bprev<CR>

"nmap <F4> :make! <BAR> copen<CR><CR>
"imap <F4> <ESC>:make! <BAR> copen<CR><CR>

" VimRoom
nnoremap <Leader>vr :VimroomToggle<CR>
let g:vimroom_width=120

" gundo
nnoremap <Leader>gu :GundoToggle<CR>

"let g:pathogen_disabled = [ 'syntastic' ]
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

" Javascript
let javascript_enable_domhtmlcss=1

" Syntastic cabal sandboxes
" function! s:get_cabal_sandbox()
"   if filereadable('cabal.sandbox.config')
"     let l:output = system('cat cabal.sandbox.config | grep local-repo')
"     let l:dir = matchstr(substitute(l:output, '\n', ' ', 'g'), 'local-repo: \zs\S\+\ze\/packages')
"     return '-s ' . l:dir
"   else
"     return ''
"   endif
" endfunction
"  
" let g:syntastic_haskell_ghc_mod_args = s:get_cabal_sandbox()

" While hdevtools is out of commission
let g:syntastic_haskell_checkers = ['ghc_mod', 'hlint']
"let g:syntastic_haskell_checkers = ['hdevtools', 'hlint']
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

" hsimport
function! FindCabalSandbox()
   let l:sandbox    = finddir('.cabal-sandbox', './;')
   let l:absSandbox = fnamemodify(l:sandbox, ':p')
   return l:absSandbox
endfunction

"function! HaskellSourceDir()
"   return fnamemodify(FindCabalSandbox(), ':h:h')
"endfunction
function! HaskellSourceDir()
    return fnamemodify(FindCabalSandbox(), ':h:h') . '/src'
endfunction

function! FindCabalSandboxPackageConf()
   return glob(FindCabalSandbox() . '*-packages.conf.d')
endfunction

"let g:hdevtools_options = '-g-isrc -g-Wall'
let g:hdevtools_options = '-g-package-conf=' . FindCabalSandboxPackageConf() . ' -g-Wall'
let g:hdevtools_src_dir = HaskellSourceDir()

"au BufEnter *.hs nmap <leader>t :HdevtoolsType<CR>
"au BufEnter *.hs nmap <leader>nt :HdevtoolsClear<CR>

"let g:ghcimportedfrom_browser = 'chromium'
"au FileType haskell nnoremap <buffer> <F3> :GhcImportedFromOpenHaddock<CR>
"au FileType haskell nnoremap <buffer> <F4> :GhcImportedFromEchoUrl<CR>

au BufEnter *.hs nmap <silent> <F5> :silent update <bar> HsimportModule<CR>
au BufEnter *.hs nmap <silent> <F6> :silent update <bar> HsimportSymbol<CR>

" haskell bindings
au BufEnter *.hs nmap <silent> <leader>y :%!stylish-haskell<CR>
au BufEnter *.hs nmap <silent> <leader>e :Errors<CR>
au BufEnter *.hs nmap <leader>s :SyntasticToggleMode<CR>

" Look for tags file
set tags=tags;/,codex.tags;/

" Tagbar
let g:tagbar_usearrows = 1
nnoremap <silent> <leader>l :TagbarToggle<cr>

" NERDTree map
noremap <silent> <leader>k :NERDTreeToggle<cr>

" Colors
"set background=dark
"let g:solarized_termcolors=256
"let g:solarized_termtrans=1
"colorscheme solarized

let g:hybrid_use_Xresources = 1
colorscheme hybrid

"colors mine
"colorscheme delek
"colorscheme jellybeans
"colorscheme tango-dark
"colorscheme Tomorrow-Night

" Haskell
" TESTING
"au Bufenter *.hs compiler ghc
"let g:haddock_browser = "/usr/bin/chromium"
"let g:haddock_docdir  = "/usr/share/doc/ghc/html/haddock"
"let g:haddock_indexfiledir = "/home/matt/.vim/"
au BufEnter *.hs setlocal omnifunc=necoghc#omnifunc
" TESTING

" Neocomplete
au BufEnter *.hs,*.css,*.html,*.tpl :NeoCompleteEnable
au BufEnter *.hs let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_camel_case_completion = 1
let g:neocomplete#enable_underbar_completion = 1
inoremap <expr><CR> neocomplete#smart_close_popup() . "\<CR>"
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
let g:necoghc_enable_detailed_browse = 1

au FileType css setlocal omnifunc=csscomplete#CompleteCSS
au FileType html setlocal omnifunc=htmlcomplete#CompleteTags
au BufEnter *.tpl setlocal omnifunc=htmlcomplete#CompleteTags

" GhcMod typechecking
let g:ghcmod_type_highlight = 'Visual'
au BufEnter *.hs nmap <leader>t :set cmdheight=2<CR>:GhcModType<CR>
au BufEnter *.hs nmap <leader>nt :GhcModTypeClear<CR>:set cmdheight=1<CR>

au BufEnter *.hs,*.lhs set cscopeprg=hscope

" Java
au BufEnter *.java set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#
au BufEnter *.java set makeprg=ant\ -find\ build.xml

" AutoClose Parens and brackets
"au BufEnter *.java,*.c,*.cpp,*.cc,*.h inoremap ( ()<Left>
"au BufEnter *.java,*.c,*.cpp,*.cc,*.h inoremap {<cr> {<cr>}<esc>O
"au BufEnter *.java,*.c,*.cpp,*.cc,*.h inoremap {{ {
"au BufEnter *.java,*.c,*.cpp,*.cc,*.h inoremap {} {}

let filetype_i = "nasm"
au BufEnter *.idr set syntax=haskell
au BufEnter *.tpl set syntax=html

augroup MUTT
"au BufRead ~/.mutt/temp/mutt* set spell
au BufRead ~/.mutt/temp/mutt* set tw=72
au BufRead ~/.mutt/temp/mutt* nmap <C-n> ggO<ESC>ggO
au BufRead ~/.mutt/temp/mutt* nmap <C-b> {gq}
au BufRead ~/.mutt/temp/mutt* set syntax=mail 
au BufRead ~/.mutt/temp/mutt* set fo=tcrq
"au BufRead ~/.mutt/temp/mutt* colorscheme delek
"au BufRead ~/.mutt/temp/mutt* :normal ,cqmh
"au BufRead ~/.mutt/temp/mutt* :normal ,ceql
"au BufRead ~/.mutt/temp/mutt* :normal ,db
"au BufRead ~/.mutt/temp/mutt* :normal ,cqel
"au BufRead ~/.mutt/temp/mutt* :normal ,dl 
"au BufRead ~/.mutt/temp/mutt* :normal gg/^On.*wrote:$ 
"au BufRead ~/.mutt/temp/mutt*  
augroup END

augroup LATEX 
"au BufRead ~/.mutt/temp/mutt* set spell
au BufRead,BufNewFile *.tex,*.lhs set tw=76
au BufRead,BufNewFile *.tex,*.lhs set fo=tcrq
au BufRead,BufNewFile *.tex,*.lhs nmap <C-b> {gq}
au BufRead,BufNewFile *.tex,*.lhs nmap <F3> :w<CR>:!pdflatex %<CR><CR>
au BufRead,BufNewFile *.tex,*.lhs imap <F3> <ESC>:w<CR>:!pdflatex %<CR>i
au BufRead,BufNewFile *.tex,*.lhs nmap <F4> :!evince ./*.pdf<CR><CR>
"au BufRead,BufNewFile *.tex,*.lhs imap <C-n> <ESC>I%<ESC>ji
"au BufRead,BufNewFile *.tex,*.lhs nmap <C-n> I%<ESC>j 
augroup END

function HighlightOver80()
    " Highlight 81st column "
"    if exists('+colorcolumn') 
"        set colorcolumn=81 
"        highlight colorColumn ctermbg=darkred guibg=#592929 
"    endif

    " Highlight characters beyond the 80th column. "
    highlight OverLength ctermbg=darkred ctermfg=white guibg=#592929
    match OverLength /\%>80v.\+/
endfunction

au BufRead,BufNewFile *.ml,*.mll call HighlightOver80()

au BufRead,BufNewFile *.c,*.h,*.cc set tw=80
au BufRead,BufNewFile *.c,*.h,*.cc call HighlightOver80()

" airline
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_powerline_fonts = 1
let g:Powerline_symbols = 'fancy'
let g:bufferline_echo = 0

" VimShell
let g:vimshell_prompt = "$ "

" Ag - the silver searcher
if executable('ag')
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
endif

" vim2hs
"let g:haskell_conceal = 0

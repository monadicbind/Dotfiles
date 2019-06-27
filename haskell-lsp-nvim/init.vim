" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'

let $PATH = $PATH . ':' . expand('~/.local/bin')
let mapleader=","
set timeout timeoutlen=1500
set encoding=utf8
set nocompatible
filetype off
set shell=/bin/bash
setlocal modifiable
:tnoremap <Esc> <C-\><C-n>
set rtp+=/usr/local/opt/fzf
set rtp+=~/.local/share/nvim/plugged/LanguageClient-neovim
"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>
call plug#begin('~/.local/share/nvim/plugged')

Plug 'mpickering/hlint-refactor-vim'
"Plug 'w0rp/ale'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': './install.sh'
    \ }
Plug 'Shougo/unite.vim'
Plug 'Shougo/neoyank.vim'
Plug 'derekwyatt/vim-scala'
Plug 'natebosch/vim-lsc'
Plug 'vim-airline/vim-airline'
Plug 'altercation/vim-colors-solarized'
Plug 'eagletmt/ghcmod-vim'
Plug 'neovimhaskell/haskell-vim'
Plug 'kien/rainbow_parentheses.vim'
Plug 'tyrannicaltoucan/vim-quantum'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/vimproc.vim' , {'do' : 'make'}
"Plug 'ctrlpvim/ctrpl.vim'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'alx741/vim-hindent'
Plug 'parsonsmatt/intero-neovim'
" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
"Plug 'eagletmt/neco-ghc'
Plug 'neomake/neomake'
Plug 'ryanoasis/vim-devicons'
Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }
Plug 'pbrisbin/vim-syntax-shakespeare'
" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
" Initialize plugin system
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-surround'
Plug 'sbdchd/neoformat'
Plug 'scrooloose/nerdcommenter'
Plug 'bronson/vim-trailing-whitespace'
Plug 'tpope/vim-endwise'
Plug 'Raimondi/delimitMate'
Plug 'editorconfig/editorconfig-vim'
Plug 'nelstrom/vim-qargs'
Plug 'tpope/vim-unimpaired'

call plug#end()

set number relativenumber
setlocal formatprg=hindent
filetype plugin indent on
let g:deoplete#enable_at_startup = 1
let g:haskellmode_completion_ghc = 0
"autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
syntax enable
let g:quantum_black=1
let g:quantum_italics=1
let g:airline_theme='quantum'
set background=dark
set termguicolors
colorscheme quantum
let g:airline_powerline_fonts=1
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | end
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
syntax on
filetype plugin indent on
map <C-n> :NERDTreeToggle<CR>
map <C-p> :Unite history/yank<CR>
let g:LanguageClient_serverCommands = { 'haskell': ['hie-wrapper'] }
nnoremap <F5> :call LanguageClient_contextMenu()<CR>
map <Leader>lk :call LanguageClient#textDocument_hover()<CR>
map <Leader>lg :call LanguageClient#textDocument_definition()<CR>
map <Leader>lr :call LanguageClient#textDocument_rename()<CR>
map <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
map <Leader>lb :call LanguageClient#textDocument_references()<CR>
map <Leader>la :call LanguageClient#textDocument_codeAction()<CR>
map <Leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>
" ----- hindent & stylish-haskell -----
hi link ALEError Error
hi Warning term=underline cterm=underline ctermfg=Yellow gui=undercurl guisp=Gold
hi link ALEWarning Warning
hi link ALEInfo SpellCap
" Indenting on save is too aggressive for me
let g:hindent_on_save = 0

" Helper function, called below with mappings
function! HaskellFormat(which) abort
  if a:which ==# 'hindent' || a:which ==# 'both'
    :Hindent
  endif
  if a:which ==# 'stylish' || a:which ==# 'both'
    silent! exe 'undojoin'
    silent! exe 'keepjumps %!stylish-haskell'
  endif
endfunction

" ----- w0rp/ale -----
let g:hlintRefactor#disableDefaultKeybindings = 0
"let g:ale_linters.haskell = [ 'hlint','stylish-haskell']
"let g:ale_fixers = ['brittany','hlint', 'stylish-haskell']
let g:ale_fix_on_save=0
let g:ale_fixers={
\ '*': ['hlint']
\}
let g:ale_linters = {
\   'haskell': [ 'hlint']
\}
" Use ALE (works even when not using Intero)
"let g:intero_use_neomake = 0

" Key bindings
augroup haskellStylish
  au!
  " Just hindent
  au FileType haskell nnoremap <leader>hi :Hindent<CR>
  " Just stylish-haskell
  au FileType haskell nnoremap <leader>hs :call HaskellFormat('stylish')<CR>
  " First hindent, then stylish-haskell
  au FileType haskell nnoremap <leader>hf :call HaskellFormat('both')<CR>
augroup END

" Moving between splits on a screen.
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Intero starts automatically. Set this if you'd like to prevent that.
let g:intero_start_immediately = 0
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
"let g:haskell_classic_highlighting=1      " classic highlighting
let g:hindent_on_save = 1
let g:hindent_indent_size = 2
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
" step 2: font configuration
" These are the basic settings to get the font to work (required):
set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Nerd\ Font\ Complete\ 12
set encoding=utf-8
" required if using https://github.com/bling/vim-airline
let g:airline_powerline_fonts=1


let g:haskell_classic_highlighting = 1
let g:haskell_indent_if = 3
let g:haskell_indent_case = 2
let g:haskell_indent_let = 4
let g:haskell_indent_where = 6
let g:haskell_indent_before_where = 2
let g:haskell_indent_after_bare_where = 2
let g:haskell_indent_do = 3
let g:haskell_indent_in = 1
let g:haskell_indent_guard = 2
let g:haskell_indent_case_alternative = 1
let g:cabal_indent_section = 2
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords<Paste>
let g:hindent_on_save = 1
let g:hindent_line_length = 100
let g:hindent_indent_size = 2
" Configuration for vim-scala
au BufRead,BufNewFile *.sbt set filetype=scala

" Configuration for vim-lsc
let g:lsc_enable_autocomplete = v:false
let g:lsc_server_commands = {
  \ 'scala': 'metals-vim'
  \}
let g:lsc_auto_map = {
    \ 'GoToDefinition': 'gd',
    \}

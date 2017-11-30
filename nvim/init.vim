" - Avoid using standard Vim directory names like 'plugin'
set nocompatible              " be iMproved, required
filetype off                  " required
set shell=/bin/bash
setlocal modifiable
:tnoremap <Esc> <C-\><C-n>
set runtimepath+=~/nvim-plugs/deoplete.nvim/
call plug#begin('~/nvim-plugs')
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ctrlpvim/ctrlp.vim'
"Plugin 'ensime/ensime-vim'
"Plugin 'derekwyatt/vim-scala'
"Plug 'vim-syntastic/syntastic'
"Plug 'owickstrom/neovim-ghci'
Plug 'parsonsmatt/intero-neovim'
Plug 'neomake/neomake'
" Initialize plugin system
Plug 'altercation/vim-colors-solarized'
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'eagletmt/ghcmod-vim'
Plug 'eagletmt/neco-ghc'
call plug#end()

filetype plugin indent on

call remote#host#RegisterPlugin('python3', '~/nvim-plugs/deoplete.nvim/rplugin/python3/deoplete.py', [
      \ {'sync': 1, 'name': 'DeopleteInitializePython', 'type': 'command', 'opts': {}},
     \ ])
let g:deoplete#enable_at_startup = 1

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

syntax enable
set background=dark
colorscheme solarized

augroup interoMaps
  au!
  " Maps for intero. Restrict to Haskell buffers so the bindings don't collide.

  " Background process and window management
  au FileType haskell nnoremap <silent> <leader>is :InteroStart<CR>
  au FileType haskell nnoremap <silent> <leader>ik :InteroKill<CR>

  " Open intero/GHCi split horizontally
  au FileType haskell nnoremap <silent> <leader>io :InteroOpen<CR>
  " Open intero/GHCi split vertically
  au FileType haskell nnoremap <silent> <leader>iov :InteroOpen<CR><C-W>H
  au FileType haskell nnoremap <silent> <leader>ih :InteroHide<CR>

  " Reloading (pick one)
  " Automatically reload on save
  au BufWritePost *.hs InteroReload
  " Manually save and reload
  au FileType haskell nnoremap <silent> <leader>wr :w \| :InteroReload<CR>

  " Load individual modules
  au FileType haskell nnoremap <silent> <leader>il :InteroLoadCurrentModule<CR>
  au FileType haskell nnoremap <silent> <leader>if :InteroLoadCurrentFile<CR>

  " Type-related information
  " Heads up! These next two differ from the rest.
  au FileType haskell map <silent> <leader>t <Plug>InteroGenericType
  au FileType haskell map <silent> <leader>T <Plug>InteroType
  au FileType haskell nnoremap <silent> <leader>it :InteroTypeInsert<CR>

  " Navigation
  au FileType haskell nnoremap <silent> <leader>jd :InteroGoToDef<CR>

  " Managing targets
  " Prompts you to enter targets (no silent):
  au FileType haskell nnoremap <leader>ist :InteroSetTargets<SPACE>
augroup END

" Intero starts automatically. Set this if you'd like to prevent that.
let g:intero_start_immediately = 0

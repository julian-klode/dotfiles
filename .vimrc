" Basics
set nocompatible
set modelines=0
set encoding=utf-8
set scrolloff=3
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2

" Keybindings
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

nnoremap <Esc>[5;5~ :bprev<CR>
nnoremap <Esc>[6;5~ :bnext<CR>

" Pretend tabs
set hidden
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" Indentation settings
" - defaults
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
" - autoindentation
set autoindent
filetype plugin indent on
" -i special hacks
:autocmd BufRead,BufNewFile /home/jak/Projects/Debian/apt/*/*.{cc,h} setlocal shiftwidth=3 noexpandtab tabstop=8 softtabstop=3

" Search settings
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch

" Show tabs and spaces
syntax on
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
set list
set listchars=tab:▸\ 

" NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif


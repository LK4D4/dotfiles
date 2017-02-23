set nocompatible               " Be iMproved

if has('nvim')
	let s:plug_path = '~/.local/share/nvim/site/autoload/plug.vim'
	let s:plug_dir = '~/.local/share/nvim/plugged'
else
	let s:plug_path = '~/.vim/autoload/plug.vim'
	let s:plug_dir = '~/.vim/plugged'
endif

if empty(glob(s:plug_path))
  silent execute '!curl -fLo '.s:plug_path.' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin(s:plug_dir)

Plug 'altercation/vim-colors-solarized'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'easymotion/vim-easymotion'
Plug 'ervandew/supertab'
Plug 'scrooloose/nerdcommenter'
function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
Plug 'zchee/deoplete-go', { 'for': 'go', 'do': 'make' }

Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'tpope/vim-markdown', { 'for': 'md' }
Plug 'rust-lang/rust.vim'

Plug 'tpope/vim-fugitive'
Plug 'jplaut/vim-arduino-ino'

call plug#end()

filetype plugin indent on

syntax on

let mapleader = "\<Space>"

nmap <Leader>s <Plug>(easymotion-overwin-f2)
let g:EasyMotion_smartcase = 1
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

set paste

set noexpandtab shiftwidth=4 softtabstop=4 tabstop=4
set nolist
set listchars=tab:▹\ ,trail:▿

"eol:↵,
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
set wildmode=longest,list,full
set wildmenu

set incsearch hlsearch smartcase
set path=.,,**
set gdefault
set showmatch
set modeline nowrap
set encoding=utf8
set termencoding=utf8
set laststatus=2
set cursorline
set hidden

set statusline=%F%m%r%h%w\ 
set statusline+=%=%{fugitive#statusline()}\    
set statusline+=[%{strlen(&fenc)?&fenc:&enc}]
set statusline+=\ [line\ %l\/%L]          

command! -bang -nargs=* Pt call fzf#vim#grep('GOGC=off pt --smart-case --nogroup --column --color '.shellescape(<q-args>), 0, <bang>0)

" vim-go
let g:go_def_mode = "godef"
let g:go_fmt_command = "goimports"
nnoremap <Leader>b :GoBuild<CR>

" completion
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#go#package_dot = 1
let g:deoplete#sources#go#gocode_sock = "none"
set completeopt=menuone,noinsert,noselect
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

set colorcolumn=81
set ttyfast
set wildmenu
imap jj <ESC>

" Press space to clear search highlighting
nnoremap <silent> <leader>n :noh<CR>
nnoremap <NL> i<CR><ESC>
nnoremap <C-p> :Files<CR>
nnoremap <leader>/ :Pt 

" Map toggling paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set invpaste
set mouse=a
nnoremap s :exec "normal i".nr2char(getchar())."\e"<CR>
nnoremap S :exec "normal a".nr2char(getchar())."\e"<CR>
nnoremap <F5> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <F6> :set paste<CR>m`O<Esc>``:set nopaste<CR>

nnoremap <Leader>w :w<CR>

vmap <Leader>y "*y
nmap <Leader>yy "*yy
vmap <Leader>d "*d
nmap <Leader>p "*p
nmap <Leader>P "*P
vmap <Leader>p "*p
vmap <Leader>P "*P

"disable arrows
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>

set background=dark
let g:solarized_visibility = "high"
colorscheme solarized
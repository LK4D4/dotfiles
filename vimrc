set nocompatible

let s:plug_path = '~/.vim/autoload/plug.vim'
let s:plug_dir = '~/.vim/plugged'

if empty(glob(s:plug_path))
  silent execute '!curl -fLo '.s:plug_path.' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin(s:plug_dir)

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'altercation/vim-colors-solarized'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tweekmonster/fzf-filemru'
Plug 'easymotion/vim-easymotion'
Plug 'scrooloose/nerdcommenter'

Plug 'tpope/vim-markdown', { 'for': 'md' }

Plug 'tpope/vim-fugitive'
Plug 'jplaut/vim-arduino-ino'
Plug 'fcpg/vim-osc52'

set hidden

call plug#end()

filetype plugin indent on

syntax on

let mapleader = "\<Space>"

set paste
set incsearch hlsearch

set nolist
set listchars=tab:▹\ ,trail:▿

set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
set wildmode=longest,list,full
set wildmenu
set cursorline
set laststatus=2
imap jj <ESC>
set noexpandtab shiftwidth=4 softtabstop=4 tabstop=4

set updatetime=300
set shortmess+=c
set signcolumn=yes

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

xmap <C-c> y:call SendViaOSC52(getreg('"'))<cr>

set statusline=%F%m%r%h%w
set statusline+=%=%{fugitive#statusline()}
set statusline+=[%{strlen(&fenc)?&fenc:&enc}]
set statusline+=\ [line\ %l\/%L]

" easymotion
nmap <Leader>s <Plug>(easymotion-overwin-f2)
let g:EasyMotion_smartcase = 1
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

autocmd BufWritePre *.go :CocCommand editor.action.organizeImport
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)

set colorcolumn=120

" Press space to clear search highlighting
nnoremap <silent> <leader>n :noh<CR>
nnoremap <NL> i<CR><ESC>
nnoremap <C-p> :FilesMru --tiebreak=end<CR>
nnoremap <leader>/ :Rg 

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

set background="dark"
let g:solarized_visibility = "high"
colorscheme solarized

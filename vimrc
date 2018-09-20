set nocompatible

let s:plug_path = '~/.vim/autoload/plug.vim'
let s:plug_dir = '~/.vim/plugged'

if empty(glob(s:plug_path))
  silent execute '!curl -fLo '.s:plug_path.' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin(s:plug_dir)

Plug 'altercation/vim-colors-solarized'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'easymotion/vim-easymotion'
Plug 'scrooloose/nerdcommenter'

Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'tpope/vim-markdown', { 'for': 'md' }

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'ryanolsonx/vim-lsp-python'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

Plug 'tpope/vim-fugitive'
Plug 'jplaut/vim-arduino-ino'

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


set statusline=%F%m%r%h%w\ 
set statusline+=%=%{fugitive#statusline()}\    
set statusline+=[%{strlen(&fenc)?&fenc:&enc}]
set statusline+=\ [line\ %l\/%L]          

" easymotion
nmap <Leader>s <Plug>(easymotion-overwin-f2)
let g:EasyMotion_smartcase = 1
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" fzf
command! -bang -nargs=* Pt call fzf#vim#grep('GOGC=off pt --smart-case --nogroup --column --color '.shellescape(<q-args>), 0, <bang>0)

" language client
if executable('cquery')
	   au User lsp_setup call lsp#register_server({
	         \ 'name': 'cquery',
	         \ 'cmd': {server_info->['cquery']},
	         \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
	         \ 'initialization_options': { 'cacheDirectory': '/path/to/cquery/cache' },
	         \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
	         \ })
endif

if executable('rls')
	    au User lsp_setup call lsp#register_server({
		        \ 'name': 'rls',
		        \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
		        \ 'whitelist': ['rust'],
		        \ })
endif

if executable('go-langserver')
	    au User lsp_setup call lsp#register_server({
		        \ 'name': 'go-langserver',
		        \ 'cmd': {server_info->['go-langserver', '-mode', 'stdio', '-gocodecompletion=true']},
		        \ 'whitelist': ['go'],
		        \ })
endif

nnoremap <silent> gd :LspDefinition<CR>

" vim-go
let g:go_fmt_command = "goimports"

" vim-rust
let g:rustfmt_autosave = 1

" completion
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1
set completefunc=LanguageClient#complete
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
imap <c-space> <Plug>(asyncomplete_force_refresh)
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

set colorcolumn=120

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

set background="dark"
let g:solarized_visibility = "high"
colorscheme solarized

let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')

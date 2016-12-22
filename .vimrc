call plug#begin('~/.vim/plugged')

Plug 'jlanzarotta/bufexplorer'
Plug 'crusoexia/vim-monokai'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'valloric/youcompleteme'
Plug 'https://github.com/mkitt/tabline.vim.git'
Plug 'ntpeters/vim-better-whitespace'
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'elzr/vim-json'
Plug 'yggdroot/indentline'
Plug 'https://github.com/moll/vim-node.git'
Plug 'tommcdo/vim-lion'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'henrik/vim-indexed-search'
Plug 'jiangmiao/auto-pairs'
Plug 'pangloss/vim-javascript'
Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'
Plug 'scrooloose/nerdcommenter'
Plug 'easymotion/vim-easymotion'
Plug 'moll/vim-bbye'
Plug 'rizzatti/dash.vim'

call plug#end()

autocmd vimenter * NERDTree
:imap jk <Esc>
:set rnu

function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
   endif
endfunc

" toggle bewteen
:call NumberToggle()
nnoremap <C-n> :call NumberToggle()<cr>

" nerd tree width
let g:NERDTreeWinSize=30

" theme
syntax enable
colorscheme monokai

" tap into system clipboard
:set clipboard=unnamed

" Syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']

" keep it clean
autocmd BufWritePre * StripWhitespace
:set list lcs=tab:\|\
let g:nerdtree_tabs_open_on_console_startup=1

set directory=~/.vim/swapfiles/
set backupdir=~/.vim/swapfiles/

set wildignore+=*.o,*.so,*.swp,*.zip,*.class,*.jar,node_modules

" change backspace behaviour
set backspace=indent,eol,start

" change tabs to 4 spaces
set tabstop=4
set softtabstop=0 noexpandtab
set shiftwidth=4

let mapleader=","

" some nice keystrokes mmmm bon appetito
nnoremap <leader>bb :BufExplorer<cr>
nnoremap <leader>bs :BufExplorerHorizontalSplit<cr>
nnoremap <leader>bv :BufExplorerVerticalSplit<cr>
nnoremap <leader>nt :NERDTreeTabsToggle<cr>
nnoremap <leader>- :vertical resize -5<cr>
nnoremap <leader>= :vertical resize +5<cr>

map  <Leader>w <Plug>(easymotion-w)
map  <Leader>b <Plug>(easymotion-b)
map  <Leader>j <Plug>(easymotion-j)
map  <Leader>k <Plug>(easymotion-k)
map  <Leader>n <Plug>(easymotion-n)

" map 0 to first non-blank char on line
nmap 0 ^
" replace command delete into black hole register, then paste
vmap r "_dP
" del buffers like a boss
:nnoremap <Leader>q :Bdelete<CR>
:nmap <Leader>d <Plug>DashGlobalSearch

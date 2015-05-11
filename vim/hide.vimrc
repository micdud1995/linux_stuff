"==================================================
syntax on
filetype on
filetype plugin on
set number		" show numbers of lines
set incsearch
set autoindent
set hlsearch
set showmatch
set t_Co=256
set tabstop=4
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
"==================================================

"==================================================
colorscheme gruvbox
set background=dark
"==================================================

"==================================================
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"==================================================

"==================================================
execute pathogen#infect()
autocmd VimEnter * wincmd p
autocmd VimEnter * NERDTree
autocmd VimEnter * nested :TagbarOpen
"==================================================

"==================================================
" Better copy/paste, go to insert, press F2 and paste text
set pastetoggle=<F2>
set clipboard=unnamed
"==================================================

"==================================================
" ctrl+n to off backlight while finding in text
noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>
"==================================================

"==================================================
" No backup and swam files
set nobackup
set nowritebackup
set noswapfile
"==================================================

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
" Look and themes
" colorscheme gruvbox
colorscheme sorcerer
"==================================================

"==================================================
" Syntastic options
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"==================================================

"==================================================
" Autostart
execute pathogen#infect()
autocmd VimEnter * wincmd p

" Open Taglist only with specific files
" autocmd FileType c,h,cpp,java nested :TlistOpen
" Taglist on the right side
" let Tlist_Use_Right_Window = 1
"
" Open Tagbar only with specific files
autocmd FileType c,h,cpp,java nested :TagbarOpen

" Open NERDTree only with specific files
autocmd FileType c,h,cpp,java nested :NERDTree
" Width of NERDTree section
let g:NERDTreeWinSize = 20
"==================================================

"==================================================
" Better copy/paste (go to insert, press F2 and paste text)
set pastetoggle=<F2>
set clipboard=unnamed
"==================================================

"==================================================
" jj instead od ESC
inoremap jj <ESC> 
" ctrl+n to off backlight during search in text
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

"==================================================
" Keyboard commands

" NerdTree 
" i - open the selected file in a horizontal split window
" s - open the selected file in a vertical split window
" I - toggle hidden files
" R - refresh the tree


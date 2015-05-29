"==================================================
set nocompatible
syntax on
filetype on
filetype plugin on
set smartindent
set autoindent
set showmatch
set t_Co=256
"==================================================
	
"==================================================
"Set incremental searching	
set incsearch

"Highlight searching
set hlsearch

" A tab is 4 spaces
set tabstop=4

" Ignore case when searching
set ignorecase

" Remember more commands
set history=1000

" Use many muchos levels of undo
set undolevels=1000

" Don't beep
set visualbell
set noerrorbells

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Highlight current line and column
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn

" Cursor stays in the middle of the screen
set scrolloff=999

" show numbers of lines
set number
set relativenumber

" Write the old file out when switching between files.
" set autowrite

" Display current cursor position in lower right corner.
set ruler

"Better line wrapping 
set wrap
set textwidth=79
set formatoptions=qrn1

"Enable code folding
" set foldenable

"Hide mouse when typing
set mousehide

" More useful command-line completion
set wildmenu

"Auto-completion menu
set wildmode=list:longest
"==================================================

"==================================================
" Look and themes
" colorscheme gruvbox
" colorscheme railscasts
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
autocmd FileType c,h,cpp,java nested :TlistOpen
" Taglist on the right side
let Tlist_Use_Right_Window = 1
"
" Open Tagbar only with specific files
" autocmd FileType c,h,cpp,java nested :TagbarOpen

" Open NERDTree only with specific files
autocmd FileType c,h,cpp,java nested :NERDTree
" Width of NERDTree section
let g:NERDTreeWinSize = 20

" Kill the capslock when leaving insert mode.
autocmd InsertLeave * set iminsert=0
"==================================================

"==================================================
" Better copy/paste (go to insert, press F2 and paste text)
set pastetoggle=<F2>
set clipboard=unnamed
"==================================================

"==================================================
" jk instead od ESC
inoremap jk <ESC> 

" Faster commands 
noremap ; :
" Space to enter insert mode
vmap <Space> i

" Disable the arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" ctrl+n to off backlight during search in text
noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>
"==================================================

"==================================================
" No backup and swap files
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


"==================================================
set encoding=utf-8
set nocompatible
syntax on
filetype on
filetype plugin on
set autoindent
filetype indent on
set showmatch
set t_Co=256
set background=dark
let mapleader=" "
"==================================================
	
"==================================================
"Set incremental searching	
set incsearch

"Highlight searching
set hlsearch

" A tab is 4 spaces
set tabstop=4

" Width of indent with shift
set shiftwidth=4

" Insert spaces instead of tabs
set expandtab

" See multiple space characters as tabstops
set softtabstop=4

" Ignore case when searching
set ignorecase

" Remember more commands
set history=1000

" save undo's after file closes 
set undofile
" where to save undo history
set undodir=~/.vim/undo
" how many undos
set undolevels=1000
" numbers of lines to save for undo
set undoreload=10000
"
" Don't beep
set visualbell
set noerrorbells
set visualbell t_vb=

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Highlight current line and column
" au WinLeave * set nocursorline nocursorcolumn
" au WinEnter * set cursorline cursorcolumn
set cursorline " cursorcolumn

" Cursor stays in the middle of the screen
set scrolloff=50

" show numbers of lines
set number
" set relativenumber

" Write the old file out when switching between files.
" set autowrite

" Display current cursor position in lower right corner.
set ruler

"Better line wrapping 
set wrap
set textwidth=79
set formatoptions=qrn1

"Enable code folding
set foldenable

" How to fold
set foldmethod=indent

"Hide mouse when typing
set mousehide

" More useful command-line completion
set wildmenu

"Auto-completion menu
set wildmode=list:longest

" Open splits below and on the right
set splitbelow
set splitright
"==================================================

"==================================================
" Look and themes
colorscheme 256_noir
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

" wincmd p puts the cursor in the main window
autocmd VimEnter * wincmd p
" =================================================

" =================================================
" Neosnippet
imap ,,   <Plug>(neosnippet_expand_or_jump)

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
" =================================================

" =================================================
" Taglist
 " autocmd FileType c,h,cpp,java,sh,py nested :TlistOpen
" let Tlist_Use_Right_Window = 1
" let Tlist_Auto_Open = 1
" let TlistHighlightTag = 1
" map <F4> :TlistToggle<CR>
map <Leader>2 :TlistToggle<CR>
" =================================================

" =================================================
" Tagbar
" Open Tagbar only with specific files
autocmd FileType c,h,cpp,java,sh nested :TagbarOpen
map <Leader>2 :TagbarToggle<CR>
let g:tagbar_left = 0
let g:tagbar_width = 25
let g:tagbar_sort = 1
let g:tagbar_indent = 1
let g:tagbar_show_visibility = 1
let g:tagbar_show_linenumbers = 0
let g:tagbar_singleclick = 1
let g:tagbar_foldlevel = 2
let g:tagbar_iconchars = ['+', '-']
let g:tagbar_autoshowtag = 1
let g:tagbar_autopreview = 0
highlight TagbarKind ctermfg=196
highlight TagbarNestedKind ctermfg=196
highlight TagbarScope ctermfg=196
highlight TagbarType ctermfg=196
highlight TagbarSignature ctermfg=196
highlight TagbarFoldIcon ctermfg=196
highlight TagbarHighlight ctermfg=46
highlight TagbarVisibilityPublic ctermfg=49
highlight TagbarVisibilityProtected ctermfg=208
highlight TagbarVisibilityPrivate ctermfg=196
" =================================================

" =================================================
" NERDTree
" autocmd FileType c,h,cpp,java,sh,py nested :NERDTree
autocmd VimEnter * NERDTree | wincmd p
let g:NERDTreeWinSize = 20
map <Leader>1 :NERDTreeToggle<CR>
let NERDTreeShowHidden=0
let g:NERDTreeDirArrows=0
let NERDTreeAutoDeleteBuffer=1
let NERDTreeCascadeOpenSingleChildDir=1
let NERDTreeMinimalUI=0
let NERDTreeShowLineNumbers=0
let NERDTreeShowBookmarks=1
let NERDTreeBookmarksFile="/home/michal/.NERDTreeBookmarks"
let NERDTreeIgnore=['\.vim$', '\.o$', '\.pdf$', '\.png$', '\.jpg$', '\.doc$', '\.mp4$', '\.mp3$', '\.rar$', '\.zip$', '\~$']
let NERDTreeHijackNetrw=0
" =================================================

" =================================================
" neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 5
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" =================================================

" =================================================
" YouCompleteMe
" let g:ycm_complete_in_strings = 0
" let g:ycm_complete_in_comments = 1
" let g:ycm_add_preview_to_completeopt = 0
" let g:ycm_min_num_of_chars_for_completion = 2
" let g:ycm_min_num_identifier_candidate_chars = 0
" let g:ycm_disable_for_files_larger_than_kb = 2048
" let g:ycm_autoclose_preview_window_after_insertion = 0
" let g:ycm_autoclose_preview_window_after_completion = 0
" let g:ycm_collect_identifiers_from_comments_and_strings = 0
" let g:ycm_key_list_select_completion=[]
" let g:ycm_key_list_previous_completion=[]
" let g:ycm_key_list_select_completion = ['<Tab>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<S-Tab>', '<Up>']
" =================================================

" =================================================
" Kill the capslock when leaving insert mode.
autocmd InsertLeave * set iminsert=0

" IndentLine
let g:indentLine_enabled = 1
let g:indentLine_char = '|'
" let g:indentLine_char = '¦'
let g:indentLine_color_term = 239
"==================================================

"==================================================
" Better copy/paste (go to insert, press F2 and paste text)
set pastetoggle=<F2>
set clipboard=unnamed
"==================================================

"==================================================
" run compiled file
map <Leader>0 :!./bin<CR>

" jk instead od ESC
inoremap jk <ESC> 

" search with space
" noremap <space> /

" 
nnoremap Y y$

" Easier split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Faster commands 
noremap ; :

" Move to the first non-blank character of the line
nnoremap m ^

" Disable the arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" ctrl+n to off backlight during search in text
noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>

" jump to the end of pasted text
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" vp doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()
"==================================================

"==================================================
" leader-key maps
" saving
nnoremap <Leader>w :w<CR>
" closing
nnoremap <Leader>c :q<CR>
" search and replace (cs - replace first match, n - next)
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>
" splitting
nnoremap <Leader>a :sp<CR>
nnoremap <Leader>s :vsp<CR>
nnoremap <Leader>k :resize +5<CR>
nnoremap <Leader>j :resize -5<CR>
"==================================================
"
"==================================================
" No backup and swap files
set nobackup
set nowritebackup
set noswapfile
"==================================================

"==================================================
" Compiling directly in vim
nmap <Leader>9 :SCCompile<cr>
nmap <F1> :SCCompileRun<cr>
"==================================================

"==================================================
" Keyboard commands

" NerdTree 
" i - open the selected file in a horizontal split window
" s - open the selected file in a vertical split window
" I - toggle hidden files
" R - refresh the tree
" m, a to create file
" m, d to delete file

" Vim-commentary
" gc - comment/comment out selected text
" gcc - comment/comment out a line

" Taglist
" press Space on function to show the prototype

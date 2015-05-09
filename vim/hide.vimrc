syntax on 	"podswietlana skladnia
filetype on
set number	"wyswietla numery linii
set incsearch
set autoindent	"automatyczne wciecia
set hlsearch
set showmatch
colorscheme gruvbox
set background=dark
set t_Co=256
set tabstop=4
execute pathogen#infect()
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
autocmd VimEnter * nested :TagbarOpen

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p

set pastetoggle=<F2>
set clipboard=unnamed
" Lepsze kopiowanie/wklejanie, jeżeli masz do wklejenia jakiś duży blok tekstu. Przechodzisz do trybu insert, wciskasz <F2> i wklejasz tekst.

noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>
" Jeżeli wyszukałeś jakąś frazę, to vim ją podkreślił, jeśli chcesz pozbyć się podświetlenia wciśnij CTRL+n.

set nobackup
set nowritebackup
set noswapfile
" Wyłącza pliki backup oraz swap. Nie są Ci do niczego potrzebne, a jak pracujesz z gitem czy mercurialem to tym bardziej.
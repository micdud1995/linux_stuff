# run as a user!

#==============================================================
# Plugin list:
#	Pathogen
#	Nerdtree
#	Syntastic
#	Tagbar / Taglist
#	GitGutter
#	Nerdcommenter
# 	Vim-airline
#	Auto-pairs
# 	Supertab
#	SnipMate
#   indentLine
#	Gruvbox theme
#==============================================================

clear

#=================================================================
# Creating repo dir and cloning repository
if [ ! -d ~/repo ] && [ ! -d ~/repo/linux_stuff ]; then
	echo
	echo Creating ~/repo/linux_stuff directory...
	echo Cloning repository...
	mkdir -p ~/repo
	mkdir ~/repo/linux_stuff
	cd ~/repo/linux_stuff
	git clone https://github.com/micdud1995/linux_stuff.git
else
	echo
	echo OK, ~/repo/linux_stuff already exists...
fi
#=================================================================

#=================================================================
echo
echo Configuration of vim...
echo
#=================================================================

sudo pacman -S vim curl ctags ttf-inconsolata

#==============================================================
# Making dirs
mkdir -p ~/tmp ~/.vim/autoload ~/.vim/bundle ~/.vim/colors ~/tmp/tagbar
#==============================================================

#==============================================================
# Pathogen
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
#==============================================================

#==============================================================
# Nerdtree
cd ~/.vim/bundle && \
git clone https://github.com/scrooloose/nerdtree.git
#==============================================================

#==============================================================
# Syntastic
cd ~/.vim/bundle && \
git clone https://github.com/scrooloose/syntastic.git
#==============================================================

#==============================================================
# Tagbar / Taglist
cd ~/.vim/bundle && \
git clone git://github.com/vim-scripts/taglist.vim.git
#git clone https://github.com/vim-scripts/Tagbar.git
#==============================================================

#==============================================================
# GitGutter
cd ~/.vim/bundle && \
git clone git://github.com/airblade/vim-gitgutter.git
#==============================================================

#==============================================================
# Nerdcommenter
cd ~/.vim/bundle && \
git clone https://github.com/scrooloose/nerdcommenter.git
#==============================================================

#==============================================================
# Vim-airline
git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline
#==============================================================

#==============================================================
# Auto-pairs 
cd ~/.vim/bundle && \
git clone git://github.com/jiangmiao/auto-pairs.git
#==============================================================

#==============================================================
# Supertab
git clone git://github.com/ervandew/supertab.git
#==============================================================

#==============================================================
# SnipMate
cd ~/.vim/bundle
git clone https://github.com/tomtom/tlib_vim.git
git clone https://github.com/MarcWeber/vim-addon-mw-utils.git
git clone https://github.com/garbas/vim-snipmate.git
git clone https://github.com/honza/vim-snippets.git
#==============================================================

#==============================================================
cd ~/.vim/bundle
git clonehttps://github.com/Yggdroot/indentLine.git
#==============================================================

#==============================================================
# Gruvbox theme
#mkdir -p ~/tmp
#cd ~/tmp && \
#git clone https://github.com/morhetz/gruvbox.git
#mv ~/tmp/gruvbox/autoload/gruvbox.vim ~/.vim/autoload/gruvbox.vim
#mv ~/tmp/gruvbox/colors/gruvbox.vim ~/.vim/colors/gruvbox.vim
#rm -rf ~/tmp/gruvbox

# Sorcerer theme
#cd ~/tmp && \
#git clone https://github.com/adlawson/vim-sorcerer.git
#mv ~/tmp/vim-sorcerer/colors/sorcerer.vim ~/.vim/colors
#rm -rf ~/tmp/vim-sorcerer

# Jellybeans theme
cd ~/tmp && \
git clone https://github.com/nanotech/jellybeans.vim.git
mv ~/tmp/jellybeans.vim/colors/jellybeans.vim ~/.vim/colors/jellybeans.vim
rm -rf ~/tmp/jellybeans.vim
#==============================================================

#==============================================================
# Copying .vimrc
cp ~/repo/linux_stuff/vim/hide.vimrc ~/.vimrc
#==============================================================

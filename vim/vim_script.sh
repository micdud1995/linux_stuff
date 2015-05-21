# run as a user!

#==============================================================
# Plugin list:
#	Pathogen
#	Nerdtree
#	Syntastic
#	Taglist
#	GitGutter
#	Nerdcommenter
# 	Vim-airline
#	Auto-pairs
#	Gruvbox theme
#==============================================================

clear

#=================================================================
# Creating repo dir and cloning repository
if [ ! -d ~/repo ] && [ ! -d ~/repo/linux_stuff ]; then
	echo
	echo =================================================================
	echo Creating ~/repo/linux_stuff directory...
	echo Cloning repository...
	echo =================================================================
	mkdir -p ~/repo
	mkdir ~/repo/linux_stuff
	cd ~/repo/linux_stuff
	git clone https://github.com/micdud1995/linux_stuff.git
else
	echo
	echo =================================================================
	echo OK, ~/repo/linux_stuff already exists...
	echo =================================================================
fi
#=================================================================

#=================================================================
echo
echo =================================================================
echo Configuration of vim...
echo =================================================================
echo
#=================================================================

sudo aptitude install vim curl exuberant-ctags

#==============================================================
# Making dirs
mkdir -p ~/.vim/autoload ~/.vim/bundle ~/.vim/colors ~/tmp/tagbar
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
# Taglist
cd ~/.vim/bundle && \
git clone git://github.com/vim-scripts/taglist.vim.git
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
git clone git://github.com/jiangmiao/auto-pairs.git ~/.vim/bundle/auto-pairs
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
mkdir -p ~/tmp
cd ~/tmp && \
git clone https://github.com/vim-scripts/Sorcerer.git
mv ~/tmp/Sorcerer/colors/sorcerer.vim ~/.vim/colors
rm -rf ~/tmp/Sorcerer
#==============================================================

#==============================================================
# Copying .vimrc
cp ~/repo/linux_stuff/vim/hide.vimrc ~/.vimrc
#==============================================================

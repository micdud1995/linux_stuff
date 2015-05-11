# run this with sudo, not su!
# at first type: cd ~/repo && git clone https://github.com/micdud1995/linux_stuff.git
 
echo
echo Configuration of vim...
echo

aptitude install vim curl exuberant-ctags

#==============================================================
# Making dirs
mkdir -p ~/.vim/autoload ~/.vim/bundle ~/.vim/colors
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
# Tagbar
cd ~/.vim/bundle && \
git clone git://github.com/majutsushi/tagbar
#==============================================================

#==============================================================
# GitGutter
cd ~/.vim/bundle && \
git clone git://github.com/airblade/vim-gitgutter.git
#==============================================================

#==============================================================
# Gruvbox theme
cd ~/tmp && \
git clone https://github.com/morhetz/gruvbox.git
mv ~/tmp/gruvbox/autoload/gruvbox.vim ~/.vim/autoload/gruvbox.vim
mv ~/tmp/gruvbox/colors/gruvbox.vim ~/.vim/colors/gruvbox.vim
rm -rf ~/tmp/gruvbox
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
# Copying .vimrc
cp ~/repo/linux_stuff/vim/hide.vimrc ~/.vimrc
#==============================================================

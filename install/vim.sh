#!/bin/bash

## @author Iason Sarantopoulos

MESSAGE="Configuring ViM..."; blue_echo

sudo apt-get install -y vim vim-gtk git

###############################################################################
###                  Set up .vim directory and .vimrc                       ###
###############################################################################

MESSAGE="Setting up .vim directory and .vimrc..."; blue_echo

# Check if a directory .vim exists, if yes move it to backup directory.
if [ -d ~/.vim ]; then
  mv ~/.vim $BACKUP_NAME/vim
fi

# Create a new .vim directory
mkdir ~/.vim

# Create a link to colors
ln -s "$DOTFILES_DIR/vim/colors" ~/.vim/colors

if [ -f ~/.vimrc ]; then
  mv ~/.vimrc "$DOTFILES_DIR/backups/$BACKUP_NAME/vimrc"
fi
ln -s "$DOTFILES_DIR/vim/vimrc" ~/.vimrc

###############################################################################
###                          Install ViM plugins                            ###
###############################################################################

MESSAGE="Installing ViM's plugins..."; blue_echo

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

git config --global core.editor "vim"
git config --global diff.tool vimdiff
git config --global merge.tool vimdiff
git config --global merge.conflictstyle diff3

###############################################################################
###                          Install ViM plugins                            ###
###############################################################################

MESSAGE="Installing Powerline fonts..."; blue_echo

cd $DOTFILES_DIR

if [ -d fonts ]; then
  cd fonts
  git pull origin master
  cd ..
else
  git clone https://github.com/powerline/fonts.git
fi

cd fonts
./install.sh

MESSAGE="ViM configured successfully. Choose one powerline font for your terminal."; blue_echo

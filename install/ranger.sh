#!/bin/bash

## @author Iason Sarantopoulos

MESSAGE="Downloading and Installing ranger v$RANGER_VERSION"; blue_echo

###############################################################################
###                       Download and install Ranger                       ###
###############################################################################

if [ -z "$(find /var/cache/apt/pkgcache.bin -mmin -60)" ]; then
  sudo apt-get update > /dev/null
fi
sudo apt-get install -y wget > /dev/null

# Before download ranger check if the directory of this version exist. If it
# exist remove it to avoid conflicts.
cd $DOTFILES_DIR/ranger
if [ -d ranger-$RANGER_VERSION ]; then
  rm -rf ranger-$RANGER_VERSION
fi

if [ -f v$RANGER_VERSION.tar.gz ]; then
  rm -rf v$RANGER_VERSION.tar.gz
fi

# Download and unpack the desired version of ranger
wget https://github.com/ranger/ranger/archive/v$RANGER_VERSION.tar.gz
tar xvf v$RANGER_VERSION.tar.gz > /dev/null

# Build and install the app
cd ranger-$RANGER_VERSION
sudo make install > /dev/null

# Clean up any temporary files
cd $DOTFILES_DIR/ranger
sudo rm -rf ranger-$RANGER_VERSION
sudo rm -rf v$RANGER_VERSION.tar.gz


###############################################################################
###                     Install my ranger configuration                     ###
###############################################################################

mkdir -p ~/.config/ranger
mkdir -p $BACKUP_DIR/ranger

declare -a arr=("rc.conf" "rifle.conf")

## now loop through the above array
for i in "${arr[@]}"
do
  # Move the existing configuration of ranger to the backup directory
  if [ -f ~/.config/ranger/$i ]; then
    mv ~/.config/ranger/$i $BACKUP_DIR/ranger/$i
  fi

  # Create a symbolic link for the ranger configuration
  ln -s $DOTFILES_DIR/ranger/$i ~/.config/ranger/$i
done

MESSAGE="Ranger v$RANGER_VERSION successfully installed."; green_echo

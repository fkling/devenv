#!/usr/bin/env bash

DIR=`dirname $0`
GIT=`which git`

# link home files
echo "Linking files"
for f in $(ls -A "$DIR/home")
do
  ln -fs "$DIR/home/$f" ~/
done
echo "Don't forget to run BundleInstall!"

# install vundle
VUNDLE=~/.vim/bundle/vundle
mkdir -p "$VUNDLE"
if [ ! -d "$VUNDLE" ]; then
  $GIT clone https://github.com/gmarik/vundle.git "$VUNDLE"
fi

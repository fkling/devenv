#!/bin/bash

# copy configuration files
su vagrant -c /vagrant/dotfiles/setup.sh


# install nodejs
NODE=`which node`
if [ ! -x "$NODE" ]; then
  if [ -d ~/src ]; then
    rm -rf ~/src;
  fi
  mkdir -p ~/src && cd $_
  wget -N http://nodejs.org/dist/node-latest.tar.gz
  tar xzf node-latest.tar.gz && cd node-v*
  ./configure
  # Replace with current version number.
  checkinstall -y --install=no --pkgversion 0.10.24
  sudo dpkg -i node_*
fi

#setup server root
rm -rf /var/www
ln -fs /vagrant /var/www

# tools
npm install -g jshint

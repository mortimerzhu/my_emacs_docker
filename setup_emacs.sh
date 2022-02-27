#!/bin/bash

cd /opt/
git clone https://github.com/universal-ctags/ctags.git
cd ctag
./autogen.sh
./configure --prefix=/usr
make
make install
cd ~
git clone -b feature_mortimer http://github.com/mortimerzhu/emacs.d.git .emacs.d
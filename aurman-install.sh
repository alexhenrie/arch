#!/bin/bash -e

gpg --recv-keys 465022E743D71E39

sudo pacman -Syu --needed --noconfirm pyalpm python-dateutil python-feedparser python-regex

install_package_file () {
    tar -xf $1.tar.gz
    cd $1
    makepkg
    sudo pacman -U --noconfirm *.pkg.tar*
    cd ..
}

AURTEMP=`mktemp -d`
pushd $AURTEMP > /dev/null
wget https://aur.archlinux.org/cgit/aur.git/snapshot/aurman.tar.gz
install_package_file aurman
popd > /dev/null
rm -rf $AURTEMP

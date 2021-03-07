#!/bin/bash -e

gpg --recv-keys 3FFA6AB7B69AAE6CCA263DDE019A7474297D8577

sudo pacman -Syu --needed --noconfirm pyalpm python-dateutil python-feedparser python-regex

add_config_line () {
    if [ ! -f $2 ]; then
        echo "$2 does not exist!"
    elif [ -z "`grep "$1" $2`" ]; then
        echo "$1" >> $2
    fi
}

aurman -Syu --needed --noconfirm --noedit --solution_way \
bcwc-pcie-git \
beignet \
flpsed \
gst-plugins-ugly \
hunspell-ca \
opencl-amd \
pithos \
pkgcacheclean \
qdirstat \
system76-driver \
ttf-ms-fonts \
virtualbox-ext-oracle \
ycm-generator-git \

sudo sh -c 'echo "#!/bin/sh
pkgcacheclean" > /etc/cron.daily/pkgcacheclean.sh'
chmod +x /etc/cron.daily/pkgcacheclean.sh

touch ~/.nanorc
while read line; do
    add_config_line "$line" ~/.nanorc
done < /usr/share/nano-syntax-highlighting/nanorc.sample

#if [ ! -d ~/.config/btsync ]; then
#    sudo sed -i 's/0.0.0.0:8888/127.0.0.1:8888/' /etc/btsync.conf || {
#        echo 'Failed to lock down BitTorrent Sync'
#        exit 1
#    }
#    mkdir -p ~/.config/btsync
#    sudo cp ~/etc/btsync.conf ~/.config/btsync/btsync.conf
#    sudo chown $USER:$USER ~/.config/btsync/btsync.conf
#    mkdir -p ~/.btsync
#    sed -i "s/My Sync Device/`hostname`/" ~/.config/btsync/btsync.conf
#    sed -i "s/\\\/var\\\/lib\\\/btsync/\\\/home\\\/$USER\\\/.btsync/" ~/.config/btsync/btsync.conf
#    sed -i "s/\\\/var\\\/run\\\/btsync\\\/btsync.pid/\\\/home\\\/$USER\\\/.btsync\\\/btsync.pid/" ~/.config/btsync/btsync.conf
#fi

#systemctl --user enable btsync
#systemctl --user start btsync

sudo systemctl enable --now system76

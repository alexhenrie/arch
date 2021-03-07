#!/bin/bash

if [ "`id -u`" != "0" ]; then
    echo "This script must be run as root."
    exit 1
fi

pacman -Sy --needed --noconfirm \
apache \
iodine \
sudo \
wget \

echo "biodine" > /etc/hostname

init_service () {
    systemctl start $1
    systemctl enable $1
}

init_service httpd
init_service iodined
init_service sshd

groupadd sudo
useradd -m -G sudo -s /bin/bash alex
useradd -m -G sudo -s /bin/bash dougvj

add_config_line () {
    if [ ! -f $2 ]; then
        echo "$1" > "$2"
    elif [ -z "`grep "$1" $2`" ]; then
        echo "$1" >> $2
    fi
}

sed -i "s/# %sudo/%sudo/" /etc/sudoers
add_config_line 'Defaults passwd_timeout=0' /etc/sudoers

add_config_line "set nowrap" /home/alex/.nanorc

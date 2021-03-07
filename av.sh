#!/bin/bash

if [ "`id -u`" != "0" ]; then
    echo "This script must be run as root."
    exit 1
fi

init_service () {
    systemctl start $1
    systemctl enable $1
}

pacman -Syu --needed --noconfirm clamav

freshclam

init_service clamd

#!/bin/bash

cp 31_hold_shift /etc/grub.d/
if [ -z "`grep 'GRUB_FORCE_HIDDEN_MENU="true"' /etc/default/grub`" ]; then
    echo GRUB_FORCE_HIDDEN_MENU=\"true\" >> /etc/default/grub
fi
grub-mkconfig -o /boot/grub/grub.cfg

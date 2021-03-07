#!/bin/sh
make -j`nproc` | tee make.log && \
sudo rm -f /boot/vmlinuz && \
sudo rm -f /boot/System.map && \
sudo make -j8 install | tee make.install.log && \
sudo make -j8 modules_install | tee make.modules_install.log && \
sudo mkinitcpio -k `grep DEPMOD make.modules_install.log | cut -d$' ' -f 5` -g /boot/initramfs.img

#!/bin/bash

if [ "`id -u`" != "0" ]; then
    echo "This script must be run as root."
    exit 1
fi

while getopts 'u:d:' opt; do
    if [ "$opt" == "u" ]; then
        NEWUSER="$OPTARG"
    elif [ "$opt" == "d" ]; then
        DPI="$OPTARG"
    fi
done

add_config_line () {
    if [ ! -f $2 ]; then
        echo "$2 does not exist!"
    elif [ -z "`grep "$1" $2`" ]; then
        echo "$1" >> $2
    fi
}

#Package Installation

perl -0777 -i -pe "s/^#\[multilib\]\n#Include = \/etc\/pacman.d\/mirrorlist$/[multilib]\nInclude = \/etc\/pacman.d\/mirrorlist/m" /etc/pacman.conf

yes | pacman -Syu --needed gcc-libs-multilib

#optional dependencies are listed under the package that they support
pacman -Syu --needed --noconfirm \
`pacman -Ssq ^ttf- | grep -v ttf-nerd-fonts-symbols-mono` \
alsa-utils \
amd-ucode \
amdvlk \
android-tools \
android-udev \
apache \
arandr \
arch-install-scripts \
aspell-ca \
aspell-es \
audacity \
autoconf \
bash-completion \
bison \
blueman \
bluez \
bluez-utils \
boinc \
breeze-gtk \
cheese \
clang \
clang-analyzer \
cronie \
cups \
    gtk3-print-backends \
dkms \
discord \
dnsmasq \
dnsutils \
dosfstools \
doxygen \
dwdiff \
efibootmgr \
element-desktop \
evince \
expac \
f2fs-tools \
feh \
file-roller \
    unrar \
firefox \
flex \
galculator \
gdb \
gedit \
ghex \
gimp \
git \
    perl-authen-sasl \
    perl-mime-tools \
    perl-net-smtp-ssl \
    tk \
gnome-disk-utility \
gnome-screenshot \
gparted \
grub \
gsmartcontrol \
gst-plugins-good \
gst-plugins-ugly \
gstreamer-vaapi \
gutenprint \
guvcview \
gvim \
    cmake \
    go \
    rust \
hdparm \
hplip \
htop \
hunspell-en_US \
hunspell-es_es \
ibus \
inkscape \
intel-media-driver \
intel-ucode \
iodine \
iperf \
iperf3 \
iw \
jdk-openjdk \
leafpad \
lib32-alsa-plugins \
lib32-amdvlk \
lib32-flex \
lib32-gst-plugins-base \
lib32-gst-plugins-good \
lib32-libpulse \
lib32-vulkan-intel \
lib32-vulkan-radeon \
libdvdcss \
libdvdnav \
libdvdread \
libreoffice-fresh \
    libreoffice-fresh-ca \
    libreoffice-fresh-es \
libva-intel-driver \
libva-mesa-driver \
libva-utils \
libva-vdpau-driver \
libvdpau-va-gl \
lightdm \
    lightdm-gtk-greeter \
links \
linux-headers \
lshw \
lsscsi \
lxc \
lxqt \
    gvfs-nfs \
    gvfs-smb \
    oxygen-icons \
    qt5-imageformats \
mate-screensaver \
    mate-notification-daemon \
mercurial \
mesa-vdpau \
minicom \
mlocate \
multilib-devel \
mupdf \
nano \
nano-syntax-highlighting \
netctl \
    dialog \
networkmanager \
networkmanager-openconnect \
network-manager-applet \
    gnome-keyring \
nfs-utils \
nmap \
nodejs \
npm \
ntfs-3g \
ntp \
obconf \
opencl-mesa \
openconnect \
openssh \
os-prober \
parallel \
p7zip \
pasystray \
pavucontrol \
pkg-config \
pkgfile \
php \
php-apache \
pidgin \
pidgin-otr \
poedit \
postfix \
pulseaudio \
pulseaudio-alsa \
pulseaudio-bluetooth \
python-pip \
python-selenium \
qalculate-gtk \
    gnuplot \
qt5-doc \
qtcreator \
r \
rfkill \
rsync \
scrot \
seahorse \
socat \
sshfs \
sshpass \
sudo \
system-config-printer \
systemd-swap \
usbutils \
testdisk \
texlive-core \
time \
traceroute \
transmission-gtk \
valgrind-multilib \
vdpauinfo \
virtualbox \
virtualbox-host-dkms \
vlc \
vulkan-intel \
vulkan-radeon \
wavemon \
wget \
wine \
    lib32-gnutls \
    lib32-libldap \
    lib32-openal \
    lib32-vkd3d \
    libgphoto2 \
    samba \
    sane \
    vkd3d \
winetricks \
wine_gecko \
wine-mono \
wireshark-qt \
xorg \
xorg-server-xvfb \
yajl \

#System Configuration

sed -i 's/#swapfc_enabled=0/swapfc_enabled=1/' /etc/systemd/swap.conf

echo 'blacklist pcspkr' > /etc/modprobe.d/nobeep.conf
echo 'vboxdrv' > /etc/modules-load.d/vboxdrv.conf

echo 'SUBSYSTEM=="hidraw", MODE="0666"' > /etc/udev/rules.d/45-hidraw.rules

add_config_line 'server=208.67.222.222' /etc/dnsmasq.conf
add_config_line 'server=208.67.220.220' /etc/dnsmasq.conf
add_config_line 'server=8.8.8.8' /etc/dnsmasq.conf
add_config_line 'server=8.8.4.4' /etc/dnsmasq.conf

sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

cp alias /root/.alias
touch /root/.bashrc
add_config_line 'source /root/.alias' /root/.bashrc

ln -sf /etc/dnsmasq.conf /etc/NetworkManager/dnsmasq.d/

cp 51-blueman.rules /etc/polkit-1/rules.d/

echo '#!/bin/sh
pacman -Syuw' > /etc/cron.daily/pacman.sh
chmod +x /etc/cron.daily/pacman.sh

mkdir -p /usr/local/bin
echo '#!/bin/sh
mate-screensaver-command --lock' > /usr/local/bin/lxlock
chmod +x /usr/local/bin/lxlock

sed -i 's/Listen 80/Listen 127.0.0.1:80/' /etc/httpd/conf/httpd.conf

sed -i 's/;extension=iconv.so/extension=iconv.so/' /etc/php/php.ini
#sed -i 's/;extension=mysqli.so/extension=mysqli.so/' /etc/php/php.ini
#sed -i 's/;extension=pdo_mysql.so/extension=pdo_mysql.so/' /etc/php/php.ini

add_config_line 'inet_interfaces = localhost' /etc/postfix/main.cf

groupadd sudo

sed -i 's/# %sudo/%sudo/' /etc/sudoers
add_config_line 'Defaults passwd_timeout=0' /etc/sudoers

echo '[main]
dns=dnsmasq' > /etc/NetworkManager/conf.d/10-dnsmasq.conf

add_config_line 'send host-name = pick-first-value(gethostname(), "ISC-dhclient");' /etc/dhclient.conf

ln -sf /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d

ln -sf /usr/lib/vdpau/libvdpau_va_gl.so.1 /usr/lib/vdpau/libvdpau_i965.so.1

wget http://registry.gimp.org/files/rule-of-thirds.scm -O /usr/share/gimp/2.0/scripts/rule-of-thirds.scm

#Root User Configuration

cp alias /root/.alias
touch /root/.bashrc
#add_config_line 'stty -ixon -ixoff' /root/.bashrc
add_config_line 'shopt -s checkwinsize' /root/.bashrc
add_config_line "source /root/.alias" /root/.bashrc

#Other User Configuration

if [ -z "$NEWUSER" ]; then
    echo 'Skipping user setup'
else
    echo "Setting up user $NEWUSER"

    useradd -m -G adbusers,boinc,lp,sudo,sys,uucp,vboxusers,wireshark -s /bin/bash $NEWUSER
    chown $NEWUSER:$NEWUSER /home/$NEWUSER

    chown -R $NEWUSER /srv/http

    cp alias /home/$NEWUSER/.alias
    chown $NEWUSER:$NEWUSER /home/$NEWUSER/.alias
    touch /home/$NEWUSER/.bashrc
    add_config_line 'stty -ixon -ixoff' /home/$NEWUSER/.bashrc
    add_config_line 'shopt -s checkwinsize' /home/$NEWUSER/.bashrc
    add_config_line "source /home/$NEWUSER/.alias" /home/$NEWUSER/.bashrc
    chown $NEWUSER:$NEWUSER /home/$NEWUSER/.bashrc

    touch /home/$NEWUSER/.xprofile
    add_config_line 'ibus-daemon -drx' /home/$NEWUSER/.xprofile
    add_config_line 'export GTK_IM_MODULE=ibus' /home/$NEWUSER/.xprofile
    add_config_line 'export XMODIFIERS=@im=ibus' /home/$NEWUSER/.xprofile
    add_config_line 'export QT_IM_MODULE=ibus' /home/$NEWUSER/.xprofile
    if [ -d /sys/module/hid_apple ]; then
        add_config_line 'xrandr --output eDP1 --mode 1280x800 --dpi 96' /home/$NEWUSER/.xprofile
    fi
    chown $NEWUSER:$NEWUSER /home/$NEWUSER/.xprofile

    sudo -u $NEWUSER ./git-setup.sh

    touch /home/$NEWUSER/.nanorc
    while read line; do
        add_config_line "$line" /home/$NEWUSER/.nanorc
    done < nanorc
    chown $NEWUSER:$NEWUSER /home/$NEWUSER/.nanorc

    mkdir -p /home/$NEWUSER/.config/autostart
    ln -sf /usr/share/applications/pidgin.desktop /home/$NEWUSER/.config/autostart/
    #ln -sf /usr/share/applications/geary-autostart.desktop /home/$NEWUSER/.config/autostart/
    ln -sf /usr/share/applications/riot.desktop /home/$NEWUSER/.config/autostart/
    echo "[Desktop Entry]
    Exec=ibus-daemon -drx" > /home/$NEWUSER/.config/autostart/ibus-daemon.desktop
    echo "[Desktop Entry]
    Exec=mate-screensaver" > /home/$NEWUSER/.config/autostart/mate-screensaver.desktop
    echo "[Desktop Entry]
    Exec=setxkbmap -option numpad:microsoft" > /home/$NEWUSER/.config/autostart/numpad-shift.desktop
    echo "[Desktop Entry]
    Exec=/home/$NEWUSER/.screenlayout/default.sh" > /home/$NEWUSER/.config/autostart/screenlayout.desktop
    echo "[Desktop Entry]
    Exec=xset s off" > /home/$NEWUSER/.config/autostart/xset-s-off.desktop
    chown -R $NEWUSER:$NEWUSER /home/$NEWUSER/.config
fi

if [ -z "$DPI" ]; then
    echo 'Skipping DPI setup'
else
    echo "Setting DPI to $DPI"
    sed -i "s/#xserver-command=X/xserver-command=X -dpi $DPI/" /etc/lightdm/lightdm.conf
    sed -i "s/#xft-dpi=/xft-dpi=$DPI/" /etc/lightdm/lightdm-gtk-greeter.conf
    touch /etc/X11/Xresources
    add_config_line "Xft.dpi: $DPI" /etc/X11/Xresources
fi

#Service Start

systemctl enable lightdm
systemctl enable NetworkManager
systemctl enable --now bluetooth
systemctl enable --now boinc-client
systemctl enable --now cronie
systemctl enable --now cups
systemctl enable --now httpd
#systemctl enable --now mysqld
systemctl enable --now ntpd
systemctl enable --now postfix
systemctl enable --now sshd
systemctl enable --now systemd-swap

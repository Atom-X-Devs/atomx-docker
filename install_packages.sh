#!/bin/bash

# Uncomment community [multilib] repository
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

# Update
pacman -Syyu --noconfirm

# Install Basic Packages
pacman -S --needed --noconfirm \
	sudo nano git curl wget rsync aria2 rclone \
	python2 python3 python-pip zip unzip cmake \
	make neofetch speedtest-cli inetutils cpio \
	jdk8-openjdk lzip dpkg openssl ccache libelf \
	base-devel repo openssh lz4 jq

# More Packages
pacman -S --noconfirm \
	tmate tmux screen mlocate unace unrar p7zip \
	sharutils uudeview arj cabextract file-roller \
	dtc brotli axel gawk detox 

# pip version
pip --version

# Install Some pip packages
pip install \
	twrpdtgen telegram-send backports.lzma docopt \
	extract-dtb protobuf pycrypto docopt zstandard

# Create a non-root user for AUR
useradd -m -G wheel -s /bin/bash testuser
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install yay
git clone https://aur.archlinux.org/yay.git /tmp/yaygit
cd /tmp/yaygit
sudo chmod -R a+rwx .
sudo -u testuser makepkg -si --needed --noconfirm
cd /root
rm -rf /tmp/yaygit

# Setup the Android Build Environment
cd /tmp/scripts
sudo chmod -R a+rwx .
sudo -u testuser bash ./aosp-build-env.sh
cd -

# Use python2 by default
ln -sf /usr/bin/python2 /usr/bin/python

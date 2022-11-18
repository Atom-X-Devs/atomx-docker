#!/bin/bash

# Uncomment community [multilib] repository
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

# Update
pacman -Syyu --needed --noconfirm 2>&1 | grep -v "warning: could not get file information"

# Install Basic Packages
pacman -Sy --needed --noconfirm \
	sudo nano git curl wget rsync aria2 rclone \
	python3 python-pip zip unzip cmake make \
	neofetch speedtest-cli inetutils cpio repo \
	jdk8-openjdk lzip dpkg openssl ccache dbus \
	libelf base-devel openssh lz4 jq go ncurses \
	bison flex ninja uboot-tools z3 glibc dpkg \
	multilib-devel bc htop python-setuptools   \
	util-linux man-pages zsh systemd dbus

# More Packages
pacman -Sy --needed --noconfirm \
	tmate tmux screen mlocate unace unrar p7zip \
	sharutils uudeview arj cabextract file-roller \
	dtc brotli axel gawk detox clang gcc gcc-libs \
	flatpak libxcrypt-compat

# python and pip version
python --version; pip --version

# Install Some pip packages
pip install \
	twrpdtgen telegram-send backports.lzma docopt \
	extract-dtb protobuf pycrypto docopt zstandard \
	setuptools future requests humanize clint lz4 \
	pycryptodome

# pip git packages
pip install \
	git+https://github.com/samloader/samloader.git

# Create a non-root user for AUR
useradd -m -G wheel -s /bin/bash testuser
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# AUR Packages
sudo -u testuser yay -S --needed --noconfirm \
	rename python2

# zsh
chsh -s /bin/zsh root
sh -c "$(curl -sL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Setup systemd
find /etc/systemd/system /lib/systemd/system -path '*.wants/*' -not -name '*dbus*' -not -name '*journald*' -not -name '*systemd-tmpfiles*' -not -name '*systemd-user-sessions*' -exec rm -rf {} \;
systemctl set-default multi-user.target

# Setup the Android Build Environment
cd /tmp/scripts
sudo chmod -R a+rwx .
sudo -u testuser bash ./aosp-build-env.sh
cd -

# Python Symlinks
ln -sf /usr/bin/pip3.10 /usr/bin/pip3
ln -sf /usr/bin/pip3.10 /usr/bin/pip
ln -sf /usr/bin/python3.10 /usr/bin/python3

# Use python2 by default
ln -sf /usr/bin/python{2,}
#!/bin/bash

apt-get dist-upgrade -y -qq && apt-get upgrade -y -qq && apt-get update -y -qq
ln -snf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime && echo Asia/Kolkata > /etc/timezone
apt-get install --no-install-recommends -y -qq aria2 bc bison ca-certificates cpio curl file gcc git lib{c6,c,ssl,xml2}-dev make python3 python3-pip python2 unzip zip wget flex default-jre kmod
pip3 install telegram-send
apt-get autoremove -y && apt-get clean autoclean && rm -rf /var/lib/apt/lists/*
curl -L https://github.com/AkihiroSuda/clone3-workaround/releases/download/v1.0.0/clone3-workaround.x86_64 -o noclone3 && chmod +x noclone3

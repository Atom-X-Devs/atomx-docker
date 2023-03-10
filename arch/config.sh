#!/bin/bash

# Git Configuration
export GIT_USERNAME="Kunmun"
export GIT_EMAIL="kunmun@aospa.co"

git config --global user.name "${GIT_USERNAME}"
git config --global user.email "${GIT_EMAIL}"

# TimeZone Configuration
export TZ="Asia/Kolkata"
ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime

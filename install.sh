#!/bin/bash

sudo apt update
sudo apt upgrade

echo 'start install'

sudo apt install -y \
 rlwrap \
 pipx \
 netcat-traditional \
 ftp \
 2to3 \
 knockd \
 steghide \
 expect \
 eom eog \
 freerdp2-x11 \
 ghex \
 hashid \
 exploitdb \
 cewl \
 wig \
 dhclient \
 hashid \
 hash-identifier \

sudo apt remove samba-common samba-libs
sudo apt install -y smbclient

echo 'finish install'

sudo apt autoclean

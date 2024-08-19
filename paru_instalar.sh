#!/bin/bash

sudo pacman -S --needed pacman-contrib mlocate git fakeroot
sudo updatedb
cd ~/Downloads
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -Cris --needed --noconfirm


#!/bin/bash

sudo pacman -S --needed pacman-contrib mlocate git fakeroot
sudo updatedb
cd ~/Downloads
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -siL --needed --noconfirm


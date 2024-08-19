#!/bin/bash

# Desinstalação do pacote NVidia
sudo pacman -Rsun nvidia-470xx-utils lib32-nvidia-470xx-utils

# Configuração do Módulo para HOOK
sudo cp -a /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bkp_"$(date +%d%m%H%M)"
sudo sed -i 's/nvidia nvidia_modeset nvidia_uvm nvidia_drm//' /etc/mkinitcpio.conf

# Atualiza a imagem do initramfs com as configurações atuais
sudo /usr/bin/mkinitcpio -P

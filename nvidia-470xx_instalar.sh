#!/bin/bash

# Verifica se o yay está instalado
if command -v yay &>/dev/null; then
    echo "Usando yay para instalação..."
    yay -S --needed nvidia-470xx-dkms nvidia-470xx-utils lib32-nvidia-470xx-utils
else
    # Verifica se o paru está instalado
    if command -v paru &>/dev/null; then
        echo "Usando paru para instalação..."
        paru --needed -S --batchinstall --skipreview --removemake nvidia-470xx-dkms nvidia-470xx-utils lib32-nvidia-470xx-utils
    else
        echo "Nenhum dos AUR helpers (yay ou paru) está instalado."
    fi
fi

# Configuração do Módulo para HOOK
sudo cp -a /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bkp_"$(date +%d%m%H%M)"
if ! grep -q 'nvidia nvidia_modeset nvidia_uvm nvidia_drm' /etc/mkinitcpio.conf; then
    sudo sed -i '/MODULES=/s/(/(nvidia nvidia_modeset nvidia_uvm nvidia_drm/' /etc/mkinitcpio.conf
    echo "Módulos para NVidia Hook OK!"
fi

# Solução para Flickering
echo -e 'options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/tmp' | sudo tee /etc/modprobe.d/nvidia-power-management.conf
sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service

# Atualiza a imagem do initramfs com as configurações atuais
sudo /usr/bin/mkinitcpio -P

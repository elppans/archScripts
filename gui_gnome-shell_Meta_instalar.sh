#!/bin/bash
# Script para configurar o ambiente Gnome no Arch Linux


# Verificar se o comando paru existe
if command -v paru &>/dev/null; then
    # O comando 'paru' existe.
    :
else
    echo "O comando 'paru' não foi encontrado."
    exit 1
fi

# Atualização completa dos repositórios e do sistema
sudo pacman -Syyu

# Instalação do Gnome Shell e outras ferramentas
sudo pacman --needed -S gdm gnome gnome-tweaks htop iwd nano openssh smartmontools vim wget wireless_tools wpa_supplicant xdg-utils

# Ativação do gerenciador de login do Gnome
sudo systemctl enable gdm

# Criação/Atualização dos diretórios padrões de usuário
xdg-user-dirs-update

# Configurações da barra superior (mostrar a data e os segundos)
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true

# Instalação do tema Yaru
# Link: https://aur.archlinux.org/packages/yaru-gnome-shell-theme
# Use o helper paru para instalar os pacotes
paru --needed --noconfirm -S --batchinstall --skipreview --removemake --mflags -Cris inkscape xorg-server-xvfb yaru-gnome-shell-theme

# Ative a extensão "User Themes"  e vá no gnome-tweaks e configure o tema

# Gerenciador de Extensões via Browser
sudo pacman --needed -S gnome-browser-connector

# Instalação da extensão "AppIndicator and KStatusNotifierItem Support"
sudo pacman -S gnome-shell-extension-appindicator

# Instalação da extensão "gnome-shell-extension-dash-to-dock (AUR)"
# Mova o Dash para fora da visão geral, transformando-o em um dock
paru --needed -S --skipreview --removemake --mflags -Cris gnome-shell-extension-dash-to-dock

# Outras extensões úteis (instale via navegador):
# - Boost Volume: Aumenta o volume acima dos limites. Link: https://extensions.gnome.org/extension/6928/boost-volume/
# - Gradient Top Bar: Torna o gradiente de fundo do painel do GNOME. Link: https://extensions.gnome.org/extension/4955/gradient-top-bar/
# - Transparent Top Bar: Barra superior transparente ao flutuar livremente no GNOME. Link: https://extensions.gnome.org/extension/1708/transparent-top-bar/
# - IP Finder: Exibe informações úteis sobre seu endereço IP público e status da VPN. Link: https://extensions.gnome.org/extension/2983/ip-finder/

# Sugestão de aplicativos adicionais:
# - gnome-firmware: Gerencia firmware em dispositivos suportados pelo fwupd
# - gnome-shell-extension-caffeine: Desativa o protetor de tela e suspensão automática
# - power-profiles-daemon: Gerencia perfis de potência (ótimo para notebooks)
# - gufw: Gerenciador de firewall
# - deja-dup: Ferramenta de backup com interface gráfica
# - timeshift: Utilitário de restauração do sistema
# - gdm-settings (AUR): Configurações para o Gerenciador de Login do Gnome
# - dynamic-wallpaper (AUR): Cria papéis de parede dinâmicos
# - collision (padrão no Manjaro): Verifica hashes de arquivos
# - gtkhash-git (AUR): Calcula resumos de mensagens ou somas de verificação

# Consulte a documentação para mais detalhes sobre cada aplicativo.

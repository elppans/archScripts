#!/bin/bash
# Script para remover todos os pacotes e manter apenas a base do sistema no Arch Linux (Formatar "sem formatar")

# Verifica se o usuário tem privilégios sudo
if sudo -l -U $USER &> /dev/null; then
    # echo "O usuário $USER tem acesso sudo."
    USERNAME="$USER"
else
    echo "O usuário $USER NÃO tem acesso sudo."
    # Defina um valor padrão para USERNAME ou saia do script, conforme necessário
    # Exemplo: USERNAME="valor_padrao"
    exit 1
fi

# Variáveis para o diretório HOME e backup na data atual
HM="$(basename $HOME)"
HMN="$HM.BKP_$(date +%d%m%H%M)"

# Renomeia o diretório "HOME" para backup e cria um novo diretório de usuário
cd /home
mv -v /home/$HM /home/$HMN
mkdir -p $HOME
cp -av /etc/skel/.bash* $HOME
chown -R $USER:$USER $HOME

# Redefine o shell do usuário para /bin/bash
chsh -s /bin/bash $USER

# Pausa para verificar se as respostas estão corretas
read -p "Pressione ENTER para continuar ou CTRL+C para cancelar..." ;

# Altera o motivo de instalação de TODOS os pacotes instalados "como Explicitamente" para "como dependência"
pacman -D --asdeps $(pacman -Qqe)

read -p "Pressione ENTER para continuar..." ;

# Altera o motivo da instalação para "como explicitamente" apenas os PACOTES ESSENCIAIS
pacman -D --asexplicit base base-devel linux linux-headers linux-firmware \
    amd-ucode intel-ucode btrfs-progs \
    git fakeroot reflector nano ntp man-db man-pages texinfo \
    grub-efi-x86_64 efibootmgr dosfstools os-prober \
    mtools networkmanager wpa_supplicant wireless_tools \
    dialog sudo yay mlocate pkgconf wget

read -p "Pressione ENTER para continuar..." ;

# Remove os pacotes, exceto os configurados como "Instalados Explicitamente"
pacman -Rsunc $(pacman -Qtdq)

read -p "Pressione ENTER para continuar..." ;

# Retorna alguns pacotes de compilação
pacman --needed --noconfirm -S base-devel

read -p "Pressione ENTER para continuar..." ;

# Garante o GRUB
pacman -S --needed --noconfirm grub-efi-x86_64 efibootmgr dosfstools os-prober mtools

# Atualiza a configuração do GRUB
grub-mkconfig -o /boot/grub/grub.cfg

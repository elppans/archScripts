#!/bin/bash

dev1="$1"
dev2="$2"
dev3="$3"

if ! command -v arch-chroot &>/dev/null; then
    echo "Erro: O comando 'arch-chroot' não foi encontrado."
    exit 1
fi

if [ -z "$dev1" ]; then
    echo "Erro: Informe o device que será a raiz do sistema."
    exit 1
fi

if [ -z "$dev2" ]; then
    echo "Erro: Informe o device que será o EFI do sistema."
    exit 1
fi

if [ -z "$dev3" ]; then
    echo "Erro: Informe o device que será o home do sistema."
    exit 1
fi

swapon -a
mount -o relatime,space_cache=v2,discard=async,autodefrag,compress=zstd,commit=10,subvol=@ /dev/sda6 /mnt
mount -o relatime,space_cache=v2,discard=async,autodefrag,compress=zstd,commit=10,subvol=@cache /dev/sda6 /mnt/var/cache
mount -o relatime,space_cache=v2,discard=async,autodefrag,compress=zstd,commit=10,subvol=@log /dev/sda6 /mnt/var/log
mount -o relatime,space_cache=v2,discard=async,autodefrag,compress=zstd,commit=10,subvol=@home /dev/sda3 /mnt/home
mount /dev/sda1 /mnt/boot/efi
mount | grep "/mnt"
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinux --recheck
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

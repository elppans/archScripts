#!/bin/bash
# Instalação dos pacotes para Direct3D e Renderização de Software

# Variável IRQ do driver NVIDIA
# 01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GK208B [GeForce GT 710] [10de:128b] (rev a1)
MESA_VK_DEVICE_SELECT=$(lspci -nn | grep VGA | awk '{print $12}' | sed 's/\[//;s/\]//')
export MESA_VK_DEVICE_SELECT

# Driver Vulkan Direct3D 12 to Vulkan translation library By WineHQ
sudo pacman --needed -S vkd3d lib32-vkd3d

# Rasterizadores de software Vulkan, lavapipe
sudo pacman --needed -S vulkan-swrast lib32-vulkan-swrast

# Backup do arquivo de variávies do sistema
sudo cp /etc/environment /etc/environment.bkp_"$(date +%d%m%H%M)"

# Configuração de variáveis NOUVEAU/Mesa VK
echo -e "
# NOUVEAU/Mesa VK
# VK_DRIVER_FILES=/usr/share/vulkan/icd.d/nouveau_icd.i686.json:/usr/share/vulkan/icd.d/nouveau_icd.x86_64.json
# VK_DRIVER_FILES=/usr/share/vulkan/icd.d/lvp_icd.i686.json:/usr/share/vulkan/icd.d/lvp_icd.x86_64.json
VK_DRIVER_FILES=/usr/share/vulkan/icd.d/nvidia_icd.json
NVK_I_WANT_A_BROKEN_VULKAN_DRIVER=1
MESA_VK_DEVICE_SELECT=$MESA_VK_DEVICE_SELECT
MESA_VK_DEVICE_SELECT_FORCE_DEFAULT_DEVICE=1
# LIBGL_ALWAYS_SOFTWARE=1
# __GLX_VENDOR_LIBRARY_NAME=mesa
__GLX_VENDOR_LIBRARY_NAME=nvidia
# DRI_PRIME=1
" | sudo tee -a /etc/environment >> /dev/null

# Variáveis

# VK_DRIVER_FILES:
#   - Essa variável especifica os arquivos de driver Vulkan a serem usados.
#   - No seu caso, os arquivos especificados são /usr/share/vulkan/icd.d/lvp_icd.i686.json e /usr/share/vulkan/icd.d/lvp_icd.x86_64.json.
#   - Esses arquivos contêm informações sobre os drivers Vulkan disponíveis no sistema.
#   - O Vulkan carrega esses arquivos para determinar quais drivers estão instalados e disponíveis para uso.

# NVK_I_WANT_A_BROKEN_VULKAN_DRIVER=1:
#   - Essa variável é específica para o driver Vulkan "lvp" (Lavapipe).
#   - Quando definida como 1, ela permite que você use uma versão experimental ou "quebrada" do driver Lavapipe.
#   - Isso pode ser útil para depurar problemas ou testar recursos específicos do driver.
#   - Também se você possui uma placa de vídeo antiga da NVIDIA.

# MESA_VK_DEVICE_SELECT=10de:128b:
#   - Essa variável define o dispositivo Vulkan a ser usado.
#   - O valor "10de:128b" como exemplo, corresponde ao ID da sua placa de vídeo NVIDIA GeForce GT 710.
#   - Ela direciona o Vulkan para usar essa GPU específica para renderização.

# __GLX_VENDOR_LIBRARY_NAME=mesa:
#   - Essa variável especifica a biblioteca GLX (OpenGL Extension to the X Window System) a ser usada.
#   - Definindo-a como "mesa", você garante que a biblioteca GLX da Mesa (open-source) seja usada.
#   - Isso é relevante quando você deseja usar o OpenGL com a renderização de software ou com drivers Mesa.

# Variáveis Opcionais

# MESA_VK_DEVICE_SELECT_FORCE_DEFAULT_DEVICE=1:
#   - Essa variável é usada para forçar a seleção do dispositivo de renderização Vulkan padrão.
#   - Quando você define essa variável como 1, o sistema sempre escolhe o dispositivo Vulkan padrão, independentemente de outras configurações ou dispositivos disponíveis.
#   - Use essa variável se você deseja garantir que o dispositivo Vulkan padrão seja sempre selecionado.

# LIBGL_ALWAYS_SOFTWARE=1:
#   - Essa variável força a renderização de software para aplicativos que usam a biblioteca OpenGL (libGL).
#   - Quando ativada, a renderização será feita exclusivamente por software, ignorando qualquer aceleração de hardware.
#   - Use essa variável se você estiver depurando problemas de hardware ou se precisar executar aplicativos OpenGL em modo de renderização de software.

# __GLX_VENDOR_LIBRARY_NAME=nvidia:
#   - Essa variável especifica a biblioteca GLX (OpenGL Extension to the X Window System) a ser usada.
#   - Definindo-a como "nvidia", você garante que a biblioteca GLX da NVIDIA seja usada.
#   - Isso pode ser útil se você estiver usando drivers proprietários da NVIDIA e desejar garantir compatibilidade com aplicativos específicos.

# DRI_PRIME=1:
#   - Essa variável é usada para ativar a renderização de GPU discreta (como uma placa NVIDIA) em sistemas híbridos com GPUs integradas (como Intel ou AMD).
#   - Quando definida como 1, o DRI (Direct Rendering Infrastructure) prioriza a GPU discreta para renderização.
#   - Use essa variável se você deseja direcionar aplicativos específicos para a GPU dedicada em um laptop ou sistema com duas GPUs.

# Essas variáveis devem ser configuradas no arquivo /etc/environment e exigem uma reinicialização do sistema para que as alterações tenham efeito.


# Fontes:

# https://wiki.archlinux.org/title/Vulkan
# https://wiki.winehq.org/Vkd3d

#!/bin/bash

echo "===== Arch Linux Steam Installer ====="
echo

# Detect GPU vendor
GPU=$(lspci | grep -E "VGA|3D" | grep -E "AMD|NVIDIA|Intel")

echo "[+] Detected GPU:"
echo "$GPU"
echo

# Suggest correct Vulkan drivers
echo "[+] Suggested Vulkan packages based on your GPU:"
if echo "$GPU" | grep -q "AMD"; then
    echo "   • vulkan-radeon"
    echo "   • lib32-vulkan-radeon"
elif echo "$GPU" | grep -q "NVIDIA"; then
    echo "   • nvidia-utils"
    echo "   • lib32-nvidia-utils"
elif echo "$GPU" | grep -q "Intel"; then
    echo "   • vulkan-intel"
    echo "   • lib32-vulkan-intel"
else
    echo "   • Unknown GPU detected, manually choose Vulkan drivers."
fi

echo
read -p "Install suggested Vulkan drivers? (y/n): " vulk

if [[ $vulk == "y" ]]; then
    if echo "$GPU" | grep -q "AMD"; then
        sudo pacman -S --noconfirm vulkan-radeon lib32-vulkan-radeon
    elif echo "$GPU" | grep -q "NVIDIA"; then
        sudo pacman -S --noconfirm nvidia-utils lib32-nvidia-utils
    elif echo "$GPU" | grep -q "Intel"; then
        sudo pacman -S --noconfirm vulkan-intel lib32-vulkan-intel
    fi
else
    echo "[!] Skipping Vulkan driver auto-install..."
fi

echo
echo "[+] Installing Steam..."
echo "You will choose from pacman menu (steam / steam-native-runtime)."
sudo pacman -S steam

echo
read -p "Install ProtonUp-QT + Proton GE 10-26? (y/n): " ge

if [[ $ge == "y" ]]; then
    echo "[+] Installing ProtonUp-QT..."
    if ! command -v yay &> /dev/null; then
        echo "[+] yay not found, installing..."
        cd ~
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
    fi

    yay -S --noconfirm protonup-qt

    echo "[+] Downloading Proton GE 10-26..."
    mkdir -p ~/.steam/root/compatibilitytools.d
    cd ~/.steam/root/compatibilitytools.d
    wget -q https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton10-26/GE-Proton10-26.tar.gz
    tar -xvf GE-Proton10-26.tar.gz
    rm GE-Proton10-26.tar.gz
fi

echo
echo "===== Installation Complete ====="
echo "Launch Steam and select GE-Proton10-26 under Compatibility."

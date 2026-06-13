#!/bin/bash
# https://github.com/PiercingXX

set -e

install_optional() {
    local package="$1"
    if ! sudo apt install -y "$package"; then
        echo "Optional package skipped: $package"
    fi
}

if [ -f /etc/os-release ]; then
    . /etc/os-release
fi

if [[ "$ID" == "ubuntu" ]]; then
    sudo add-apt-repository universe -y || true
fi

sudo apt update
sudo apt upgrade -y

echo "Installing Sway core components..."
sudo apt install -y sway swaybg swayidle swaylock xdg-desktop-portal xdg-desktop-portal-wlr xwayland qtwayland5

echo "Installing Wayland bar and launcher stack..."
sudo apt install -y waybar fuzzel wlogout libnotify-bin jq

echo "Installing clipboard and screenshot tools..."
sudo apt install -y wl-clipboard grim slurp brightnessctl light golang-go

echo "Installing auth and session helpers..."
sudo apt install -y policykit-1-gnome plasma-workspace gnome-keyring xdg-user-dirs

echo "Installing terminal and file tools..."
sudo apt install -y kitty tmux nautilus rename

echo "Installing audio stack..."
sudo apt install -y pipewire pipewire-pulse wireplumber pavucontrol playerctl easyeffects

echo "Installing network and bluetooth utilities..."
sudo apt install -y network-manager network-manager-gnome bluez bluez-tools blueman

echo "Installing customization utilities..."
sudo apt install -y dconf-cli

echo "Installing compatibility wrappers for missing WM helpers..."
bash "$(dirname "$0")/wm-compat.sh"

# Keep one network manager active across TTY and WMs.
bash "$(dirname "$0")/network-manager-setup.sh"

echo -e "\nAll Sway packages installed successfully!"
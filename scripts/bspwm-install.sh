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

echo "Installing bspwm core components..."
sudo apt install -y bspwm sxhkd polybar picom

echo "Installing X11 utilities used by bspwm config..."
sudo apt install -y x11-xserver-utils x11-utils xinput x11-xkb-utils xclip

echo "Installing launcher, background, and screenshot tools..."
sudo apt install -y hsetroot flameshot sxiv zathura rofi libnotify-bin jq

echo "Installing terminal and input tools..."
sudo apt install -y kitty fcitx5 fcitx5-frontend-gtk3 fcitx5-module-xorg

echo "Installing network and auth helpers..."
sudo apt install -y network-manager network-manager-gnome policykit-1-gnome gnome-keyring

echo "Installing optional swallow helper dependencies..."
install_optional xdo

echo "Installing compatibility wrappers for missing WM helpers..."
bash "$(dirname "$0")/wm-compat.sh"

# Keep one network manager active across TTY and WMs.
bash "$(dirname "$0")/network-manager-setup.sh"

echo -e "\nAll bspwm packages installed successfully!"
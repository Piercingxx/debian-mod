#!/bin/bash
# https://github.com/PiercingXX

set -e

if [ -f /etc/os-release ]; then
    . /etc/os-release
fi

if [[ "$ID" == "ubuntu" ]]; then
    sudo add-apt-repository universe -y || true
fi

sudo apt update
sudo apt upgrade -y

echo "Installing Awesome core components..."
sudo apt install -y awesome picom dunst

echo "Installing X11 utilities used by Awesome config..."
sudo apt install -y x11-xserver-utils x11-utils xinput x11-xkb-utils numlockx xterm xclip xdotool arandr

echo "Installing launcher, wallpaper, and notification tools..."
sudo apt install -y rofi feh nitrogen lxappearance libnotify-bin

echo "Installing terminal, editor, and font tools..."
sudo apt install -y kitty neovim tmux fonts-jetbrains-mono

echo "Installing audio and brightness controls..."
sudo apt install -y pipewire pipewire-pulse wireplumber pavucontrol playerctl brightnessctl light easyeffects

echo "Installing auth/session helpers..."
sudo apt install -y policykit-1-gnome gnome-keyring network-manager network-manager-gnome

echo "Installing compatibility wrappers for missing WM helpers..."
bash "$(dirname "$0")/wm-compat.sh"

echo -e "\nAll Awesome packages installed successfully!"
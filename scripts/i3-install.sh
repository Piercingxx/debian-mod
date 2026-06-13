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

echo "Installing i3 core components..."
sudo apt install -y i3 i3blocks picom

echo "Installing X11 utilities used by i3 config..."
sudo apt install -y x11-xserver-utils x11-utils xinput x11-xkb-utils numlockx feh xterm xclip

echo "Installing launcher, clipboard, and screenshot tools..."
sudo apt install -y rofi wl-clipboard pavucontrol playerctl light flameshot jq libnotify-bin golang-go

echo "Installing audio helpers..."
sudo apt install -y pipewire pipewire-pulse wireplumber easyeffects

echo "Installing auth and session helpers..."
sudo apt install -y policykit-1-gnome gnome-keyring network-manager network-manager-gnome

echo "Installing terminal and file tools..."
sudo apt install -y kitty tmux nautilus rename

echo "Installing system utility dependencies..."
sudo apt install -y acpi upower

echo "Installing compatibility wrappers for missing WM helpers..."
bash "$(dirname "$0")/wm-compat.sh"

# Keep one network manager active across TTY and WMs.
bash "$(dirname "$0")/network-manager-setup.sh"

echo -e "\nAll i3 packages installed successfully!"
#!/bin/bash
# https://github.com/piercingxx

username=$(id -u -n 1000)
builddir=$(pwd)

sudo add-apt-repository universe -y
sudo apt update
sudo apt upgrade -y

sudo apt install just -y
sudo apt install rustc -y
sudo apt install libglvnd-dev -y
sudo apt install libwayland-dev -y
sudo apt install libseat-dev -y
sudo apt install libxkbcommon-dev -y
sudo apt install libinput-dev -y
sudo apt install udev -y
sudo apt install dbus -y
sudo apt install libdbus-1-dev -y
sudo apt install libpam0g-dev -y
sudo apt install libpixman-1-dev -y
sudo apt install libssl-dev -y
sudo apt install libflatpak-dev -y
sudo apt install libsystemd-dev -y
sudo apt install libpulse-dev -y
sudo apt install pop-launcher-y
sudo apt install libexpat1-dev -y
sudo apt install libfontconfig-dev -y
sudo apt install libfreetype-dev -y
sudo apt install mold -y
sudo apt install cargo -y
sudo apt install libgbm-dev -y
sudo apt install libclang-dev -y
sudo apt install libpipewire-0.3-dev -y





git clone --recurse-submodules https://github.com/pop-os/cosmic-epoch
cd cosmic-epoch
just sysext
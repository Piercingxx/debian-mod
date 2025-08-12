#!/bin/bash
# https://github.com/Piercing666

username=$(id -u -n 1000)
builddir=$(pwd)

echo "Starting Script 1.sh"
sleep 2

# Checks for active network connection
if [[ -n "$(command -v nmcli)" && "$(nmcli -t -f STATE g)" != connected ]]; then
    awk '{print}' <<< "Network connectivity is required to continue."
    exit
fi

# Enables non-free repositories and adds them to the sources list.
sudo rm /etc/apt/sources.list
sudo touch /etc/apt/sources.list 
sudo chmod +rwx /etc/apt/sources.list
sudo printf "deb https://deb.debian.org/debian/ stable main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security stable-security/updates main contrib non-free non-free-firmware
deb https://deb.debian.org/debian/ stable-updates main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian/ stable-updates main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list

sudo add-apt-repository ppa:graphics-drivers/ppa -y

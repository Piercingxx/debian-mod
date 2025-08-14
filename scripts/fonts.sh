#!/bin/bash
# GitHub.com/PiercingXX

username=$(id -u -n 1000)
builddir=$(pwd)

# Create Directories if needed
    # font directory
        if [ ! -d "$HOME/.fonts" ]; then
            mkdir -p "$HOME/.fonts"
        fi
        chown -R "$username":"$username" "$HOME"/.fonts
    # icons directory
        if [ ! -d "$HOME/.icons" ]; then
            mkdir -p /home/"$username"/.icons
        fi
        chown -R "$username":"$username" /home/"$username"/.icons
    # Installing fonts
    echo "Installing Fonts"
    cd "$builddir" || exit
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
    unzip FiraCode.zip -d /home/"$username"/.fonts
    unzip Meslo.zip -d /home/"$username"/.fonts
    sudo rm FiraCode.zip Meslo.zip
    sudo apt install fonts-font-awesome fonts-noto-color-emoji -y
    sudo apt install fonts-terminus -y
    sudo apt install fonts-noto-color-emoji -y
    # Reload Font
        fc-cache -vf
        wait
#!/bin/bash
# https://github.com/PiercingXX

username=$(id -u -n 1000)
builddir=$(pwd)


# Create Directories if needed
    # font directory
        if [ ! -d "$HOME/.fonts" ]; then
            mkdir -p "$HOME/.fonts"
        fi
        chown -R "$username":"$username" "$HOME"/.fonts
    # config directory
        if [ ! -d "$HOME/.config" ]; then
            mkdir -p /home/"$username"/.config
        fi
        chown -R "$username":"$username" /home/"$username"/.config
    # icons directory
        if [ ! -d "$HOME/.icons" ]; then
            mkdir -p /home/"$username"/.icons
        fi
        chown -R "$username":"$username" /home/"$username"/.icons
    # Background and Profile Image Directories
        if [ ! -d "$HOME/$username/Pictures/backgrounds" ]; then
            mkdir -p /home/"$username"/Pictures/backgrounds
        fi
        chown -R "$username":"$username" /home/"$username"/Pictures/backgrounds
        if [ ! -d "$HOME/$username/Pictures/profile-image" ]; then
            mkdir -p /home/"$username"/Pictures/profile-image
        fi
        chown -R "$username":"$username" /home/"$username"/Pictures/profile-image

# Update System
    echo -e "${YELLOW}Updating System...${NC}"  
        sudo apt update && sudo apt upgrade -y || true
        wait
        sudo apt full-upgrade -y
        wait
        sudo apt install -f
        wait
        sudo dpkg --configure -a
        sudo apt --fix-broken install -y
        wait
        sudo apt autoremove -y
        sudo apt update && sudo apt upgrade -y || true
    # Check if nala is installed
        if ! command_exists nala; then
            echo "nala is not installed. Installing now..."
            sudo apt install nala -y
        fi
        wait
    # Install flatpak
        sudo apt install flatpak -y
        sudo apt install gnome-software-plugin-flatpak -y
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        wait
#        flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
        flatpak update -y
    wait

# Install dependencies
    sudo apt install wget gpg zip unzip gzip tar make curl gcc gettext -y
    sudo apt install build-essential -y
    sudo apt install linux-firmware -y
    sudo apt install firmware-misc-nonfree -y
    sudo apt install pipx -y
    sudo apt install jq -y
    pipx install gnome-extensions-cli --system-site-packages
    pipx ensurepath
    wait
    sudo apt install gnome-shell -y
    sudo apt install trash-cli -y
    sudo apt install kitty -y
    sudo apt install dconf* -y
    sudo apt install gnome-tweaks -y
    sudo apt install dbus-x11 -y
    sudo apt install cups -y
    sudo apt install util-linux -y
    sudo apt install xdg-utils -y
    sudo apt install nautilus -y
    sudo apt install gnome-disk-utility -y
    sudo apt install gnome-calculator -y
    sudo apt install gdebi -y
    sudo apt install fuse -y
    sudo apt install libfuse2 -y
    sudo apt install libinput-tools -y
    sudo apt install x11-xserver-utils -y
    sudo apt install dh-dkms -y
    sudo apt install devscripts -y
    sudo apt install linux-headers-generic -y
    sudo apt install seahorse -y
    sudo apt install rename -y
    sudo apt install mpv -y
    sudo apt install gparted -y
    sudo apt install gh -y
    sudo apt install papirus-icon-theme -y
# Extras for yazi
    sudo apt install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick -y

# Ensure Rust is installed
    if ! command_exists cargo; then
        echo -e "${YELLOW}Installing Rust toolchain…${NC}"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        rustup update
        # Load the new cargo environment for this shell
        source "$HOME/.cargo/env"
    fi

# Installing fonts
    echo "Installing Fonts"
    cd "$builddir" || exit
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
    wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip
    unzip FiraCode.zip -d /home/"$username"/.fonts
    unzip Meslo.zip -d /home/"$username"/.fonts
    unzip NerdFontsSymbolsOnly.zip -d /home/"$username"/.fonts
    sudo rm FiraCode.zip Meslo.zip NerdFontsSymbolsOnly.zip
    sudo apt install fonts-font-awesome fonts-noto-color-emoji -y
    sudo apt install fonts-terminus -y
    sudo apt install fonts-noto-color-emoji -y
# Reload Font
    fc-cache -vf
    wait

# Add GDM Banner Message
sudo tee -a /etc/gdm3/greeter.dconf-defaults > /dev/null <<EOF
# - Show a login welcome message
banner-message-enable=true
banner-message-text='Hello Handsome'
EOF
# Finalizing graphical login
    sudo systemctl enable gdm3 --now

# Extensions
    echo "Gnome Extensions"
        sudo apt install gnome-shell-extension-appindicator -y
        sudo apt install gnome-shell-extension-gsconnect -y
        sudo apt install gnome-shell-extension-caffeine -y
        sudo apt install gnome-shell-extension-blur-my-shell -y
        sudo apt install gnome-shell-extension-tiling-assistant -y
    # Nautilus Customization
        sudo apt install gnome-sushi -y
        sudo apt install imagemagick nautilus-image-converter -y
        sudo apt install nautilus-admin -y
        sudo apt install gir1.2-gtk-4.0 -y
        git clone https://github.com/Stunkymonkey/nautilus-open-any-terminal.git
        cd nautilus-open-any-terminal || exit
        make
        sudo make install schema
        glib-compile-schemas /usr/share/glib-2.0/schemas
        cd "$builddir" || exit
        rm -rf nautilus-open-any-terminal
        wait
    # Workspaces Buttons with App Icons
        git clone --depth=1 https://github.com/Favo02/workspaces-by-open-apps.git
        cd workspaces-by-open-apps || exit 1
        uuid=$(jq -r '.uuid' metadata.json 2>/dev/null)
        [ -z "$uuid" ] || [ "$uuid" = "null" ] && uuid="workspaces-by-open-apps@favo02.github.com"
        extbase="/home/$username/.local/share/gnome-shell/extensions"
        sudo mkdir -p "$extbase/$uuid"
        sudo rm -rf "$extbase/$uuid"/*
        sudo cp -a ./* "$extbase/$uuid"/
        if command -v glib-compile-schemas >/dev/null 2>&1 && [ -d "$extbase/$uuid/schemas" ]; then
            sudo glib-compile-schemas "$extbase/$uuid/schemas" || true
        fi
        sudo chown -R "$username:$username" "$extbase/$uuid"
        sudo -u "$username" gnome-extensions enable "$uuid" || true
        cd "$builddir" || exit 1
        rm -rf workspaces-by-open-apps
    # Super Key
        git clone --depth=1 https://github.com/Tommimon/super-key.git
        cd super-key || exit 1
        uuid=$(jq -r '.uuid' metadata.json 2>/dev/null)
        [ -z "$uuid" ] || [ "$uuid" = "null" ] && uuid=$(grep -Po '(?<="uuid": ")[^"]*' metadata.json 2>/dev/null || echo "super-key@tommimon.github.com")
        extbase="/home/$username/.local/share/gnome-shell/extensions"
        sudo mkdir -p "$extbase/$uuid"
        sudo rm -rf "$extbase/$uuid"/*
        sudo cp -a ./* "$extbase/$uuid"/
        if command -v glib-compile-schemas >/dev/null 2>&1 && [ -d "$extbase/$uuid/schemas" ]; then
            sudo glib-compile-schemas "$extbase/$uuid/schemas" || true
        fi
        sudo chown -R "$username:$username" "$extbase/$uuid"
        sudo -u "$username" gnome-extensions enable "$uuid" || true
        cd "$builddir" || exit 1
        rm -rf super-key
    # Just Perfection
        shell_ver=$(gnome-shell --version | awk '{print $3}' | cut -d. -f1,2)
        info=$(curl -fsSL "https://extensions.gnome.org/extension-info/?uuid=just-perfection-desktop%40just-perfection&shell_version=$shell_ver" || true)
        if [ -z "$info" ] || [ "$(echo "$info" | jq -r '.error // empty')" != "" ]; then
            shell_major=$(echo "$shell_ver" | cut -d. -f1)
            info=$(curl -fsSL "https://extensions.gnome.org/extension-info/?uuid=just-perfection-desktop%40just-perfection&shell_version=$shell_major" || true)
        fi
        url=$(echo "$info" | jq -r '.download_url // empty')
        if [ -n "$url" ]; then
            tmpzip="$(mktemp --suffix=.zip)"
            curl -fsSL "https://extensions.gnome.org${url}" -o "$tmpzip"
            gnome-extensions install --force "$tmpzip" || echo "Failed to install Just Perfection"
            gnome-extensions enable just-perfection-desktop@just-perfection || true
            rm -f "$tmpzip"
        else
            echo "Could not find a compatible Just Perfection extension for GNOME $shell_ver"
        fi
    # Tailscale QS
        git clone https://github.com/joaophi/tailscale-gnome-qs.git
        cd tailscale-gnome-qs || exit 1
        make build
        make install
        cd "$builddir" || exit 1
        rm -rf tailscale-gnome-qs
    # Pop Shell
        sudo apt install -y nodejs npm libglib2.0-dev-bin
        git clone --depth=1 https://github.com/pop-os/shell.git pop-os-shell
        cd pop-os-shell || exit
        git submodule update --init --recursive
        make local-install || {
            echo "Pop Shell build failed"
            exit 1
        }
        if [ -d "$HOME/.local/share/gnome-shell/extensions/pop-shell@system76.com/schemas" ]; then
            glib-compile-schemas "$HOME/.local/share/gnome-shell/extensions/pop-shell@system76.com/schemas"
        fi
        cd "$builddir" || exit
        rm -rf pop-os-shell


# Remove unwanted apps
    sudo apt remove gnome-terminal --purge -y
    sudo apt remove firefox --purge -y
    sudo apt remove firefox-esr --purge -y
    sudo apt remove evolution --purge -y
    sudo apt remove shotwell --purge -y

# Overkill is underrated 
    sudo apt update && sudo apt upgrade -y || true
    wait
    sudo apt full-upgrade -y
    wait
    sudo apt install -f
    wait
    sudo dpkg --configure -a
    sudo apt --fix-broken install -y
    wait
    sudo apt autoremove -y
    sudo apt update && sudo apt upgrade -y || true
    wait
    flatpak update -y

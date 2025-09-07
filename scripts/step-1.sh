#!/bin/bash
# https://github.com/PiercingXX

username=$(id -u -n 1000)
builddir=$(pwd)

install_starship() {
    if ! command_exists starship; then
        if ! curl -sS https://starship.rs/install.sh | sh; then
            print_colored "$RED" "Something went wrong during starship install!"
            exit 1
        fi
    else
        printf "Starship already installed\n"
    fi
}

install_zoxide() {
    if ! command_exists zoxide; then
        if ! curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh; then
            print_colored "$RED" "Something went wrong during zoxide install!"
            exit 1
        fi
    else
        printf "Zoxide already installed\n"
    fi
}


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
    # fstab external drive mounting directory
        if [ ! -d "$HOME/.media/Working-Storage" ]; then
            mkdir -p /home/"$username"/media/Working-Storage
        fi
        chown "$username":"$username" /home/"$username"/media/Working-Storage
        if [ ! -d "$HOME/.media/Archived-Storage" ]; then
            mkdir -p /home/"$username"/media/Archived-Storage
        fi
        chown "$username":"$username" /home/"$username"/media/Archived-Storage

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
        flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
        wait
        flatpak update -y
    wait

# Install dependencies
    sudo apt install wget gpg zip unzip gzip tar make curl gcc gettext -y
    sudo apt install build-essential -y
    sudo apt install pipx -y
    pipx install gnome-extensions-cli --system-site-packages
    pipx ensurepath
    wait
    sudo apt install gnome-shell -y
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
    # Bash Stuff
    sudo apt install bash bash-completion bat tree multitail fastfetch fontconfig trash-cli -y
    sudo apt install fzf -y
    install_starship
    install_zoxide
    # Install exa via cargo...exa is not in apt on Debian 13 yet sudo apt install exa -y
    cargo install exa

# Install Yazi via cargo
    # Ensure Rust is installed
    if ! command_exists cargo; then
        echo -e "${YELLOW}Installing Rust toolchain…${NC}"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        # Load the new cargo environment for this shell
        source "$HOME/.cargo/env"
    fi
    # Verify cargo is now available
    if ! command_exists cargo; then
        echo -e "${RED}Cargo could not be found after installation. Aborting Yazi install.${NC}"
        exit 1
    fi
    echo -e "${YELLOW}Installing Yazi via source build…${NC}"
    # Ensure Yazi's binary directory is in the PATH for this session
    export PATH="$HOME/.cargo/bin:$PATH"
    # Clone the Yazi repository (use the latest release tag)
    YAZI_REPO="https://github.com/sxyazi/yazi.git"
    YAZI_DIR="/tmp/yazi-build"
    git clone --depth 1 "$YAZI_REPO" "$YAZI_DIR" || { echo -e "${RED}Failed to clone Yazi repo.${NC}"; exit 1; }
    # Build the binary
    cd "$YAZI_DIR" || exit
    cargo build --release || { echo -e "${RED}Cargo build failed.${NC}"; exit 1; }
    # Install the binary
    sudo install -Dm755 target/release/yazi /usr/local/bin/yazi
    # Clean up
    cd "$BUILD_DIR" || exit
    rm -rf "$YAZI_DIR"

# Remove unwanted apps
    sudo apt remove gnome-terminal --purge -y
    sudo apt remove firefox --purge -y
    sudo apt remove firefox-esr --purge -y
    sudo apt remove evolution --purge -y
    sudo apt remove shotwell --purge -y

# Add GDM Banner Message
sudo tee -a /etc/gdm3/greeter.dconf-defaults > /dev/null <<EOF
# - Show a login welcome message
banner-message-enable=true
banner-message-text='Hello Handsome'
EOF
# Finalizing graphical login
    sudo systemctl enable gdm3 --now

# Fonts Installation
    chmod u+x fonts.sh
    sudo ./fonts.sh
    wait

# Extensions
    echo "Gnome Extensions"
        sudo apt install gnome-shell-extension-appindicator -y
        sudo apt install gnome-shell-extension-gsconnect -y
        sudo apt install gnome-shell-extension-caffeine -y
        sudo apt install gnome-shell-extension-blur-my-shell -y
        sudo apt install gnome-shell-extension-tiling-assistant -y
    # Super Key
        git clone https://github.com/Tommimon/super-key.git
        cd super-key || exit
        ./build.sh -i
        cd "$builddir" || exit
        rm -rf super-key
    # Useless Gaps
        git clone https://github.com/mipmip/gnome-shell-extensions-useless-gaps.git
        cd gnome-shell-extensions-useless-gaps || exit
        sudo ./install.sh local-install
        cd "$builddir" || exit
        rm -rf gnome-shell-extensions-useless-gaps
    # Just Perfection
        wget https://extensions.gnome.org/extension-data/just-perfection-desktopjust-perfection.v34.shell-extension.zip
        unzip just-perfection-desktopjust-perfection.v34.shell-extension.zip
        mv just-perfection-desktop@just-perfection ~/.local/share/gnome-shell/extensions/
        rm just-perfection-desktopjust-perfection.v34.shell-extension.zip
    # Workspaces Buttons with App Icons
        git clone https://codeload.github.com/Favo02/workspaces-by-open-apps/zip/refs/heads/main
        unzip workspaces-by-open-apps-main.zip
        cd workspaces-by-open-apps-main || exit
        sudo ./install.sh local-install
        cd "$builddir" || exit
        rm -rf workspaces-by-open-apps-main
    # Tailscale QS
        git clone https://github.com/joaophi/tailscale-gnome-qs.git
        cd tailscale-gnome-qs || exit
        make build
        make install
        cd "$builddir" || exit
        rm -rf tailscale-gnome-qs
        sudo tailscale set --operator="$username"
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

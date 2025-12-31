#!/bin/bash
# https://github.com/PiercingXX

username=$(id -u -n 1000)
builddir=$(pwd)


# Checks for active network connection
if [[ -n "$(command -v nmcli)" && "$(nmcli -t -f STATE g)" != connected ]]; then
    awk '{print}' <<<"Network connectivity is required to continue."
    exit
fi

echo "Updating Repositories"
sudo apt update && sudo apt upgrade -y || true
sudo apt install flatpak -y
sudo apt install gnome-software-plugin-flatpak -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
wait
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
wait
sudo apt update && sudo apt upgrade -y || true
sudo apt full-upgrade -y
sudo apt install -f
wait
flatpak update

# Installing important things && stuff && some dependencies
    echo "Installing Apps & Dependencies"
    sudo apt install fwupd -y
    flatpak install flathub net.waterfox.waterfox -y
    flatpak install flathub md.obsidian.Obsidian -y
    flatpak install flathub org.gimp.GIMP -y
    flatpak install flathub org.darktable.Darktable -y
    flatpak install flathub org.blender.Blender -y
    flatpak install flathub com.mattjakeman.ExtensionManager -y
    flatpak install flathub org.qbittorrent.qBittorrent -y
    flatpak install flathub io.missioncenter.MissionCenter -y
    flatpak install flathub org.kde.kdenlive -y
    flatpak install flathub io.github.shiftey.Desktop -y
    flatpak install --noninteractive flathub io.github.realmazharhussain.GdmSettings -y
    flatpak install flathub com.flashforge.FlashPrint -y
    flatpak install flathub org.gnome.meld -y
    #flatpak install flathub com.nextcloud.desktopclient.nextcloud -y
    flatpak install flathub com.github.xournalpp.xournalpp -y
    sudo apt install ssh -y
    sudo apt install fastfetch -y
    sudo apt install w3m -y

# Install yazi
    # Ensure new cargo environment for this shell
        source "$HOME/.cargo/env"
    cargo install --force --git https://github.com/sxyazi/yazi.git yazi-build
# Install plugins
    ya pkg add dedukun/bookmarks
    ya pkg add yazi-rs/plugins:mount
    ya pkg add dedukun/relative-motions
    ya pkg add yazi-rs/plugins:chmod
    ya pkg add yazi-rs/plugins:smart-enter
    ya pkg add AnirudhG07/rich-preview
    ya pkg add grappas/wl-clipboard
    ya pkg add Rolv-Apneseth/starship
    ya pkg add yazi-rs/plugins:full-border
    ya pkg add uhs-robert/recycle-bin
    ya pkg add yazi-rs/plugins:diff

# Firewall
    sudo apt install ufw -y
    sudo ufw allow OpenSSH
    sudo ufw allow SSH
    sudo ufw enable


# Nvim Nightly & Depends
    sudo apt install cmake ninja-build gettext unzip curl build-essential -y
    git clone https://github.com/neovim/neovim.git
    cd neovim || exit
    git checkout nightly
    make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/usr/local/
    sudo make install
    cd "$builddir" || exit
    rm -rf neovim
    # Ensure /usr/local/bin is on PATH for all users
    sudo tee /etc/profile.d/local-path.sh >/dev/null <<'EOF'
export PATH="/usr/local/bin:$PATH"
EOF
    sudo chmod 644 /etc/profile.d/local-path.sh
    sudo apt install lua5.4 -y
    sudo apt install python3-pip -y
    sudo apt install chafa -y
    sudo apt install ripgrep -y

# VSCode
    wget "https://vscode.download.prss.microsoft.com/dbazure/download/stable/e170252f762678dec6ca2cc69aba1570769a5d39/code_1.88.1-1712771838_amd64.deb"
    wait
    sudo dpkg -i code_1.88.1-1712771838_amd64.deb
    wait
    rm code_1.88.1-1712771838_amd64.deb

# Synology Drive - Do not use the flatpak, it sucks
    synology_drive_version="4.0.1-17885"
    synology_drive_build="${synology_drive_version##*-}"
    synology_drive_url="https://global.download.synology.com/download/Utility/SynologyDriveClient/${synology_drive_version}/Ubuntu/Installer"
    synology_drive_pkg="synology-drive-client-${synology_drive_build}.x86_64.deb"
    wget "${synology_drive_url}/${synology_drive_pkg}"
    wait
    sudo dpkg -i "${synology_drive_pkg}"
    wait
    rm "${synology_drive_pkg}"
    sudo apt --fix-broken install -y

# Proton VPN
    wget https://repo.protonvpn.com/debian/dists/unstable/main/binary-all/protonvpn-beta-release_1.0.8_all.deb
    wait
    sudo dpkg -i ./protonvpn-beta-release_1.0.8_all.deb && sudo apt update
    sudo apt install proton-vpn-gnome-desktop -y
    rm protonvpn-beta-release_1.0.8_all.deb

# Steam & Discord
    sudo dpkg --add-architecture i386
    sudo apt update
        wget "https://steamcdn-a.akamaihd.net/client/installer/steam.deb"
        wait
        sudo dpkg -i steam.deb || sudo apt -f install -y
        wait
        rm steam.deb
    # Discord via Flatpak
    flatpak install flathub com.discordapp.Discord -y

# Ulauncher
    gpg --keyserver keyserver.ubuntu.com --recv 0xfaf1020699503176
    gpg --export 0xfaf1020699503176 | sudo tee /usr/share/keyrings/ulauncher-archive-keyring.gpg >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/ulauncher-archive-keyring.gpg] http://ppa.launchpad.net/agornostal/ulauncher/ubuntu noble main" | sudo tee /etc/apt/sources.list.d/ulauncher-noble.list
    sudo apt update -y
    sudo apt install ulauncher -y

# Ollama
    curl -fsSL https://ollama.com/install.sh | sh
    #ollama pull codellama:latest
    #ollama pull gemma3:12b
    #ollama pull gemma3n:latest

# Tailscale
    curl -fsSL https://tailscale.com/install.sh | sh
    wait

# Docker
    sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release -y
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    # Add current user to the docker group (optional)
    sudo usermod -aG docker "$USER"
    # Note: you may need to log out and back in for the group change to take effect

# Install Synology Chat from repair script
#    cd scripts || exit
#    chmod +x ./synology-chat-build-fix-install.sh
#    ./synology-chat-build-fix-install.sh
#    wait
#    cd "$builddir" || exit

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

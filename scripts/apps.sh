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
    flatpak install flathub net.waterfox.waterfox -y
    flatpak install flathub md.obsidian.Obsidian -y
    flatpak install flathub org.libreoffice.LibreOffice -y
    flatpak install https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref -y
    flatpak install flathub org.darktable.Darktable -y
    flatpak install flathub org.gnome.SimpleScan -y
    flatpak install flathub org.blender.Blender -y
    flatpak install flathub com.mattjakeman.ExtensionManager -y
    flatpak install flathub org.qbittorrent.qBittorrent -y
    flatpak install flathub io.missioncenter.MissionCenter -y
    flatpak install flathub org.kde.kdenlive -y
    flatpak install flathub io.github.shiftey.Desktop -y
    flatpak install flathub com.discordapp.Discord -y
    flatpak install --noninteractive flathub io.github.realmazharhussain.GdmSettings -y
    flatpak install flathub com.flashforge.FlashPrint -y
    flatpak install flathub com.synology.synology-note-station -y

    # Install Yazi - Rust build issues, temp usage of snap required 🤮
    sudo apt install snapd -y
    sudo snap install snapd
    sudo apt update && sudo apt upgrade -y || true
    sudo snap install yazi --candidate --classic


# Install Gnome-extensions-cli
    pipx install gnome-extensions-cli --system-site-packages

# Nvim & Depends
    sudo apt install neovim -y
    sudo apt install lua5.4 -y
    sudo apt install luarocks -y
    sudo apt install python3-pip -y
    sudo npm install -g @mermaid-js/mermaid-cli
    sudo npm install -g neovim
    python3 -m pip install --user --upgrade pynvim

# VSCode
    wget "https://vscode.download.prss.microsoft.com/dbazure/download/stable/e170252f762678dec6ca2cc69aba1570769a5d39/code_1.88.1-1712771838_amd64.deb"
    wait
    dpkg -i code_1.88.1-1712771838_amd64.deb
    wait
    rm code_1.88.1-1712771838_amd64.deb

# Synology Drive - Do not use the flatpak, it sucks
    wget "https://global.download.synology.com/download/Utility/SynologyDriveClient/3.4.0-15724/Ubuntu/Installer/synology-drive-client-15724.x86_64.deb"
    wait
    sudo dpkg -i synology-drive-client-15724.x86_64.deb
    wait
    rm synology-drive-client-15724.x86_64.deb
    sudo apt --fix-broken install -y

# Steam
    wget "https://steamcdn-a.akamaihd.net/client/installer/steam.deb"
    wait
    sudo dpkg -i steam.deb
    wait
    rm steam.deb
    # i386 is needed for steam to launch
    sudo dpkg --add-architecture i386

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

# Apply Beautiful Bash
    echo -e "${YELLOW}Installing Beautiful Bash...${NC}"
    git clone https://github.com/christitustech/mybash
        cd mybash || exit
        ./setup.sh
        wait
        cd "$builddir" || exit
        rm -rf mybash

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
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
sudo apt update && upgrade -y
wait

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
            mkdir -p /media/Working-Storage
        fi
        chown "$username":"$username" /home/"$username"/media/Working-Storage
        if [ ! -d "$HOME/.media/Archived-Storage" ]; then
            mkdir -p /media/Archived-Storage
        fi
        chown "$username":"$username" /home/"$username"/media/Archived-Storage

# Installing important things && stuff && some dependencies
echo "Installing Programs and Drivers"
sudo apt install dbus-x11 -y
sudo apt install cups -y
sudo apt install util-linux -y
sudo apt install xdg-utils -y
sudo apt install libnvidia-egl-wayland -y
sudo apt install build-essential -y
sudo apt install nautilus -y
sudo apt install gdebi -y
sudo apt install fuse -y
sudo apt install libfuse2 -y
sudo apt install x11-xserver-utils -y
sudo apt install dh-dkms -y
sudo apt install devscripts -y
sudo apt install fonts-noto-color-emoji -y
sudo apt install zip unzip gzip tar -y
sudo apt install make -y
sudo apt install linux-headers-generic -y
sudo apt install seahorse -y
sudo apt install gnome-calculator -y
sudo apt install rename -y
sudo apt install mpv -y
sudo apt install gparted -y
sudo apt install curl -y
sudo apt install gh -y
sudo apt install lua5.4 -y
sudo apt install gnome-disk-utility -y
sudo apt install papirus-icon-theme -y
sudo apt install ulauncher -y
wait
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
flatpak install flathub com.tomjwatson.Emote -y
flatpak install flathub org.kde.kdenlive -y
flatpak install flathub io.github.shiftey.Desktop -y
flatpak install flathub com.flashforge.FlashPrint -y
flatpak install flathub com.discordapp.Discord -y


# Install Gnome-extensions-cli
pipx install gnome-extensions-cli --system-site-packages

# VSCode
wget "https://vscode.download.prss.microsoft.com/dbazure/download/stable/e170252f762678dec6ca2cc69aba1570769a5d39/code_1.88.1-1712771838_amd64.deb"
wait
dpkg -i code_1.88.1-1712771838_amd64.deb
wait
rm code_1.88.1-1712771838_amd64.deb

# Synology Drive
wget "https://global.download.synology.com/download/Utility/SynologyDriveClient/3.4.0-15724/Ubuntu/Installer/synology-drive-client-15724.x86_64.deb"
wait
sudo dpkg -i synology-drive-client-15724.x86_64.deb
wait
rm synology-drive-client-15724.x86_64.deb
sudo apt --fix-broken install -y

# steam
wget "https://steamcdn-a.akamaihd.net/client/installer/steam.deb"
wait
sudo dpkg -i steam.deb
wait
rm steam.deb
# i386 is needed for steam to launch
sudo dpkg --add-architecture i386

# FlashForge
wget "https://en.fss.flashforge.com/10000/software/e02d016281d06012ea71a671d1e1fdb7.deb"
chown "$username":"$username" e02d016281d06012ea71a671d1e1fdb7.deb

# Ulauncher
gpg --keyserver keyserver.ubuntu.com --recv 0xfaf1020699503176
gpg --export 0xfaf1020699503176 | sudo tee /usr/share/keyrings/ulauncher-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/ulauncher-archive-keyring.gpg] http://ppa.launchpad.net/agornostal/ulauncher/ubuntu noble main" | sudo tee /etc/apt/sources.list.d/ulauncher-noble.list
sudo apt update -y
sudo apt install ulauncher -y

# Tailscale
    curl -fsSL https://tailscale.com/install.sh | sh

# Ollama
    curl -fsSL https://ollama.com/install.sh | sh
    #ollama pull gemma3:12b
    ollama pull gemma3n:latest
    #ollama pull codellama:latest

sudo apt update
wait
sudo apt upgrade -y
wait

echo "Installing Fonts"
# Installing fonts
cd "$builddir" || exit
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
chmod -R 777 FiraCode.zip
unzip FiraCode.zip -d /home/"$username"/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
chmod -R 777 Meslo.zip
unzip Meslo.zip -d /home/"$username"/.fonts
mv dotfonts/fontawesome/otfs/*.otf /home/"$username"/.fonts/
chown -R "$username":"$username" /home/"$username"/.fonts
rm -rf FiraCode.zip
rm -rf Meslo.zip
apt install fonts-font-awesome fonts-noto-color-emoji -y
apt install ttf-mscorefonts-installer -y
apt install fonts-terminus -y
# Reload Font
fc-cache -vf
wait

# Extensions
echo "Gnome Extensions"
sudo apt install gnome-shell-extension-appindicator -y
sudo apt install gnome-shell-extension-gsconnect -y
sudo apt install gnome-shell-extension-caffeine -y
sudo apt install gnome-shell-extension-blur-my-shell -y
sudo apt install gnome-shell-extension-tiling-assistant -y
# Super Key
# App Icons Taskbar
wget https://gitlab.com/AndrewZaech/aztaskbar/-/archive/main/aztaskbar-main.tar
chmod u+x aztaskbar-main.tar
gnome-extensions install aztaskbar-main.tar
# Useless Gaps
git clone https://github.com/mipmip/gnome-shell-extensions-useless-gaps.git
chmod -R u+x nome-shell-extensions-useless-gaps
cd gnome-shell-extensions-useless-gaps || exit
sudo ./install.sh local-install
cd "$builddir" || exit
rm -rf gnome-shell-extensions-useless-gaps
# Just Perfection
gext install just-perfection-desktop@just-perfection
git clone https://gitlab.gnome.org/jrahmatzadeh/just-perfection/-/archive/main/just-perfection-main.zip
extract just-perfection-main.zip
chmod -R u+x just-perfection-main
cd just-perfection-main || exit
./scripts/build.sh -i
cd "$builddir" || exit
rm -rf just-perfection-main
# Workspaces w/ Icons
git clone https://codeload.github.com/Favo02/workspaces-by-open-apps/zip/refs/heads/main
extract workspaces-by-open-apps-main.zip
chmod -R u+x workspaces-by-open-apps-main
cd workspaces-by-open-apps-main || exit
sudo ./install.sh local-install
cd "$builddir" || exit
rm -rf workspaces-by-open-apps-main

#Nautilus Customization
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


sudo apt update && upgrade -y
wait
sudo apt full-upgrade -y
wait
sudo apt install -f
wait
sudo dpkg --configure -a
sudo apt --fix-broken install -y
wait
sudo apt autoremove -y
sudo apt update && upgrade -y
wait
flatpak update -y

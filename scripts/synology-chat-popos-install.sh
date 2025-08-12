#!/bin/bash
# https://github.com/PiercingXX


# Checks for active network connection
if [[ -n "$(command -v nmcli)" && "$(nmcli -t -f STATE g)" != connected ]]; then
  awk '{print}' <<<"Network connectivity is required to continue."
  exit
fi


# Synology Chat
wget "https://global.synologydownload.com/download/Utility/ChatClient/1.2.2-0222/Ubuntu/x86_64/Synology%20Chat%20Client-1.2.2-0222.deb"
wait
sudo dpkg --force-all -i Synology\ Chat\ Client-1.2.2-0222.deb
wait
sudo mv /opt/Synology\ Chat /opt/SynologyChat
sudo rm /etc/alternatives/synochat
sudo ln -s /opt/SynologyChat/synochat /etc/alternatives/synochat
sudo rm /usr/share/applications/synochat.desktop
sudo touch /usr/share/applications/synochat.desktop
sudo printf "[Desktop Entry]
Name=Synology Chat
Exec="/opt/SynologyChat/synochat" %%U
Terminal=false
Type=Application
Icon=synochat
StartupWMClass=SynologyChat
Comment=Synology Chat Desktop Client
Categories=Utility;" | sudo tee -a /usr/share/applications/synochat.desktop
synochat

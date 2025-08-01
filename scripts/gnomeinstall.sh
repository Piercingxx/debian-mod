#!/bin/bash
# https://github.com/PiercingXX

username=$(id -u -n 1000)
builddir=$(pwd)


echo "Install Essentials"
sudo apt install wget gpg -y 
sudo agt install flatpak -y
sudo apt install gnome-software-plugin-flatpak -y
flatpak remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo apt update && upgrade -y
wait
sudo apt full-upgrade -y
wait
sudo apt install -f
wait
flatpak update
wait
sudo apt install gnome-shell -y
sudo apt install kitty -y
sudo apt install gnome-terminal -y
sudo apt install gnome-text-editor -y
sudo apt install dconf* -y
sudo apt install pipx -y
sudo apt install gnome-tweaks -y
sudo apt install gnome-shell-extension-manager -y
sudo apt install papirus-icon-theme -y
wait
pipx install gnome-extensions-cli --system-site-packages
pipx ensurepath


echo "Changing Graphical Login"
# Enable graphical login and change target from CLI to GUI
# First admend the .gdm3 to add Intall section
sudo rm /lib/systemd/system/gdm3.service && sudo touch /lib/systemd/system/gdm3.service && sudo chmod +rwx /lib/systemd/system/gdm3.service && sudo printf "[Unit]
Description=GNOME Display Manager

# replaces the getty
Conflicts=getty@tty1.service
After=getty@tty1.service

# replaces plymouth-quit since it quits plymouth on its own
Conflicts=plymouth-quit.service
After=plymouth-quit.service

# Needs all the dependencies of the services it's replacing
# pulled from getty@.service and plymouth-quit.service
# (except for plymouth-quit-wait.service since it waits until
# plymouth is quit, which we do)
After=rc-local.service plymouth-start.service systemd-user-sessions.service

# GDM takes responsibility for stopping plymouth, so if it fails
# for any reason, make sure plymouth still stops
OnFailure=plymouth-quit.service

[Service]
ExecStartPre=/usr/share/gdm/generate-config
ExecStart=/usr/sbin/gdm3
KillMode=mixed
Restart=always
RestartSec=1s
IgnoreSIGPIPE=no
BusName=org.gnome.DisplayManager
EnvironmentFile=-/etc/default/locale
ExecReload=/usr/share/gdm/generate-config
ExecReload=/bin/kill -SIGHUP $MAINPID
KeyringMode=shared

[Install]
WantedBy=multi-user.target" | sudo tee -a /lib/systemd/system/gdm3.service


# And then the .gdm to add Intall section
sudo rm /lib/systemd/system/gdm.service && sudo touch /lib/systemd/system/gdm.service && sudo chmod +rwx /lib/systemd/system/gdm.service && sudo printf "[Unit]
Description=GNOME Display Manager

# replaces the getty
Conflicts=getty@tty1.service
After=getty@tty1.service

# replaces plymouth-quit since it quits plymouth on its own
Conflicts=plymouth-quit.service
After=plymouth-quit.service

# Needs all the dependencies of the services it's replacing
# pulled from getty@.service and plymouth-quit.service
# (except for plymouth-quit-wait.service since it waits until
# plymouth is quit, which we do)
After=rc-local.service plymouth-start.service systemd-user-sessions.service

# GDM takes responsibility for stopping plymouth, so if it fails
# for any reason, make sure plymouth still stops
OnFailure=plymouth-quit.service

[Service]
ExecStartPre=/usr/share/gdm/generate-config
ExecStart=/usr/sbin/gdm3
KillMode=mixed
Restart=always
RestartSec=1s
IgnoreSIGPIPE=no
BusName=org.gnome.DisplayManager
EnvironmentFile=-/etc/default/locale
ExecReload=/usr/share/gdm/generate-config
ExecReload=/bin/kill -SIGHUP $MAINPID
KeyringMode=shared

[Install]
WantedBy=multi-user.target" | sudo tee -a /lib/systemd/system/gdm.service



echo "Hello Handsome"
# Edit Graphical Login Settings
sudo rm /etc/gdm3/greeter.dconf-defaults && sudo touch /etc/gdm3/greeter.dconf-defaults && sudo chmod +rwx /etc/gdm3/greeter.dconf-defaults && sudo printf "# These are the options for the greeter session that can be set 
# through GSettings. Any GSettings setting that is used by the 
# greeter session can be set here.

# Note that you must configure the path used by dconf to store the 
# configuration, not the GSettings path.


# Theming options
# ===============
#  - Change the GTK+ theme
[org/gnome/desktop/interface]
# gtk-theme='Adwaita'
#  - Use another background
[org/gnome/desktop/background]
# picture-uri='file:///usr/share/themes/Adwaita/backgrounds/stripes.jpg'
# picture-options='zoom'
#  - Or no background at all
[org/gnome/desktop/background]
# picture-options='none'
# primary-color='#000000'

# Login manager options
# =====================
[org/gnome/login-screen]
# logo='/usr/share/images/vendor-logos/logo-text-version-64.png'

# - Disable user list
# disable-user-list=true
# - Disable restart buttons
# disable-restart-buttons=true
# - Show a login welcome message
banner-message-enable=true
banner-message-text='Hello Handsome'

# Automatic suspend
# =================
[org/gnome/settings-daemon/plugins/power]
# - Time inactive in seconds before suspending with AC power
#   1200=20 minutes, 0=never
sleep-inactive-ac-timeout=0
# - What to do after sleep-inactive-ac-timeout
#   'blank', 'suspend', 'shutdown', 'hibernate', 'interactive' or 'nothing'
sleep-inactive-ac-type='suspend'
# - As above but when on battery
sleep-inactive-battery-timeout=1200
sleep-inactive-battery-type='suspend'
#" | sudo tee -a /etc/gdm3/greeter.dconf-defaults


# Finalizing graphical login
systemctl enable gdm
systemctl enable gdm3 --now


sudo apt update && upgrade -y
wait
flatpak update -y
wait
sudo apt full-upgrade -y
wait
sudo apt install -f
dpkg --configure -a

#!/bin/bash
# GitHub.com/PiercingXX

# Define colors for whiptail

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to cache sudo credentials
cache_sudo_credentials() {
    echo "Caching sudo credentials for script execution..."
    sudo -v
    # Keep sudo credentials fresh for the duration of the script
    (while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &)
}

# Checks for active network connection
if [[ -n "$(command -v nmcli)" && "$(nmcli -t -f STATE g)" != connected ]]; then
    awk '{print}' <<<"Network connectivity is required to continue."
    exit
fi

# Install required tools for TUI
if ! command -v whiptail &> /dev/null; then
    echo -e "${YELLOW}Installing whiptail...${NC}"
    apt install whiptail -y
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Cache sudo credentials
cache_sudo_credentials

# Function to display a message box
function msg_box() {
    whiptail --msgbox "$1" 0 0 0
}

# Function to display menu
function menu() {
    whiptail --backtitle "GitHub.com/PiercingXX" --title "Main Menu" \
        --menu "Run Options In Order:" 0 0 0 \
        "Step 1"                                "Update System & Depends for Step 2" \
        "Step 2"                                "Install Gnome & Depends & Apps" \
        "Optional Nvidia Drivers"               "Do not install if on Surface kernal" \
        "Optional Surface Kernel"               "Microsoft Surface Kernal" \
        "Hyprland"                              "**Currently Broken** Install Hyprland & All Dependencies" \
        "Reboot System"                         "Reboot the system" \
        "Exit"                                  "Exit the script" 3>&1 1>&2 2>&3
}
# Main menu loop
while true; do
    clear
    echo -e "${GREEN}Welcome ${username}${NC}\n"
    choice=$(menu)
    case $choice in
        "Step 1")
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
            echo -e "${YELLOW}Updating System...${NC}"
            # Check if nala is installed
                if ! command_exists nala; then
                echo "nala is not installed. Installing now..."
                # Install nala using apt
                sudo apt install nala -y
                fi
            wait
            # Check if flatpak is installed and update it
                if command_exists flatpak; then
                    echo "Updating flatpak packages..."
                    flatpak update -y
                else
                    echo "Flatpak is not installed."
                    sudo apt install flatpak -y
                    sudo apt install gnome-software-plugin-flatpak -y
                    flatpak remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo
                    flatpak update
                fi
            wait
            echo -e "${GREEN}System Updated Successfully!${NC}"
            # Copy debian-maintenance.sh to home directory
                cd scripts || exit
                cp -f debian-maintenance.sh /home/"$username"
                chown "$username":"$username" /home/"$username"/debian-maintenance.sh
                cd "$builddir" || exit
            msg_box "System will reboot now. Re-run the script after reboot to continue."
            sudo reboot
            ;;
        "Step 2")
            # Install Gnome and Dependencies
                echo -e "${YELLOW}Installing Gnome...${NC}"
                    cd scripts || exit
                    chmod u+x gnomeinstall.sh
                    sudo ./gnomeinstall.sh
                    cd "$builddir" || exit
                echo -e "${GREEN}Gnome Installed Successfully!${NC}"
            # Install Apps
                echo -e "${YELLOW}Installing Core Applications...${NC}"
                    cd scripts || exit
                    chmod u+x apps.sh
                    sudo ./apps.sh
                    cd "$builddir" || exit
                echo -e "${GREEN}Core Apps Installed successfully!${NC}"
            # Apply Piercing Rice
                echo -e "${YELLOW}Downloading and Applying PiercingXX Rice...${NC}"
                # .config Dot Files
                echo -e "${YELLOW}Downloading PiercingXX Dot Files...${NC}"
                    git clone https://github.com/Piercingxx/piercing-dots.git
                        chmod -R u+x piercing-dots
                        chown -R "$username":"$username" piercing-dots
                        cd piercing-dots || exit
                        cp -Rf dots/* /home/"$username"/.config/
                        chown "$username":"$username" -R /home/"$username"/.config/*
                        cd "$builddir" || exit      
                    echo -e "${GREEN}PiercingXX Dot Files Applied Successfully!${NC}"
                # Piercings Gnome Customizations
                    echo -e "${YELLOW}Applying PiercingXX Gnome Customizations...${NC}"
                        cd piercing-dots || exit
                        cd scripts || exit
                        ./gnome-customizations.sh
                        wait
                        cd "$builddir" || exit
                # Add in backgrounds and themes and apply them
                    mkdir -p /home/"$username"/Pictures/backgrounds
                    chown -R "$username":"$username" /home/"$username"/Pictures/backgrounds
                    cp -Rf piercing-dots/backgrounds/* /home/"$username"/Pictures/backgrounds
                    chown -R "$username":"$username" /home/"$username"/Pictures/backgrounds
                    mkdir -p /home/"$username"/Pictures/profile-image
                    chown -R "$username":"$username" /home/"$username"/Pictures/profile-image
                    cp -Rf piercing-dots/profile-image/* /home/"$username"/Pictures/profile-image
                    chown -R "$username":"$username" /home/"$username"/Pictures/profile-images
                    cd "$builddir" || exit
                # Copy Refs to Download folder
                    mkdir -p /home/"$username"/Downloads/refs
                    chown -R "$username":"$username" /home/"$username"/Downloads/refs
                    cp -Rf piercing-dots/refs/* /home/"$username"/Downloads/refs
                    chown -R "$username":"$username" /home/"$username"/Downloads/refs
                    rm -Rf piercing-dots
                # Apply Gimp Dots
                    echo -e "${YELLOW}Installing Piercing Gimp Presets...${NC}"
                    rm -rf gimp-dots
                    if git clone https://github.com/Piercingxx/gimp-dots.git; then
                        chmod -R u+x gimp-dots
                        chown -R "$username":"$username" gimp-dots
                        cd ./gimp-dots || exit
                        ./gimp-mod.sh
                        cd "$builddir" || exit
                        rm -Rf gimp-dots
                        echo -e "${GREEN}Piercing Gimp Presets Installed Successfully!${NC}"
                    else
                        echo -e "${RED}Failed to clone gimp-dots repository${NC}"
                    fi
                # Apply Beautiful Bash
                    echo -e "${YELLOW}Installing Beautiful Bash...${NC}"
                    git clone https://github.com/christitustech/mybash
                        chmod -R u+x mybash
                        chown -R "$username":"$username" mybash
                        cd mybash || exit
                        ./setup.sh
                        wait
                        cd "$builddir" || exit
                        rm -rf mybash
                echo -e "${GREEN}PiercingXX Rice Applied Successfully!${NC}"
            msg_box "System will reboot now. Re-run the script after reboot to continue."
            sudo reboot
            ;;
        "Optional Nvidia Drivers")
            echo -e "${YELLOW}Nvidia Drivers...${NC}"            
                cd scripts || exit
                chmod u+x nvidia.sh
                sudo ./nvidia.sh
                cd "$builddir" || exit
            ;;
        "Optional Surface Kernel")
            echo -e "${YELLOW}Microsoft Surface Kernel...${NC}"            
                cd scripts || exit
                chmod u+x Surface.sh
                sudo ./Surface.sh
                cd "$builddir" || exit
            ;;
        "Cosmic"*)
            echo -e "${YELLOW}Installing Cosmic & Dependencies...${NC}"
                cd scripts || exit
                chmod u+x cosmic-install.sh
                ./cosmic-install.sh
                cd "$builddir" || exit
            echo -e "${GREEN}Installed successfully!${NC}"
            ;;
        "Hyprland"*)
            echo -e "${YELLOW}Installing Hyprland & Dependencies...${NC}"
                cd scripts || exit
                chmod u+x hyprland-install.sh
                ./hyprland-install.sh
                cd "$builddir" || exit
            echo -e "${GREEN}Installed successfully!${NC}"
            ;;
        "Reboot System")
            echo -e "${YELLOW}Rebooting system in 3 seconds...${NC}"
            sleep 1
            sudo reboot
            ;;
        "Exit")
            clear
            echo -e "${BLUE}Thank You Handsome!${NC}"
            exit 0
            ;;
    esac
    # Prompt to continue
    while true; do
        read -p "Press [Enter] to continue..." 
        break
    done
done

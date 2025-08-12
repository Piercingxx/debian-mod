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
        "Step 1"                                "Update System & Dependencies " \
        "Step 2"                                "Install Apps & Stuff" \
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
            echo -e "${YELLOW}Updating System...${NC}"
            # Install Gnome and Dependencies
                    cd scripts || exit
                    chmod u+x step-1.sh
                    sudo ./step-1.sh
                    wait
                    cd "$builddir" || exit
            # Copy maintenance-debian.sh to home directory
                cd scripts || exit
                cp -f maintenance-debian.sh /home/"$username"
                chown "$username":"$username" /home/"$username"/maintenance-debian.sh
                cd "$builddir" || exit
            # Apply Piercing Rice
                # .config Dot Files
                    git clone https://github.com/Piercingxx/piercing-dots.git
                        chmod -R u+x piercing-dots
                        chown -R "$username":"$username" piercing-dots
                        cd piercing-dots || exit
                        cp -Rf dots/* /home/"$username"/.config/
                        chown "$username":"$username" -R /home/"$username"/.config/*
                        cd "$builddir" || exit
                # Piercings Gnome Customizations
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
                # Apply Gimp Dots
                    rm -rf gimp-dots
                    if git clone https://github.com/Piercingxx/gimp-dots.git; then
                        chmod -R u+x gimp-dots
                        chown -R "$username":"$username" gimp-dots
                        cd ./gimp-dots || exit
                        ./gimp-mod.sh
                        wait
                        cd "$builddir" || exit
                        rm -Rf gimp-dotsD
                    else
                        echo -e "${RED}Failed to clone gimp-dots repository${NC}"
                    fi
            msg_box "System will reboot now. Re-run the script after reboot to continue."
            sudo reboot
            ;;
        "Step 2")
            # Install Apps
                    cd scripts || exit
                    chmod u+x apps.sh
                    sudo ./apps.sh
                    wait
                    cd "$builddir" || exit
            # Apply Piercing Rice
                # .config Dot Files
                    git clone https://github.com/Piercingxx/piercing-dots.git
                        chmod -R u+x piercing-dots
                        chown -R "$username":"$username" piercing-dots
                        cd piercing-dots || exit
                        cp -Rf dots/* /home/"$username"/.config/
                        chown "$username":"$username" -R /home/"$username"/.config/*
                        cd "$builddir" || exit
                # Piercings Gnome Customizations
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
                # Apply Gimp Dots
                    rm -rf gimp-dots
                    if git clone https://github.com/Piercingxx/gimp-dots.git; then
                        chmod -R u+x gimp-dots
                        chown -R "$username":"$username" gimp-dots
                        cd ./gimp-dots || exit
                        ./gimp-mod.sh
                        wait
                        cd "$builddir" || exit
                        rm -Rf gimp-dotsD
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
                # Replace .bashrc
                    cp -Rf piercing-dots/bash/.bashrc /home/"$username"/
                    chown -R "$username":"$username" /home/"$username"/.bashrc
                    rm -Rf piercing-dots
                echo -e "${GREEN}PiercingXX Rice Applied Successfully!${NC}"
            msg_box "System will reboot now. Re-run the script after reboot to continue."
            sudo reboot
            ;;
        "Optional Surface Kernel")
            echo -e "${YELLOW}Microsoft Surface Kernel...${NC}"            
                cd scripts || exit
                chmod u+x Surface.sh
                sudo ./Surface.sh
                cd "$builddir" || exit
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


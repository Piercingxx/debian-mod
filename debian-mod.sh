#!/bin/bash
# GitHub.com/PiercingXX

# Define colors for whiptail

# Function to check if a command exists
    command_exists() {
        command -v "$1" >/dev/null 2>&1
    }

# Cache sudo credentials
    cache_sudo_credentials() {
        echo "Caching sudo credentials for script execution..."
        sudo -v
        # Keep sudo credentials fresh for the duration of the script
        (while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &)
    }

# Check for active network connection
    if command_exists nmcli; then
        state=$(nmcli -t -f STATE g)
        if [[ "$state" != connected ]]; then
            echo "Network connectivity is required to continue."
            exit 1
        fi
    else
        # Fallback: ensure at least one interface has an IPv4 address
        if ! ip -4 addr show | grep -q "inet "; then
            echo "Network connectivity is required to continue."
            exit 1
        fi
    fi
        # Additional ping test to confirm internet reachability
        if ! ping -c 1 -W 1 8.8.8.8 >/dev/null 2>&1; then
            echo "Network connectivity is required to continue."
            exit 1
        fi


# Install required tools for TUI
    if ! command -v whiptail &> /dev/null; then
        echo -e "${YELLOW}Installing whiptail...${NC}"
        apt install whiptail -y
    fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Function to display a message box
function msg_box() {
    whiptail --msgbox "$1" 0 0 0
}

# Function to display menu
function menu() {
    whiptail --backtitle "GitHub.com/PiercingXX" --title "Main Menu" \
        --menu "Run Options In Order:" 0 0 0 \
        "Install"                               "Install PiercingXX Debian" \
        "Nvidia Driver"                         "Install Nvidia Drivers (Do not install on a Surface Device)" \
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
        "Install")
            echo -e "${YELLOW}Updating System...${NC}"
            # Turn off sleep/suspend to avoid interruptions
                gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'false'
                gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'false'
                gsettings set org.gnome.settings-daemon.plugins.power idle-dim 'false'
            # Install Gnome and Dependencies
                cd scripts || exit
                chmod u+x step-1.sh
                sudo ./step-1.sh
                wait
                cd "$builddir" || exit
            # Apply Piercing Rice
                echo -e "${YELLOW}Applying PiercingXX Gnome Customizations...${NC}"
                rm -rf piercing-dots
                git clone --depth 1 https://github.com/Piercingxx/piercing-dots.git
                cd piercing-dots || exit
                chmod u+x install.sh
                ./install.sh
                wait
                cd "$builddir" || exit
            # Install Apps & Dependencies
                echo -e "${YELLOW}Installing Apps & Dependencies...${NC}"
                cd scripts || exit
                chmod u+x apps.sh
                sudo ./apps.sh
                wait
                cd "$builddir" || exit
            # Apply Piercing Gnome Customizations as User
                cd piercing-dots/scripts || exit
                ./gnome-customizations.sh
                wait
                cd "$builddir" || exit
            # Replace .bashrc
                cp -f piercing-dots/resources/bash/.bashrc /home/"$username"/.bashrc
                source ~/.bashrc
            # Clean Up
                rm -rf piercing-dots
            echo -e "${GREEN}PiercingXX Gnome Customizations Applied successfully!${NC}"
            msg_box "System will reboot now."
            sudo reboot
            ;;
        "Nvidia Driver")
            echo -e "${YELLOW}Installing Nvidia Drivers...${NC}"
            # Install Nvidia Drivers
                cd scripts || exit
                chmod u+x nvidia.sh
                sudo ./nvidia.sh
                wait
                cd "$builddir" || exit
            echo -e "${GREEN}Nvidia Drivers Installed Successfully!${NC}"
            msg_box "Nvidia Drivers installed successfully. Reboot the system to apply changes."
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


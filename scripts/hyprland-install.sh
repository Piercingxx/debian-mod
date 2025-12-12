#!/bin/bash
# https://github.com/piercingxx

username=$(id -u -n 1000)
builddir=$(pwd)

# Update
    # Detect distribution
        if [ -f /etc/os-release ]; then
            . /etc/os-release
        fi
    # Only add-apt-repository universe if on Ubuntu
        if [[ "$ID" == "ubuntu" ]]; then
            sudo add-apt-repository universe -y
        fi
    sudo apt update
    sudo apt upgrade -y

# Install all APT dependencies (tools, libraries, and build dependencies)
    sudo apt install libsdbus-c++-dev -y
    sudo apt install libpam0g-dev -y
    sudo apt install libgbm-dev -y
    sudo apt install libdrm-dev -y
    sudo apt install libmagic-dev -y
    sudo apt install rofi -y
    sudo apt install fuzzel -y
    sudo apt install waybar -y
    sudo apt install wayland-protocols -y
    sudo apt install wl-clipboard -y
    sudo apt install wlogout -y
    sudo apt install pavucontrol -y
    sudo apt install grim -y
    sudo apt install slurp -y
    sudo apt install cliphist -y
    sudo apt install easyeffects -y
    sudo apt install network-manager-applet -y
    sudo apt install bluez -y
    sudo apt install blueman -y
    sudo apt install polkit-kde-agent-1 -y
    sudo apt install libpixman-1-dev -y
    sudo apt install libpugixml-dev -y
    sudo apt install libjpeg-dev -y
    sudo apt install libwebp-dev -y
    sudo apt install librsvg2-dev -y
    sudo apt install libgles2-mesa-dev -y
    sudo apt install libgles-dev -y
    sudo apt install libseat-dev -y
    sudo apt install libinput-dev -y
    sudo apt install libudev-dev -y
    sudo apt install libdisplay-info-dev -y
    sudo apt install hwdata -y
    sudo apt install libzip-dev -y
    sudo apt install libtomlplusplus-dev -y
    sudo apt install libxkbcommon-dev -y
    sudo apt install libxcursor-dev -y
    sudo apt install libre2-dev -y
    sudo apt install libxcb-xfixes0-dev -y
    sudo apt install libxcb-icccm4-dev -y
    sudo apt install libxcb-composite0-dev -y
    sudo apt install libxcb-res0-dev -y
    sudo apt install libxcb-errors-dev -y

# Build hyprutils from source (required by Hyprland)
    printf "${NOTE} Building and installing hyprutils v0.11.0...\n"
    rm -rf hyprutils 2>/dev/null || true
    if git clone --depth 1 --recursive -b v0.11.0 https://github.com/hyprwm/hyprutils.git; then
        cd hyprutils || exit 1
        cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
        cmake --build ./build --config Release -j"$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"
        if sudo cmake --install build >/dev/null 2>&1; then
            printf "${OK} hyprutils installed successfully.\n"
        else
            echo -e "${ERROR} Installation failed for hyprutils."
            exit 1
        fi
        cd ..
    else
        echo -e "${ERROR} Download failed for hyprutils."
        exit 1
    fi

# Build hyprlang from source (required by Hyprland)
    printf "${NOTE} Building and installing hyprlang v0.6.7...\n"
    rm -rf hyprlang 2>/dev/null || true
    if git clone --depth 1 --recursive -b v0.6.7 https://github.com/hyprwm/hyprlang.git; then
        cd hyprlang || exit 1
        cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
        cmake --build ./build --config Release -j"$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"
        if sudo cmake --install build >/dev/null 2>&1; then
            printf "${OK} hyprlang installed successfully.\n"
        else
            echo -e "${ERROR} Installation failed for hyprlang."
            exit 1
        fi
        cd ..
    else
        echo -e "${ERROR} Download failed for hyprlang."
        exit 1
    fi

# Build hyprland-protocols from source (required by Hyprland)
    printf "${NOTE} Installing hyprland-protocols v0.7.0...\n"
    rm -rf hyprland-protocols 2>/dev/null || true
    if git clone --depth 1 --recursive -b v0.7.0 https://github.com/hyprwm/hyprland-protocols.git; then
        cd hyprland-protocols || exit 1
        sudo mkdir -p /usr/share/wayland-protocols
        sudo cp -r protocols/* /usr/share/wayland-protocols/ 2>/dev/null || true
        printf "${OK} hyprland-protocols installed successfully.\n"
        cd ..
    else
        echo -e "${ERROR} Download failed for hyprland-protocols."
        exit 1
    fi

# Build hyprwayland-scanner from source (required by Hyprland)
    printf "${NOTE} Building and installing hyprwayland-scanner v0.4.5...\n"
    rm -rf hyprwayland-scanner 2>/dev/null || true
    if git clone --depth 1 --recursive -b v0.4.5 https://github.com/hyprwm/hyprwayland-scanner.git; then
        cd hyprwayland-scanner || exit 1
        cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
        cmake --build ./build --config Release -j"$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"
        if sudo cmake --install build >/dev/null 2>&1; then
            printf "${OK} hyprwayland-scanner installed successfully.\n"
        else
            echo -e "${ERROR} Installation failed for hyprwayland-scanner."
            exit 1
        fi
        cd ..
    else
        echo -e "${ERROR} Download failed for hyprwayland-scanner."
        exit 1
    fi

# Clone and build hyprlock
    printf "${NOTE} Installing hyprlock...\n"
    lock_tag="v0.5.1"  # Set a specific version
    rm -rf hyprlock 2>/dev/null || true
    if git clone --depth 1 --recursive -b $lock_tag https://github.com/hyprwm/hyprlock.git 2>/dev/null; then
        cd hyprlock || exit 1
        cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
        cmake --build ./build --config Release -j"$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" 2>/dev/null
        if sudo cmake --install build >/dev/null 2>&1; then
            printf "${OK} hyprlock installed successfully.\n"
        else
            printf "${INFO} hyprlock installation skipped (optional).\n"
        fi
        cd ..
    else
        printf "${INFO} hyprlock clone failed (optional, continuing).\n"
    fi

# hypridle (idle/suspend daemon)
    printf "${NOTE} Installing hypridle...\n"
    idle_tag="v0.3.1"  # Set a specific version
    rm -rf hypridle 2>/dev/null || true
    if git clone --depth 1 --recursive -b $idle_tag https://github.com/hyprwm/hypridle.git 2>/dev/null; then
        cd hypridle || exit 1
        cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
        cmake --build ./build --config Release -j"$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" 2>/dev/null
        if sudo cmake --install ./build >/dev/null 2>&1; then
            printf "${OK} hypridle installed successfully.\n"
        else
            printf "${INFO} hypridle installation skipped (optional).\n"
        fi
        cd ..
    else
        printf "${INFO} hypridle clone failed (optional, continuing).\n"
    fi

# Build hyprgraphics
    printf "${NOTE} Building and installing hyprgraphics...\n"
    rm -rf hyprgraphics 2>/dev/null || true
    if git clone --depth 1 --recursive https://github.com/hyprwm/hyprgraphics.git; then
        cd hyprgraphics || exit 1
        cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
        cmake --build ./build --config Release -j"$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"
        if sudo cmake --install build >/dev/null 2>&1; then
            printf "${OK} hyprgraphics installed successfully.\n"
        else
            echo -e "${ERROR} Installation failed for hyprgraphics."
            exit 1
        fi
        cd ..
    else
        echo -e "${ERROR} Download failed for hyprgraphics."
        exit 1
    fi

# Build hyprpaper from source (now that hyprgraphics is available)
    printf "${NOTE} Building and installing hyprpaper v0.7.6...\n"
    rm -rf hyprpaper 2>/dev/null || true
    if git clone --depth 1 --recursive -b v0.7.6 https://github.com/hyprwm/hyprpaper.git; then
        cd hyprpaper || exit 1
        cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
        cmake --build ./build --config Release -j"$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"
        if sudo cmake --install build >/dev/null 2>&1; then
            printf "${OK} hyprpaper installed successfully.\n"
        else
            printf "${INFO} hyprpaper installation failed (non-critical, continuing).\n"
        fi
        cd ..
    else
        printf "${INFO} hyprpaper download failed (non-critical, continuing).\n"
    fi

# Build aquamarine
    printf "${NOTE} Building and installing aquamarine...\n"
    rm -rf aquamarine 2>/dev/null || true
    if git clone --depth 1 --recursive https://github.com/hyprwm/aquamarine.git; then
        cd aquamarine || exit 1
        cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
        cmake --build ./build --config Release -j"$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"
        if sudo cmake --install build >/dev/null 2>&1; then
            printf "${OK} aquamarine installed successfully.\n"
        else
            echo -e "${ERROR} Installation failed for aquamarine."
            exit 1
        fi
        cd ..
    else
        echo -e "${ERROR} Download failed for aquamarine."
        exit 1
    fi

# Build hyprcursor
    printf "${NOTE} Building and installing hyprcursor...\n"
    rm -rf hyprcursor 2>/dev/null || true
    if git clone --depth 1 --recursive https://github.com/hyprwm/hyprcursor.git; then
        cd hyprcursor || exit 1
        cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
        cmake --build ./build --config Release -j"$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"
        if sudo cmake --install build >/dev/null 2>&1; then
            printf "${OK} hyprcursor installed successfully.\n"
        else
            echo -e "${ERROR} Installation failed for hyprcursor."
            exit 1
        fi
        cd ..
    else
        echo -e "${ERROR} Download failed for hyprcursor."
        exit 1
    fi

# Build Hyprland
    printf "${NOTE} Building and installing Hyprland v0.43.0...\n"
    rm -rf Hyprland 2>/dev/null || true
    if git clone --depth 1 --recursive -b v0.43.0 https://github.com/hyprwm/Hyprland.git; then
        cd Hyprland || exit 1
        cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
        cmake --build ./build --config Release -j"$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)"
        if sudo cmake --install build >/dev/null 2>&1; then
            printf "${OK} Hyprland installed successfully!\n"
        else
            echo -e "${ERROR} Installation failed for Hyprland."
            exit 1
        fi
        cd ..
    else
        echo -e "${ERROR} Download failed for Hyprland."
        exit 1
    fi

printf "\n${OK} ============================================\n"
printf "${OK} Hyprland installation completed successfully!\n"
printf "${OK} ============================================\n"

exit 0

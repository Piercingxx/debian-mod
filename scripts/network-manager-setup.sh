#!/bin/bash
# GitHub.com/PiercingXX

set -euo pipefail

disable_if_exists() {
    local unit="$1"

    if systemctl list-unit-files --type=service --all 2>/dev/null | awk '{print $1}' | grep -qx "$unit"; then
        sudo systemctl disable --now "$unit" >/dev/null 2>&1 || true
    fi
}

enforce_networkmanager_systemd() {
    echo "Standardizing network stack to NetworkManager (systemd)..."

    disable_if_exists iwd.service
    disable_if_exists connman.service
    disable_if_exists systemd-networkd.service
    disable_if_exists dhcpcd.service
    disable_if_exists wpa_supplicant.service

    sudo mkdir -p /etc/NetworkManager/conf.d
    sudo tee /etc/NetworkManager/conf.d/10-wifi-powersave-off.conf >/dev/null <<'EOF'
[connection]
wifi.powersave=2
EOF

    sudo systemctl enable --now NetworkManager.service
}

enforce_networkmanager_systemd
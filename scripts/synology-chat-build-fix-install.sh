#!/usr/bin/env bash
set -Eeuo pipefail

# Config
VERSION="1.2.3-0232"
BASE_URL="https://global.synologydownload.com/download/Utility/ChatClient/${VERSION}/Ubuntu/x86_64"
DEB_URL="${BASE_URL}/Synology%20Chat%20Client-${VERSION}.deb"
LOCAL_DEB="synology-chat-client_${VERSION}_amd64.deb"

# Privilege helper for installations
if [ "$(id -u)" -eq 0 ]; then SUDO=""; else SUDO="sudo"; fi
export DEBIAN_FRONTEND=noninteractive

# If not root, require sudo to be available
if [ -n "$SUDO" ] && ! command -v sudo >/dev/null 2>&1; then
    echo "sudo is required or run this script as root." >&2
    exit 1
fi

# Require tools (auto-install if missing)
APT_UPDATED=0
ensure_tool() {
    local cmd="$1" pkg="$2"
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "$cmd not found; attempting to install package '$pkg'..." >&2
        if command -v apt-get >/dev/null 2>&1; then
            if [ "$APT_UPDATED" -eq 0 ]; then
                $SUDO apt-get update -y
                APT_UPDATED=1
            fi
            $SUDO apt-get install -y "$pkg"
        else
            echo "No supported package manager found; please install '$pkg' manually." >&2
            exit 1
        fi
    fi
}

ensure_tool wget wget
ensure_tool dpkg-deb dpkg

# Require network
if ! wget --spider -q "$BASE_URL/"; then
    echo "Network connectivity is required to continue." >&2
    exit 1
fi

# Download with a known filename
wget -q --show-progress -O "$LOCAL_DEB" "$DEB_URL"

# Work dir
EXTRACT_DIR="$(mktemp -d)"
cleanup() { rm -rf "$EXTRACT_DIR" "$LOCAL_DEB" 2>/dev/null || true; }
trap cleanup EXIT

# Extract
dpkg-deb -R "$LOCAL_DEB" "$EXTRACT_DIR"

# Compute Installed-Size (KB) for data (exclude DEBIAN)
SIZE_KB="$(du -sk "$EXTRACT_DIR"/* | awk '$2 !~ /DEBIAN$/ {sum+=$1} END{print sum+0}')"

# Rewrite control (Description continuation lines must start with a single space)
tee "$EXTRACT_DIR/DEBIAN/control" >/dev/null <<EOF
Package: synology-chat-client
Version: ${VERSION}
Architecture: amd64
Maintainer: Synology <support@synology.com>
Depends: gnome-screenshot, gir1.2-ayatanaappindicator3-0.1
Recommends: libayatana-appindicator3-1
Section: net
Priority: optional
Homepage: https://www.synology.com
Installed-Size: ${SIZE_KB}
Description: Synology Chat Desktop Client
 A desktop client for Synology Chat.
EOF

# Rebuild and install the fixed package
FIXED_DEB="chat-client-fixed_${VERSION}_amd64.deb"
dpkg-deb --build --root-owner-group "$EXTRACT_DIR" "$FIXED_DEB"

# Install the fixed package
if [ "$APT_UPDATED" -eq 0 ]; then
    $SUDO apt-get update -y
fi
$SUDO apt-get install -y "./$FIXED_DEB"

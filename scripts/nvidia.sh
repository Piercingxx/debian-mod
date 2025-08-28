#!/usr/bin/env bash
# Install Nvidia drivers and CUDA on Debian 13
# https://github.com/piercingxx

set -euo pipefail

# Verify we are running as root
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root." >&2
	exit 1
fi

echo "Installing Nvidia drivers and CUDA..."

# Update package lists
apt update

# Install the latest LTS driver (535 at the time of writing)
apt install -y \
	nvidia-driver-535 \
	nvidia-dkms-535 \
	nvidia-settings \
	nvidia-utils-535

# Install CUDA 13.0 toolkit
CUDA_REPO_PKG="cuda-repo-debian13-13-0-local_13.0.0-580.65.06-1_amd64.deb"

# Download the CUDA repository package
wget https://developer.download.nvidia.com/compute/cuda/13.0.0/local_installers/${CUDA_REPO_PKG}

# Install the package
dpkg -i ${CUDA_REPO_PKG}

# Copy the keyring for the CUDA repository
cp /var/cuda-repo-debian13-13-0-local/cuda-*-keyring.gpg /usr/share/keyrings/

# Update apt cache again and install the toolkit
apt update
apt install -y cuda-toolkit-13-0

# Install 32‑bit libraries for Steam (if you use Steam)
apt install -y libgl1-nvidia-glvnd-glx:i386

# Clean up
rm -f ${CUDA_REPO_PKG}
apt autoremove -y

echo "Rebooting to apply changes..."
reboot
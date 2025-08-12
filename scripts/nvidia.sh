#!/bin/bash
# https://github.com/PiercingXX

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo su then try again" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)


echo "Installing Nvidia Drivers, be patient this will take a while"


# Video card drivers
  wget https://developer.download.nvidia.com/compute/cuda/12.3.1/local_installers/cuda-repo-debian12-12-3-local_12.3.1-545.23.08-1_amd64.deb
  dpkg -i cuda-repo-debian12-12-3-local_12.3.1-545.23.08-1_amd64.deb
  wait
  cp /var/cuda-repo-debian12-12-3-local/cuda-*-keyring.gpg /usr/share/keyrings/
  apt update && upgrade -y
  wait
  sudo apt install nvidia-kernel-open-dkms nvidia-driver nvidia-opencl-icd linux-headers-amd64 libnvidia-gl-535 libvulkan1 libvulkan1:i386 libnvidia-gl-535:i386 firmware-misc-nonfree nvidia-installer-cleanup -y
  apt update && upgrade -y
  wait
  sudo apt install cuda-toolkit-12-3 cuda-drivers nvidia-kernel-open-dkms -y
  flatpak install flathub org.freedesktop.Platform.GL.nvidia-545-29-06 -y

# necessary for steam
  sudo apt install libgl1-nvidia-glvnd-glx:i386 -y
  rm cuda-repo-debian12-12-3-local_12.3.1-545.23.08-1_amd64.deb
  apt update && upgrade -y 
  wait
sudo reboot

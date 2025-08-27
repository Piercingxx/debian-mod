# Debian‑mod

Automates the installation of a fully‑featured Debian workstation, including optional GPU drivers, Mircosoft Surface support, Hyprland, and a curated set of developer tools.

> **NOTE** – This repository is tailored for Debian Trixie Stable.  
> If you are using a different Debian release, some scripts may need adjustments.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Optional Scripts](#optional-scripts)
4. [Hardware‑Specific Notes](#hardware‑specific-notes)
5. [Post‑Installation](#post‑installation)
6. [Credits](#credits)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

1. A fresh Debian 13 Trixie installation with **GNOME** (other DEs may break the scripts).  
2. Your computer this is valid and tested on x86 devices (mobile arch version coming soon).
3. About an hour.

---

## Installation

```bash
# 1️⃣  Install Git
sudo apt update && sudo apt install git -y

# 2️⃣  Clone this repository
git clone https://github.com/PiercingXX/debian-mod

# 3️⃣  Make the scripts executable
chmod -R u+x debian-mod/

# 4️⃣  Enter the directory
cd debian-mod

# 5️⃣  Run the main installer
./install.sh
```

---

## Optional Scripts

| Script | Purpose | When to Run |
|--------|---------|-------------|
| `nvidia.sh` | Installs proprietary NVIDIA drivers. | Do not install on a Microsoft Surface. |
| `Surface.sh` | Installs Microsoft Surface kernel modules. | Only for use with Surface devices. |
| `hyprland-setup.sh` | Installs Hyprland and related packages. | Pushing a new update soon. |
| `testing.sh` | Switches the system to Debian Testing. | Do not use unless you know how to fix your computes when it breaks. |


---

## Hardware‑Specific Notes

- **Steam**: Install Steam *before* running `nvidia.sh`. Steam must be fully installed and updated first.
- **Surface Devices**: Skip `nvidia.sh` you want to break your system at the next update.
- **Multiple Hard Drives**: Edit `/etc/fstab` to auto‑mount additional drives at boot.

---

## Post‑Installation

- **Hyprland**: If you installed Hyprland, log out of GNOME and select Hyprland from the login screen.
- **Custom Configs**: The script pulls in configurations from the [Piercing‑Dots](https://github.com/PiercingXX/Piercing-Dots) repo, including:
  - A fully‑featured Hyprland setup
  - Neovim with Yazi file manager
  - GIMP custom keybindings
  - Ulauncher bound to the SUPER key
  - Aura color theme

---

## Credits
- **Linux‑Surface** – Surface kernel bits from the [linux‑surface](https://github.com/linux-surface/linux-surface/wiki) project, integrated into this script.

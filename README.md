# Debian‑mod.sh

Automates the installation of a fully‑featured Debian workstation, including optional GPU drivers, Mircosoft Surface support, Hyprland, and a curated set of workstation tools.

---

## 📦 Overview

`debian-mod.sh` is a one‑step installer that automates the setup of a fully‑featured Debian workstation.  
It installs:

- Core system packages (GNOME, developer tools, etc.)
- Optional GPU drivers (NVIDIA)
- Microsoft Surface kernel modules
- Hyprland
- Dotfiles from the [Piercing‑Dots](https://github.com/PiercingXX/Piercing-Dots) repo, including:
	  - A curated collection of dotfiles 
	  - One‑step distro-agnostic maintenance script for Linux.
	  - A fully‑featured Hyprland setup
	  - Minimal Neovim with Yazi file manager
	  - GIMP custom keybindings
	  - Ulauncher bound to the SUPER key***
	  - Aura color theme

> The script is designed for **x86_64** machines. A mobile version is coming soon.



---

## ✅ Prerequisites

| Item | Why it matters | How to check |
|------|----------------|--------------|
| Fresh Debian 13 Trixie | The script assumes a clean install | `lsb_release -a` |
| GNOME desktop | Some scripts rely on GNOME utilities | `gnome-shell --version` |
| Internet connection | Packages are fetched from the network | `ping -c 1 debian.org` |

---

## 🚀 Installation

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

## 🔧 Usage

```bash
./install.sh
```

| Option      | Description                                         |
| ----------- | --------------------------------------------------- |
| `--dry-run` | Show what would be installed without making changes |
| `--help`    | Display the help message                            |

---

## 📦 Optional Scripts

| Script | Purpose | When to Run |
|--------|---------|-------------|
| `nvidia.sh` | Installs proprietary NVIDIA drivers | **Do not** run on Microsoft Surface devices |
| `Surface.sh` | Installs Microsoft Surface kernel modules | Only for Surface hardware |
| `hyprland-setup.sh` | Installs Hyprland and related packages | Use when you want a Wayland session |
| `testing.sh` | Switches the system to Debian Testing | Only if you’re comfortable troubleshooting |

---

## 🔌 Hardware‑Specific Notes

- **Steam**: Install Steam *before* running `nvidia.sh`. Steam must be fully installed and updated first.
- **Surface Devices**: Skip `nvidia.sh` to avoid breaking your system on the next update.
- **Multiple Hard Drives**: Edit `/etc/fstab` to auto‑mount additional drives at boot.

---

## 🎉 Post‑Installation

- **Hyprland**: Log out of GNOME, pick Hyprland at login, and enjoy a Wayland session that actually works.
- Make sure all your extensions are installed.

---

## 🙏 Credits

- **Linux‑Surface** – Surface kernel bits from the [linux‑surface](https://github.com/linux-surface/linux-surface/wiki) project, integrated into this script.
- **Piercing‑Dots** – Dotfiles and configurations that makes the workstation usable.

---

## 🤝 Contributing

If you have suggestions, fork, hack, PR. I'd love to check it out.

Please keep the [maintenance.sh](vscode-file://vscode-app/opt/visual-studio-code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) script **POSIX‑friendly** and avoid hard‑coding paths.

---

## 📄 License

MIT © PiercingXX  
See the LICENSE file for details.

---

## 📞 Support & Contact
  
*Don't*

---


*** In Gnome you'll need to manually bind it using the Super Key extension

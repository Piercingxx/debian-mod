# Debian‑Mod

A one-step installer for a fully-featured Debian workstation.  
Automates core package installation, GPU drivers, Surface kernel modules, Hyprland, and curated dotfiles.

---

## 📦 Features

- Installs GNOME, developer tools, and essential apps
- Optional NVIDIA driver and Microsoft Surface kernel support
- Hyprland and dependencies built from scratch
- Applies [Piercing‑Dots](https://github.com/PiercingXX/Piercing-Dots) dotfiles and customizations
- Firewall configuration with UFW
- Flatpak integration and core desktop applications

---

## 🚀 Quick Start

```bash
sudo apt update && sudo apt install git -y
git clone https://github.com/PiercingXX/debian-mod
cd debian-mod
chmod -R u+x scripts/
./install.sh
```

---

## 🛠️ Usage

Run `./install.sh` and follow the menu prompts.  
Options include system install, NVIDIA drivers, Surface kernel, Hyprland, and reboot.

---

## 🔧 Optional Scripts

| Script                | Purpose                                 |
|-----------------------|-----------------------------------------|
| `scripts/nvidia.sh`   | Installs proprietary NVIDIA drivers     |
| `scripts/Surface.sh`  | Installs Microsoft Surface kernel       |
| `scripts/hyprland-install.sh` | Installs Hyprland and dependencies |
| `scripts/apps.sh`     | Installs core desktop applications      |
| `scripts/install-printers.sh` | Configures Canon D530 or Omezizy label printers |

---

## 📄 License

MIT © PiercingXX  
See the LICENSE file for details.

---

## 🤝 Contributing

Fork, branch, and PR welcome.  
Keep scripts POSIX-friendly and avoid hard-coded paths.

---

## 📞 Support

*No direct support provided.*

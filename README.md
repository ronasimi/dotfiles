# My Hyprland Dotfiles

This repository contains my personal [Hyprland](https://hyprland.org/) configuration, written in Lua using a native Lua implementation. It is tailored for a seamless, Wayland-native workflow on Arch Linux.

## 📦 Dependencies

To replicate this setup, you will need to install the following packages. They are divided into core Wayland components, UI elements, hardware controls, and specific applications bound in the configuration.

### 1. Core Wayland & Session
* **`hyprland`**: The Wayland compositor itself.
* **`uwsm`**: Universal Wayland Session Manager (used to wrap and launch applications).
* **`xdg-desktop-portal-hyprland`**: Required for Wayland screen sharing and portal support.
* **`xdg-desktop-portal-gtk`**: Fallback portal for GTK applications.
* **`polkit-gnome`**: Graphical authentication agent.
* **`gnome-keyring`**: Secret service provider.

### 2. Hyprland Ecosystem
* **`hypridle`**: Manages idle states and screen blanking.
* **`hyprlock`**: Screen locker.
* **`hyprpaper`**: Wallpaper utility.

### 3. Shell, Status & UI
* **`waybar`**: Highly customizable status bar.
* **`wofi`**: Application launcher and dynamic menu.
* **`dunst`**: Lightweight notification daemon.
* **`nwg-displays`**: Display configuration GUI.
* **`nwg-look`**: GTK theme configuration tool.
* **`qt6ct`**: Qt6 theme configuration tool.

### 4. Clipboard & Screenshots
* **`wl-clipboard`**: Command-line copy/paste utilities (`wl-copy` and `wl-paste`).
* **`cliphist`**: Clipboard history manager.
* **`grimblast`** *(AUR)*: Advanced screenshot utility.
* **`wl-clip-persist`** *(AUR)*: Keeps clipboard contents active after closing the source application.

### 5. Hardware & Media Control
* **`pamixer`**: Pulseaudio command-line mixer for volume control keybinds.
* **`libpulse`**: Provides `pactl` for microphone muting.
* **`pavucontrol`**: GUI audio mixer.
* **`brightnessctl`**: Backlight control for the screen and keyboard.
* **`playerctl`**: Media player controller (heavily used in the idle configuration).
* **`wireless_tools`**: Provides `iwgetid` (used in the lock screen to show Wi-Fi status).
* **`overskride`** *(AUR)*: Bluetooth GUI.

### 6. Terminal & File Management
* **`kitty`**: Default GPU-accelerated terminal emulator.
* **`thunar`**: Default file manager.
* **`catfish`**: File search tool.
* **`xarchiver`**: Archive manager.
* **`trash-cli`**: Command-line trash utility (used for Electron apps).
* **`dash`**: Lightweight, POSIX-compliant shell (used for battery/idle scripts).

### 7. System Utilities
* **`hyprshutdown`** *(AUR)*: Power menu and shutdown script.
* **`syshud`** *(AUR)*: Visual on-screen indicator (OSD) for volume and brightness changes.
* **`btop`**: Resource monitor.
* **`galculator`**: Calculator.
* **`networkmanager`**: Provides `nmtui` and `nm-connection-editor` for network management.
* **`jq`**: Command-line JSON processor (used in custom layout toggle scripts).

### 8. End-User Applications (Configured & Bound)
These applications have specific window rules or keybinds assigned in the configuration:
* **Web**: `google-chrome` *(AUR)*
* **Development**: `visual-studio-code-bin` *(AUR)*, `meld`
* **Creativity/Design**: `gimp`, `prusa-slicer`
* **Office**: `libreoffice-fresh` (or `libreoffice-still`)
* **Virtualization**: `vmware-workstation` *(AUR)*
* **Media/Viewing**: `mpv` (video), `imv` (images), `zathura` (documents/PDFs)
* **Networking**: `localsend-bin` *(AUR)*

---

## 🚀 Installation Guide (Arch Linux)

You can install the majority of these packages using the official Arch repositories, and the rest using your preferred AUR helper (e.g., `yay` or `paru`).

**1. Install Official Repository Packages:**
```bash
sudo pacman -S hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk polkit-gnome gnome-keyring hypridle hyprlock hyprpaper waybar wofi dunst qt6ct wl-clipboard cliphist pamixer libpulse pavucontrol brightnessctl playerctl wireless_tools kitty thunar catfish xarchiver trash-cli dash btop galculator networkmanager jq gimp prusa-slicer libreoffice-fresh mpv imv zathura meld

**2. Install AUR Packages:**

Bash
yay -S uwsm nwg-displays nwg-look grimblast-git wl-clip-persist overskride hyprshutdown syshud google-chrome visual-studio-code-bin vmware-workstation localsend-bin

**⚙️ Applying the Configuration**
Clone this repository to your local machine.

Backup your existing Hyprland configurations.

Copy the contents of this repository into your ~/.config/hypr/ directory.

Ensure all custom scripts (e.g., ~/.config/hypr/scripts/battlock.sh) are marked as executable:

Bash
chmod +x ~/.config/hypr/scripts/*.sh
Log out and start your Hyprland session (preferably using uwsm).
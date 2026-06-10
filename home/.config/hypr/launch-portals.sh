#!/usr/bin/env bash
sleep 1

# 1. Update the environment settings so systemd knows where to look
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# 2. Stop any stuck backend instances gracefully
systemctl --user stop xdg-desktop-portal xdg-desktop-portal-hyprland

# 3. Start the portal service correctly through systemd
systemctl --user start xdg-desktop-portal
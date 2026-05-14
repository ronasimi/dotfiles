-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function () 
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")
  hl.exec_cmd("systemctl --user import-environment QT_QPA_PLATFORMTHEME")
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("eval '$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)'")
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'OpenZone_White_Slim'")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Materia-dark-compact'")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-application-prefer-dark-theme 'true'")
  hl.exec_cmd("hyprpm reload")
  hl.exec_cmd("dunst")
  hl.exec_cmd("wl-clip-persist --clipboard regular")
  hl.exec_cmd("wl-paste --watch cliphist store")
  hl.exec_cmd("thunar --daemon")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("~/.config/waybar/waybar.sh")
  hl.exec_cmd("syshud")
end)
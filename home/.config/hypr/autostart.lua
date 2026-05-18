-- Autostart applications and commands for Hyprland
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/ for more details.

hl.on("hyprland.start", function ()
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")
  hl.exec_cmd("systemctl --user import-environment QT_QPA_PLATFORMTHEME")
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("eval '$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)'")
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("dunst")
  hl.exec_cmd("wl-clip-persist --clipboard regular")
  hl.exec_cmd("wl-paste --watch cliphist store")
  hl.exec_cmd("thunar --daemon", { workspace = "3 silent" })
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("/home/ron/.config/waybar/waybar.sh")
  hl.exec_cmd("syshud")
end)

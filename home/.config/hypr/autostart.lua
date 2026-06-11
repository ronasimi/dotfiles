-- Autostart applications and commands for Hyprland
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/ for more details.

hl.on("hyprland.start", function()
  -- Always wrap manual launches inside the UWSM app helper
  hl.exec_cmd("uwsm app -- thunar --daemon", { workspace = "3 silent" })
  hl.exec_cmd("uwsm app -- syshud")
end)

-- Autostart applications and commands for Hyprland
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/ for more details.

hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm app -- syshud")
    hl.exec_cmd("uwsm app -- hyprexpose")
    hl.exec_cmd("uwsm app -- thunar --daemon", { workspace = "3 silent" })
end)

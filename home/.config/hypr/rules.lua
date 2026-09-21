--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

local fx = __require("functions")

-- Global Modifiers
hl.window_rule({ match = { float = true }, border_size = 0 })
hl.window_rule({ name = "suppress-maximize-events", match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({
    name = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

-- Layer Rules (Blur/Animation)
hl.layer_rule({
    name         = "blur-ui-layers",
    match        = { namespace = "^(wofi|waybar|notifications|syshud|dunst)$" },
    animation    = "fade",
    blur         = true,
    blur_popups  = true,
    ignore_alpha = 0.2,
})

hl.layer_rule({
    name         = "walker-launcher",
    match        = { namespace = "^(walker)$" },
    animation    = "fade",
    blur         = true,
    dim_around   = true,
    ignore_alpha = 0.1,
})

-- Workspace Assignments
local workspace_rules = {
    { ws = "4",                  class = "^(code|org\\.gnome\\.Meld)$" },
    { ws = "5",                  class = "^(gimp|gimp-3\\.0)$" },
    { ws = "6",                  class = "^(Vmware)$" },
    { ws = "7",                  class = "^(libreoffice|libreoffice-startcenter|libreoffice-writer|libreoffice-calc|Soffice)$" },
    { ws = "8",                  class = "^(PrusaSlicer)$" },
    { ws = "special:scratchpad", class = "^(scratchpad)$" },
}

for _, rule in ipairs(workspace_rules) do
    hl.window_rule({ match = { class = rule.class }, workspace = rule.ws })
end

-- Floating Apps
hl.window_rule({
    match = { class = "^(dunst|btop|galculator|nwg-look|catfish|org\\.pwmt\\.zathura|localsend|nm-connection-editor|com.moonlight_stream.Moonlight|super-enter|nmtui|org\\.pulseaudio\\.pavucontrol|imv|tnywfi.py|tnywfi)$" },
    float = true,
})

-- General floating utilities
hl.window_rule({
    name = "hyprland-run",
    match = { class = "hyprland-run" },
    float = true,
    pin = true,
    opacity = 0.85,
    no_shadow = true,
    center = true,
})

hl.window_rule({
    name = "super-enter",
    match = { class = "^(super-enter)$" },
    float = true,
    pin = true,
})

-- Monitor-aware utility windows. 36px Waybar + 9px clearance = y=45;
-- right edge is always 9px from the current monitor.
fx.register_utility_window({
    name = "audio-utility",
    class = "^(nmtui|org\\.pulseaudio\\.pavucontrol)$",
    classes = { "nmtui", "org.pulseaudio.pavucontrol" },
    width = 600,
    height = 566,
    anchor = "top-right",
})

fx.register_utility_window({
    name = "bluetooth-utility",
    class = "^(io\\.github\\.kaii_lb\\.Overskride)$",
    classes = { "io.github.kaii_lb.Overskride" },
    width = 942,
    height = 616,
    anchor = "top-right",
})

fx.register_utility_window({
    name = "display-utility",
    class = "^(nwg-displays)$",
    classes = { "nwg-displays" },
    width = 916,
    height = 472,
    anchor = "top-right",
})

fx.register_utility_window({
    name = "wifi-utility",
    class = "^(tnywfi)$",
    classes = { "tnywfi" },
    width = 480,
    height = 450,
    anchor = "top-right",
})

-- Wide drop-down terminal: preserve the old 18px side/bottom margins, but size
-- it relative to whichever monitor it opens on rather than assuming 1920x1080.
fx.register_utility_window({
    name = "bottom-terminal",
    class = "^(super-shift-enter)$",
    classes = { "super-shift-enter" },
    height = 72,
    anchor = "bottom-stretch",
    left = 18,
    right = 18,
    bottom = 18,
})

hl.window_rule({
    match = { class = "^(mpv)$" },
    float = true,
    opaque = true,
    no_shadow = true,
    keep_aspect_ratio = true,
    idle_inhibit = "always",
})

hl.window_rule({
    match = { class = "^(xdg-desktop-portal-gtk)$" },
    float = true,
    size = { 942, 504 },
    center = true,
})

-- Modal and Dialog Catch-all
hl.window_rule({ match = { modal = true }, float = true })

local dialog_rules = {
    { class = "^(?i)(thunar)$",                   title = "^(File|Rename|Create|Attention|Copy|Move|Delete).*" },
    { class = "^(?i)(google-chrome.*|electron)$", title = "^(Open|Save|Downloads|Print).*" },
    { class = "^(?i)(code)$",                     title = "^(Open|Save|Print).*" },
    { class = "^(?i)(gimp|gimp-3\\.0)$",          title = "^(Open|Save|Export|Quit|Scale|Set|Print).*" },
    { class = "^(?i)(xarchiver)$",                title = "^(Extract|Add|Delete|Properties|Please).*" },
    { class = "^(?i)(vmware)$",                   title = "^(Open|Save|Progress|Quit).*" },
    { class = "^(?i)(soffice)$",                  title = "^(Text Import|Open|Save|Error|Warning|Information|Confirm|Export|Print|Properties|Options).*" },
}

for _, rule in ipairs(dialog_rules) do
    hl.window_rule({ match = { class = rule.class, title = rule.title }, float = true })
end

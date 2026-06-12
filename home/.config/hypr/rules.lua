--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Ignore maximize requests from all apps.
local suppressMaximizeRule = hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

-- Fix dragging issues with XWayland
hl.window_rule({
    name     = "fix-xwayland-drags",
    match    = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

-- Layer Rules (Includes tooltips/popups for waybar and dunst/notifications)
local blur_layers = { "wofi", "waybar", "notifications" }
for _, layer in ipairs(blur_layers) do
    hl.layer_rule({
        name         = layer .. "-slide",
        match        = { namespace = layer },
        animation    = "slide",
        blur         = true,
        blur_popups  = true,
        ignore_alpha = 0.2,
    })
end

-- Workspace Assignments
local workspace_rules = {
    { ws = "4", classes = { "^(code)$", "^(org.gnome.Meld)$" } },
    { ws = "5", classes = { "^(gimp|gimp-3.0)$" } },
    { ws = "6", classes = { "^(Vmware)$" } },
    { ws = "7", classes = { "^(libreoffice|libreoffice-startcenter|libreoffice-writer|libreoffice-calc|Soffice)$" } },
    { ws = "8", classes = { "^(PrusaSlicer)$" } },
    { ws = "special:scratchpad", classes = { "^(scratchpad)$" } }
}

for _, rule in ipairs(workspace_rules) do
    for _, class in ipairs(rule.classes) do
        hl.window_rule({ match = { class = class }, workspace = rule.ws })
    end
end

-- Simple Floating Apps
local floating_classes = {
    "^(dunst)$", "^(btop)$", "^(galculator)$", "^(nwg-look)$",
    "^(catfish)$", "^(org.pwmt.zathura)$", "^(localsend)$", "^(nm-connection-editor)$"
}
for _, class in ipairs(floating_classes) do
    hl.window_rule({ match = { class = class }, float = true })
end

-- Complex Floating Apps (Pins, Specific Sizes, and Positioning)
hl.window_rule({ match = { class = "hyprland-run" }, move = "20 monitor_h-120", float = true })
hl.window_rule({ match = { class = "^(super-enter)$" }, float = true, pin = true })
hl.window_rule({ match = { class = "^(nmtui)$" }, size = { 600, 566 }, move = { 1311, 45 }, float = true, pin = true })
hl.window_rule({ match = { class = "^(io.github.kaii_lb.Overskride)$" }, size = { 942, 616 }, move = { 969, 45 }, float = true, pin = true })
hl.window_rule({ match = { class = "^(org.pulseaudio.pavucontrol)$" }, size = { 600, 566 }, move = { 1311, 45 }, float = true, pin = true })
hl.window_rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, size = { 942, 504 }, float = true, center = true })
hl.window_rule({ match = { class = "^(nwg-displays)$" }, size = { 916, 472 }, move = { 995, 45 }, float = true, pin = true })

-- Media Players (Opaque & Aspect Ratio)
local media_players = { "^(mpv)$", "^(imv)$" }
for _, class in ipairs(media_players) do
    hl.window_rule({ match = { class = class }, float = true, opaque = true, keep_aspect_ratio = true })
end

-- Modal Catch-all
hl.window_rule({ match = { modal = true }, float = true })

-- Dialog Popups (Regex matches for Open/Save/Print dialogs)
local dialog_rules = {
    { class = "^(thunar)$", title = "^(File.*|Rename.*|Create.*|Attention.*|Copy.*|Move.*|Delete.*)$" },
    { class = "^(google-chrome)$", title = "^(Open.*|Save.*|Downloads.*|Print.*)$" },
    { class = "^(electron)$", title = "^(Open.*|Save.*|Downloads.*|Print.*)$" },
    { class = "^(code)$", title = "^(Open.*|Save.*|Print.*)$" },
    { class = "^(gimp)$", title = "^(Open.*|Save.*|Export.*|Quit.*|Scale.*|Set.*|Print.*)$" },
    { class = "^(xarchiver)", title = "^(Extract.*|Add.*|Delete.*|Properties.*|Please.*)$" },
    { class = "^(Vmware)$", title = "^(Open.*|Save.*|Progress.*|Quit.*)$" }
}

for _, rule in ipairs(dialog_rules) do
    hl.window_rule({ match = { class = rule.class, title = rule.title }, float = true })
end
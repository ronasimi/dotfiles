--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Ignore maximize requests from all apps.
local suppressMaximizeRule = hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix dragging issues with XWayland
hl.window_rule({
    name     = "fix-xwayland-drags",
    match    = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

-- Layer Rules (Combined using regex for faster evaluation)
hl.layer_rule({
    name         = "blur-ui-layers",
    match        = { namespace = "^(wofi|waybar|notifications|syshud)$" },
    animation    = "slide",
    blur         = true,
    blur_popups  = true,
    ignore_alpha = 0.2,
})

-- Workspace Assignments (Combined classes into single regex strings)
local workspace_rules = {
    { ws = "4", class_regex = "^(code|org\\.gnome\\.Meld)$" },
    { ws = "5", class_regex = "^(gimp|gimp-3\\.0)$" },
    { ws = "6", class_regex = "^(Vmware)$" },
    { ws = "7", class_regex = "^(libreoffice|libreoffice-startcenter|libreoffice-writer|libreoffice-calc|Soffice)$" },
    { ws = "8", class_regex = "^(PrusaSlicer)$" },
    { ws = "special:scratchpad", class_regex = "^(scratchpad)$" }
}

for _, rule in ipairs(workspace_rules) do
    hl.window_rule({ match = { class = rule.class_regex }, workspace = rule.ws })
end

-- Simple Floating Apps (Consolidated to one regex rule)
hl.window_rule({ 
    match = { class = "^(dunst|btop|galculator|nwg-look|catfish|org\\.pwmt\\.zathura|localsend|nm-connection-editor)$" }, 
    float = true 
})

-- Complex Floating Apps (Pins, Specific Sizes, and Positioning)
hl.window_rule({ match = { class = "hyprland-run" }, move = "20 monitor_h-120", float = true })
hl.window_rule({ match = { class = "^(super-enter)$" }, float = true, pin = true })
hl.window_rule({ match = { class = "^(nmtui|org\\.pulseaudio\\.pavucontrol)$" }, size = { 600, 566 }, move = { 1311, 50 }, float = true, pin = true })
hl.window_rule({ match = { class = "^(io\\.github\\.kaii_lb\\.Overskride)$" }, size = { 942, 616 }, move = { 969, 45 }, float = true, pin = true })
hl.window_rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, size = { 942, 504 }, float = true, center = true })
hl.window_rule({ match = { class = "^(nwg-displays)$" }, size = { 916, 472 }, move = { 995, 45 }, float = true, pin = true })

-- Media Players (Consolidated opaque & aspect ratio)
hl.window_rule({ 
    match = { class = "^(mpv|imv)$" }, 
    float = true, opaque = true, keep_aspect_ratio = true 
})

-- Modal Catch-all
hl.window_rule({ match = { modal = true }, float = true })

-- Dialog Popups (Regex optimized)
local dialog_rules = {
    { class = "^(thunar)$", title = "^(File|Rename|Create|Attention|Copy|Move|Delete).*" },
    { class = "^(google-chrome|electron)$", title = "^(Open|Save|Downloads|Print).*" },
    { class = "^(code)$", title = "^(Open|Save|Print).*" },
    { class = "^(gimp)$", title = "^(Open|Save|Export|Quit|Scale|Set|Print).*" },
    { class = "^(xarchiver)", title = "^(Extract|Add|Delete|Properties|Please).*" },
    { class = "^(Vmware)$", title = "^(Open|Save|Progress|Quit).*" }
}

for _, rule in ipairs(dialog_rules) do
    hl.window_rule({ match = { class = rule.class, title = rule.title }, float = true })
end
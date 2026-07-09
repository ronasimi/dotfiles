--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- 1. GLOBAL FLOATING RULE: Force all floating windows to have no border.
-- This single rule covers all apps that are set to float, removing the need for 'border_size = 0' elsewhere.
hl.window_rule({ match = { float = true }, border_size = 0 })

-- 2. Suppress maximize events
hl.window_rule({ name = "suppress-maximize-events", match = { class = ".*" }, suppress_event = "maximize" })

-- 3. Fix dragging issues with XWayland
hl.window_rule({ name = "fix-xwayland-drags", match = { class = "^$", title = "^$", xwayland = true, float = true }, no_focus = true })

-- 4. Layer Rules (Blur/Animation)
hl.layer_rule({
    name = "blur-ui-layers",
    match = { namespace = "^(wofi|waybar|notifications|syshud|dunst)$" },
    animation = "slide",
    blur = true,
    blur_popups = true,
    ignore_alpha = 0.2,
})

-- 5. Workspace Assignments
local workspace_rules = {
    { ws = "4",                  class = "^(code|org\\.gnome\\.Meld)$" },
    { ws = "5",                  class = "^(gimp|gimp-3\\.0)$" },
    { ws = "6",                  class = "^(Vmware)$" },
    { ws = "7",                  class = "^(libreoffice|libreoffice-startcenter|libreoffice-writer|libreoffice-calc|Soffice)$" },
    { ws = "8",                  class = "^(PrusaSlicer)$" },
    { ws = "special:scratchpad", class = "^(scratchpad)$" }
}

for _, rule in ipairs(workspace_rules) do
    hl.window_rule({ match = { class = rule.class }, workspace = rule.ws })
end

-- 6. Floating Apps (Only specify 'float = true' here; the global rule handles border)
hl.window_rule({
    match = { class = "^(dunst|btop|galculator|nwg-look|catfish|org\\.pwmt\\.zathura|localsend|nm-connection-editor|com.moonlight_stream.Moonlight|super-enter|nmtui|org\\.pulseaudio\\.pavucontrol|mpv|imv)$" },
    float = true
})

-- 7. Complex Floating Apps (Positions/Sizes)
hl.window_rule({ match = { class = "hyprland-run" }, move = "20 monitor_h-120", float = true })
hl.window_rule({ match = { class = "^(super-enter)$" }, float = true, pin = true })
hl.window_rule({ match = { class = "^(nmtui|org\\.pulseaudio\\.pavucontrol)$" }, size = { 600, 566 }, move = { 1311, 45 }, float = true, pin = true })
hl.window_rule({ match = { class = "^(io\\.github\\.kaii_lb\\.Overskride)$" }, size = { 942, 616 }, move = { 969, 45 }, float = true, pin = true })
hl.window_rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, size = { 942, 504 }, float = true })
hl.window_rule({ match = { class = "^(nwg-displays)$" }, size = { 916, 472 }, move = { 995, 45 }, float = true, pin = true })

-- 8. Modal and Dialog Catch-all
hl.window_rule({ match = { modal = true }, float = true })
local dialog_rules = {
    { class = "^(thunar)$",                 title = "^(File|Rename|Create|Attention|Copy|Move|Delete).*" },
    { class = "^(google-chrome|electron)$", title = "^(Open|Save|Downloads|Print).*" },
    { class = "^(code)$",                   title = "^(Open|Save|Print).*" },
    { class = "^(gimp)$",                   title = "^(Open|Save|Export|Quit|Scale|Set|Print).*" },
    { class = "^(xarchiver)",               title = "^(Extract|Add|Delete|Properties|Please).*" },
    { class = "^(Vmware)$",                 title = "^(Open|Save|Progress|Quit).*" }
}

for _, rule in ipairs(dialog_rules) do
    hl.window_rule({ match = { class = rule.class, title = rule.title }, float = true })
end

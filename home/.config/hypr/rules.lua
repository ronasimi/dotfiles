--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})


-- Layer rules also return a handle.

local wofiLayerRule = hl.layer_rule({
    name  = "wofi-slide",
    match = { namespace = "wofi" },
    animation = "slide",
    blur = true,
})

local waybarLayerRule = hl.layer_rule({
    name  = "waybar-slide",
    match = { namespace = "waybar" },
    animation = "slide",
    blur = true,
})


-- Window rules

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name  = "code-workspace-4",
    match = { class = "^(code)$" },
    workspace = "4",
})

hl.window_rule({
    name  = "meld-workspace-4",
    match = { class = "^(org.gnome.Meld)$" },
    workspace = "4",
})

hl.window_rule({
    name  = "gimp-workspace-5",
    match = { class = "^(gimp|gimp-3.0)$" },
    workspace = "5",
})

hl.window_rule({
    name  = "vmware-workspace-6",
    match = { class = "^(Vmware)$" },
    workspace = "6",
})

hl.window_rule({
    name  = "libreoffice-workspace-7",
    match = { class = "^(libreoffice|libreoffice-startcenter|libreoffice-writer|libreoffice-calc|Soffice)$" },
    workspace = "7",
})

hl.window_rule({
    name  = "prusa slicer-workspace-8",
    match = { class = "^(PrusaSlicer)$" },
    workspace = "8",
})

hl.window_rule({
    name  = "dunst-floating",
    match = { class = "^(dunst)$" },
    float = true,
})

hl.window_rule({
    name  = "super-enter",
    match = { class = "^(super-enter)$" },
    float = true,
    pin = true,
    workspace = "4",
})

hl.window_rule({
    name  = "nm-connection-editor-floating",
    match = { class = "^(nm-connection-editor)$" },
    float = true,
})

hl.window_rule({
    name  = "nmtui-floating",
    match = { class = "^(nmtui)$" },
    size = {600, 566},
    move  = {1311, 45},
    float = true,
    pin = true,
})

hl.window_rule({
    name  = "btop-floating",
    match = { class = "^(btop)$" },
    float = true,
})

hl.window_rule({
    name  = "adw-bluetooth-floating",
    match = { class = "^(com.ezratweaver.AdwBluetooth)$" },
    size = {500, 400},
    move  = {1411, 45},
    float = true,
})

hl.window_rule({
    name  = "pavucontrol-floating",
    match = { class = "^(org.pulseaudio.pavucontrol)$" },
    size = {600, 566},
    move  = {1311, 45},
    float = true,
})

hl.window_rule({
    name  = "galculator-floating",
    match = { class = "^(galculator)$" },
    float = true,
})

hl.window_rule({
    name  = "mpv",
    match = { class = "^(mpv)$" },
    float = true,
    opaque = true,
    keep_aspect_ratio = true,
})

hl.window_rule({
    name  = "imv",
    match = { class = "^(imv)$" },
    float = true,
    opaque = true,
    keep_aspect_ratio = true,
})

hl.window_rule({
    name  = "xdg-desktop-portal-gtk-floating",
    match = { class = "^(xdg-desktop-portal-gtk)$" },
    float = true,
})

hl.window_rule({
    name  = "nwg-look-floating",
    match = { class = "^(nwg-look)$" },
    float = true,
})

hl.window_rule({
    name  = "nwg-displays-floating",
    match = { class = "^(nwg-displays)$" },
    size  = {916, 472},
    move  = {995, 45},
    float = true,
})

hl.window_rule({
    name  = "catfish-floating",
    match = { class = "^(catfish)$" },
    size = {936, 523},
    float = true,
})

hl.window_rule({
    name  = "zathura-floating",
    match = { class = "^(org.pwmt.zathura)$" },
    float = true,
})

hl.window_rule({
    name  = "thunar-dialogs-floating",
    match = { class = "^(thunar)$", title = "^(File|Rename|Create|Attention|Copy|Move|Delete)$" },
    float = true,
})

hl.window_rule({
    name  = "chrome-dialogs-floating",
    match = { class = "^(google-chrome)$", title = "^(Open|Save|Downloads|Print)$" },
    float = true,
})

hl.window_rule({
    name  = "electron-dialogs-floating",
    match = { class = "^(electron)$", title = "^(Open|Save|Downloads|Print)$" },
    float = true,
})

hl.window_rule({
    name  = "code-dialogs-floating",
    match = { class = "^(code)$", title = "^(Open|Save|Print)$" },
    float = true,
})

hl.window_rule({
    name  = "gimp-dialogs-floating",
    match = { class = "^(gimp)$", title = "^(Open|Save|Export|Quit|Scale|Set|Print)$" },
    float = true,
})

hl.window_rule({
    name  = "warpinator-floating",
    match = { class = "^(warpinator-launch.py)$" },
    float = true,
})

hl.window_rule({
    name  = "xarchive-dialogs-floating",
    match = { class = "^(xarchiver)", title = "^(Extract|Add|Delete|Properties|Please)$" },
    float = true,
})

hl.window_rule({
    name  = "scratchpad-special",
    match = { class = " ^(scratchpad)$" },
    workspace = "special:scratchpad",
})

hl.window_rule({
    name  = "modal-floating",
    match = { modal = true },
    float = true,
})

hl.window_rule({
    name  = "vmware-dialogs-floating",
    match = { class = "^(Vmware)$", title = "^(Open|Save|Progress)$" },
    float = true,
})


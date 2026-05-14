--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Layer rules
-- Enable blur for waybar
hl.layer_rule(
    { match = { namespace = "waybar" },
     blur = true,
     animation = "slide",
    }
)

hl.layer_rule(
    { match = { namespace = "wofi" },
     blur = true,
     animation = "slide",
    }
)

-- No animations for the selection layer, which is used by wofi and waybar popups
local selectionRule = hl.layer_rule(
    {
        name      = "no-anim-for-selection",
        match     = { namespace = "selection" },
        no_anim   = true,
    }
)


-- Window rules
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
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule(
    {
    name  = "code-workspace-4",
    match = { class = "^(code-url-handler)$" },
    workspace = "4",
    }
)

hl.window_rule(
    {
    name  = "meld-workspace-4",
    match = { class = "^(org.gnome.Meld)$" },
    workspace = "4",
    }
)

hl.window_rule(
    {
    name  = "gimp-workspace-5",
    match = { class = "^(gimp|gimp-3.0)$" },
    workspace = "5",
    }
)

hl.window_rule(
    {
    name  = "vmware-workspace-6",
    match = { class = "^(Vmware)$" },
    workspace = "6",
    }
)

hl.window_rule(
    {
    name  = "libreoffice-workspace-7",
    match = { class = "^(libreoffice|libreoffice-startcenter|libreoffice-writer|libreoffice-calc|Soffice)$" },
    workspace = "7",
    }
)

hl.window_rule(
    {
    name  = "prusa-slicer-workspace-8",
    match = { class = "^(PrusaSlicer)$" },
    workspace = "8",
    }
)

hl.window_rule(
    {
    name  = "dunst-floating",
    match = { class = "^(dunst)$" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "super-enter-floating",
    match = { class = "^(super-enter)$" },
    float = true,
    pin = true,
    }
)

hl.window_rule(
    {
    name  = "nmtui-floating",
    match = { class = "^(nmtui)$" },
    float = true,
    size = { 600, 566 },
    move = {1311, 45},
    }
)

hl.window_rule(
    {
    name  = "btop-floating",
    match = { class = "^(btop)$" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "adwbluetooth-floating",
    match = { class = "^(com.ezratweaver.AdwBluetooth)$" },
    float = true,
    size = { 600, 566 },
    move = { 1311, 45 },
    }
)

hl.window_rule(
    {
    name  = "pavucontrol-floating",
    match = { class = "^(pavucontrol)$" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "pavucontrol-floating-2",
    match = { class = "^(org.pulseaudio.pavucontrol)$" },
    float = true,
    size = { 500, 400 },
    move = { 1411, 45 },
    }
)

hl.window_rule(
    {
    name  = "galculator-floating",
    match = { class = "^(galculator)$" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "mpv-floating",
    match = { class = "^(mpv)$" },
    float = true,
    opaque = true,
    keep_aspect_ratio = true,
    }
)

hl.window_rule(
    {
    name  = "imv-floating",
    match = { class = "^(imv)$" },
    float = true,
    opaque = true,
    keep_aspect_ratio = true,
    }
)

hl.window_rule(
    {
    name  = "xdg-desktop-portal-gtk-floating",
    match = { class = "^(xdg-desktop-portal-gtk)$" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "nwg-look-floating",
    match = { class = "^(nwg-look)$" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "nwg-displays-floating",
    match = { class = "^(nwg-displays)$" },
    float = true,
    size = { 916, 422 },
    move = { 995, 45 },
    }
)

hl.window_rule(
    {
    name  = "catfish-floating",
    match = { class = "^(catfish)$" },
    float = true,
    size = { 936, 523 },
    }
)

hl.window_rule(
    {
    name  = "zathura-floating",
    match = { class = "^(org.pwmt.zathura)$" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "thunar-file-dialog-floating",
    match = { class = "^(thunar)$", title = "(File.*)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "thunar-rename-dialog-floating",
    match = { class = "^(thunar)$", title = "(Rename.*)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "thunar-create-dialog-floating",
    match = { class = "^(thunar)$", title = "(Create.*)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "thunar-attention-dialog-floating",
    match = { class = "^(thunar)$", title = "(Attention.*)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "firefox-open-dialog-floating",
    match = { class = "^(firefox)$", title = "(Open.*)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "firefox-save-dialog-floating",
    match = { class = "^(firefox)$", title = "(Save.*)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "google-chrome-open-dialog-floating",
    match = { class = "^(google-chrome)$", title = "(Open.*)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "google-chrome-save-dialog-floating",
    match = { class = "^(google-chrome)$", title = "(Save.*)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "electron-open-dialog-floating",
    match = { class = "^(electron)$", title = "(Open.*)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "electron-save-dialog-floating",
    match = { class = "^(electron)$", title = "(Save.*)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "code-open-dialog-floating",
    match = { class = "^(code)$", title = "(Open.*)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "electron-save-dialog-floating",
    match = { class = "^(code)$", title = "(Save.*)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "gimp-startup-floating",
    match = { title = "(GIMP Startup)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "gimp-open-dialog-floating",
    match = { class = "^(gimp)$", title = "(Open.*)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "gimp-save-dialog-floating",
    match = { class = "^(gimp)$", title = "(Save.*)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "gimp-export-dialog-floating",
    match = { class = "^(gimp)$", title = "(Export.*)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "gimp-quit-dialog-floating",
    match = { class = "^(gimp)$", title = "(Quit.*)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "gimp-scale-dialog-floating",
    match = { class = "^(gimp)$", title = "(Scale.*)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "gimp-set-dialog-floating",
    match = { class = "^(gimp)$", title = "(Set.*)" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "file-dialog-floating",
    match = { class = "^(file-.*)$" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "warpinator-floating",
    match = { class = "^(warpinator-launch.py)$" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "xarchiver-extract-floating",
    match = { class = "^(xarchiver)$", title = "(Please select the destination directory:)$" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "scratchpad-special",
    match = { class = "^(scratchpad)$" },
    workspace = "special",    
    }
)

hl.window_rule(
    {
    name  = "modal-floating",
    match = { modal = true },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "warpinator-floating",
    match = { class = "^(warpinator-launch.py)$" },
    float = true,
    }
)

hl.window_rule(
    {
    name  = "vmware-progress-floating",
    match = { class = "^(vmware)$", title = "(Progress.*)" },
    float = true,
    }
)
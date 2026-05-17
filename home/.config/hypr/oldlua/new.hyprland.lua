-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")

require("monitors")
require("workspaces")
require("env")
require("windowrules")
-- require("plugins")
require("autostart")


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "wofi"


-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 9,
        gaps_out = 18,

        border_size = 0,

        col = {
            active_border   = { colors = {"rgba(f4bf75cc)", "rgba(8ab4f8cc)"}, angle = 45 },
            inactive_border = "rgba(272727cc)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 9,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 0.8,

        shadow = {
            enabled      = true,
            range        = 18,
            render_power = 4,
            color        = "rgba(020d1f80)",
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 3,
            noise     = 0.0234,
            popups    = true,
            special   = false,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
        force_split   = 2,
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
        mfact = 0.60,
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
        disable_splash_rendering = true, -- If true disables the splash screen rendering. This means you won't see the Hyprland logo when you start Hyprland, but it also means you won't see a black screen if you have a very fast startup.
        focus_on_activate = true,
        animate_manual_resizes = false,
        animate_mouse_windowdragging = false,
        enable_anr_dialog = false,
        font_family = "SF Pro",
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0.6, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true,
            drag_lock      = false,
            scroll_factor  = 1.0,
        },

        touchdevice = {
            enabled = true,
        },
    },
})

hl.gesture(
    {
        fingers = 3,
        direction = "horizontal",
        action = "workspace"
    },
    {
        fingers = 3,
        direction = "down",
        action = "dispatcher",
        dispatcher = "togglespecialworkspace",
    }
)

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
-- hl.device({
--     name        = "epic-mouse-v1",
--     sensitivity = -0.5,
-- })


-- Handle lid switch
-- Trigger when the switch is toggled.
-- hl.bind("switch:[Lid Switch]", hl.dsp.exec_cmd("pidof hyprlock || hyprlock -grace 0 --immediate-render"), { locked = true })
-- Trigger when the switch is turning on.
hl.bind("switch:on:[Lid Switch]", hl.dsp.exec_cmd("pidof hyprlock || hyprlock -grace 0 --immediate-render"), { locked = true })
-- Trigger when the switch is turning off.
hl.bind("switch:off:[Lid Switch]", hl.dsp.exec_cmd("hyprctl dispatch dpms on"), { locked = true })

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
local closeWindowBind = hl.bind(mainMod .. " + X", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + TAB",            hl.dsp.workspace.toggle_special)
hl.bind(mainMod .. " + SHIFT + DELETE", hl.dsp.window.move({ workspace = "special" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Scroll workspaces with page up/down
hl.bind(mainMod .. " + page_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + page_down", hl.dsp.focus({ workspace = "e+1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"),                    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"),                    { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pamixer -t"),                      { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("pactl set-source-mute 0 toggle"),  { locked = true, repeating = true })

hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),   { locked = true, repeating = true })
hl.bind("XF86Display",          hl.dsp.exec_cmd("nwg-displays"))
hl.bind("XF86Tools",            hl.dsp.exec_cmd("kitty --class 'btop' -e 'btop'"))
hl.bind("XF86LaunchA",          hl.dsp.exec_cmd("pkill -SIGUSR1 '^waybar$'"))

hl.bind("XF86ScreenSaver",      hl.dsp.exec_cmd("pidof hyprlock || hyprlock --grace 0 --immediate-render"))

-- Lid switch

-- Pin current window to all workspaces (sticky)
hl.bind(mainMod .. " + S",  hl.dsp.window.pin({ action = "toggle" }))


-- Application binds
hl.bind(mainMod .. " + F1", function()
    hl.dispatch(hl.dsp.focus({ workspace = 1 }))
    hl.dispatch(hl.dsp.exec_cmd("google-chrome-stable")) 
end)
hl.bind(mainMod .. " + F2", function()
    hl.dispatch(hl.dsp.focus({ workspace = 2 }))
    hl.dispatch(hl.dsp.exec_cmd("kitty -1"))
end)
hl.bind(mainMod .. " + F3", function()
    hl.dispatch(hl.dsp.focus({ workspace = 3 }))
    hl.dispatch(hl.dsp.exec_cmd("thunar"))
end)
hl.bind(mainMod .. " + F4", function()
    hl.dispatch(hl.dsp.focus({ workspace = 4 }))
    hl.dispatch(hl.dsp.exec_cmd("code"))
end)
hl.bind(mainMod .. " + F5", function()
    hl.dispatch(hl.dsp.focus({ workspace = 5 }))
    hl.dispatch(hl.dsp.exec_cmd("gimp"))
end)
hl.bind(mainMod .. " + F6", function()
    hl.dispatch(hl.dsp.focus({ workspace = 6 }))
    hl.dispatch(hl.dsp.exec_cmd("vmware"))
end)
hl.bind(mainMod .. " + F7", function()
    hl.dispatch(hl.dsp.focus({ workspace = 7 }))
    hl.dispatch(hl.dsp.exec_cmd("libreoffice --writer"))
end)
hl.bind(mainMod .. " + F8", function()
    hl.dispatch(hl.dsp.focus({ workspace = 8 }))
    hl.dispatch(hl.dsp.exec_cmd("GTK_THEME=Adwaita:dark prusa-slicer"))
end)

-- Open a terminal
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty --class 'super-enter'"))
hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd("kitty"))

-- Screenshots
hl.bind("PRINT", hl.dsp.exec_cmd("grimblast save screen"))
hl.bind("ALT + PRINT", hl.dsp.exec_cmd("grimblast save active"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("grimblast copy screen"))
hl.bind("ALT + SHIFT + PRINT ", hl.dsp.exec_cmd("grimblast copy active"))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("grimblast save area"))
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("grimblast copy area"))


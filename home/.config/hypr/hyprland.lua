--          _____                _____                    _____                    _____                    _____            _____                    _____                    _____
--         /\    \              |\    \                  /\    \                  /\    \                  /\    \          /\    \                  /\    \                  /\    \
--        /::\____\             |:\____\                /::\    \                /::\    \                /::\____\        /::\    \                /::\____\                /::\    \
--       /:::/    /             |::|   |               /::::\    \              /::::\    \              /:::/    /       /::::\    \              /::::|   |               /::::\    \
--      /:::/    /              |::|   |              /::::::\    \            /::::::\    \            /:::/    /       /::::::\    \            /:::::|   |              /::::::\    \
--     /:::/    /               |::|   |             /:::/\:::\    \          /:::/\:::\    \          /:::/    /       /:::/\:::\    \          /::::::|   |             /:::/\:::\    \
--    /:::/____/                |::|   |            /:::/__\:::\    \        /:::/__\:::\    \        /:::/    /       /:::/__\:::\    \        /:::/|::|   |            /:::/  \:::\    \
--   /::::\    \                |::|   |           /::::\   \:::\    \      /::::\   \:::\    \      /:::/    /       /::::\   \:::\    \      /:::/ |::|   |           /:::/    \:::\    \
--  /::::::\    \   _____       |::|___|______    /::::::\   \:::\    \    /::::::\   \:::\    \    /:::/    /       /::::::\   \:::\    \    /:::/  |::|   | _____    /:::/    / \:::\    \
-- /:::/\:::\    \ /\    \      /::::::::\    \  /:::/\:::\   \:::\____\  /:::/\:::\   \:::\____\  /:::/    /       /:::/\:::\   \:::\    \  /:::/   |::|   |/\    \  /:::/    /   \:::\ ___\
--/:::/  \:::\    /::\____\    /::::::::::\____\/:::/  \:::\   \:::|    |/:::/  \:::\   \:::|    |/:::/____/       /:::/  \:::\   \:::\____\/:: /    |::|   /::\____\/:::/____/     \:::|    |
--\::/    \:::\  /:::/    /   /:::/~~~~/~~      \::/    \:::\  /:::|____|\::/   |::::\  /:::|____|\:::\    \       \::/    \:::\  /:::/    /\::/    /|::|  /:::/    /\:::\    \     /:::|____|
-- \/____/ \:::\/:::/    /   /:::/    /          \/_____/\:::\/:::/    /  \/____|:::::\/:::/    /  \:::\    \       \/____/ \:::\/:::/    /  \/____/ |::| /:::/    /  \:::\    \   /:::/    /
--          \::::::/    /   /:::/    /                    \::::::/    /         |:::::::::/    /    \:::\    \               \::::::/    /           |::|/:::/    /    \:::\    \ /:::/    /
--           \::::/    /   /:::/    /                      \::::/    /          |::|\::::/    /      \:::\    \               \::::/    /            |::::::/    /      \:::\    /:::/    /
--           /:::/    /    \::/    /                        \::/____/           |::| \::/____/        \:::\    \              /:::/    /             |:::::/    /        \:::\  /:::/    /
--          /:::/    /      \/____/                          ~~                 |::|  ~|               \:::\    \            /:::/    /              |::::/    /          \:::\/:::/    /
--         /:::/    /                                                           |::|   |                \:::\    \          /:::/    /               /:::/    /            \::::::/    /
--        /:::/    /                                                            \::|   |                 \:::\____\        /:::/    /               /:::/    /              \::::/    /
--        \::/    /                                                              \:|   |                  \::/    /        \::/    /                \::/    /                \::/____/
--         \/____/                                                                \|___|                   \/____/          \/____/                  \/____/                  ~~
--


-- This is a Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

---------------------
----   IMPORTS   ----
---------------------
require("monitors")    -- Monitor configuration
require("workspaces")  -- Workspaces configuration
require("permissions") -- Permissions configuration
require("rules")       -- Window and workspace rules
require("autostart")   -- Autostart applications and commands
require("plugins")     -- Hyprland plugins configuration

---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "uwsm app -- kitty --class 'super-enter'"
local fileManager = "uwsm app -- thunar"
local menu        = "pkill wofi || uwsm app -- wofi --show drun --define=drun-print_desktop_file=true --conf /dev/null -G -p 'Type to search' -H 1044 -W 512 -x 0 -y 0 -b -i | xargs -I {} zsh -c 'uwsm app -- \"$1\" &' _ {}"

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in              = 9,
        gaps_out             = 18,

        border_size          = 0,

        col                  = {
            active_border   = { colors = { "rgba(f4bf75cc)", "rgba(8ab4f8cc)" }, angle = 45 },
            inactive_border = "rgba(272727cc)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border     = true,
        hover_icon_on_border = true,
        snap = {
            enabled = true,
            window_gap = 9,
            monitor_gap = 9
        },

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing        = false,

        layout               = "dwindle",
    },

    decoration = {
        rounding         = 9,
        rounding_power   = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 0.75,

        shadow           = {
            enabled        = true,
            -- sharp        = false,
            range          = 12,
            scale          = 3,
            render_power   = 2,
            color          = 0x54000000,
            color_inactive = 0x00000000,
        },

        blur             = {
            enabled = true,
            size    = 3,
            passes  = 3,
            noise   = 0.0234,
            popups  = true,
            special = false
        },

        dim_special      = 0.50
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
--hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.33, bezier = "almostLinear", style = "popin" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.33, bezier = "almostLinear", style = "popin" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3.33, bezier = "quick", style = "slide" })
--hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
--hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.33, bezier = "quick" })
--hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
--hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
--hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
--hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
--hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.33, bezier = "quick", style = "slide" })
--hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "slide" })
--hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3.33, bezier = "quick", style = "slide top" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"l", style =
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
        force_split = 2,       -- 0 = no force, 1 = always respect the layout's split ratio, 2 = always split in half
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
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
    cursor = {
        hide_on_key_press = true,
        sync_gsettings_theme = true,
    },
    misc = {
        force_default_wallpaper = 0,  -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
        disable_splash_rendering = true, -- If true disables the splash screen rendering
        focus_on_activate = true,
        font_family = "SF Pro",
    }
})

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout    = "us",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "",
        kb_rules     = "",

        follow_mouse = 1,

        sensitivity  = 0.6, -- -1.0 - 1.0, 0 means no modification.

        touchpad     = {
            natural_scroll = true,
            drag_lock      = 0,
            scroll_factor  = 1.0,
        },

        touchdevice  = {
            enabled = true,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.gesture({
    fingers = 3,
    direction = "down",
    action = "special",
    workspace_name = "scratchpad"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + X", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)

-- UWSM Clean session exit handling
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || uwsm stop"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd([[uwsm app -- hyprshutdown -t 'Restarting System...' --post-cmd 'systemctl reboot']]))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd([[uwsm app -- hyprshutdown -t 'Powering Off...' --post-cmd 'systemctl poweroff']]))

hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
-- Toggle standard fullscreen
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
-- Maximize (fake fullscreen that keeps gaps and allows floating windows)
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Cycle through windows with ALT + TAB
hl.bind("ALT + TAB", hl.dsp.window.cycle_next())
hl.bind("ALT + SHIFT + TAB", hl.dsp.window.cycle_next({ next = false }))

-- Move windows with mainMod + SHIFT + arrow keys
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Move windows with mainMod + mouse dragging (hyprctl flags don't use wrapper)
hl.bind(mainMod .. " + mouse:272", hl.dsp.exec_cmd("hyprctl keyword dwindle:smart split 1"), { mouse = true })
hl.bind(mainMod .. " + mouse:272", hl.dsp.exec_cmd("hyprctl keyword dwindle:smart split 0"), { release = true })

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + TAB", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.window.move({ workspace = "special:scratchpad" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute 0 toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
hl.bind("XF86Display", hl.dsp.exec_cmd("uwsm app -- nwg-displays"))

-- XF86NotificationCenter
-- XF86PickupPhone
-- XF86HangupPhone
hl.bind("XF86Favorites", hl.dsp.exec_cmd("uwsm app -- localsend"))

-- Lock screen (hyprlock has native systemd handles, but calling binary directly needs unit wrapper)
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("pidof hyprlock || uwsm app -- hyprlock -grace 0 --immediate-render"))

-- Lid switch (laptop)
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("pidof hyprlock || uwsm app -- hyprlock -grace 0 --immediate-render"))
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms on"), { locked = true })


-- Screenshots
hl.bind("PRINT", hl.dsp.exec_cmd("uwsm app -- grimblast save screen"))
hl.bind("ALT + PRINT", hl.dsp.exec_cmd("uwsm app -- grimblast save active"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("uwsm app -- grimblast copy screen"))
hl.bind("ALT + SHIFT + PRINT", hl.dsp.exec_cmd("uwsm app -- grimblast copy active"))
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("uwsm app -- grimblast save area"))
hl.bind("SUPER + SHIFT + PRINT", hl.dsp.exec_cmd("uwsm app -- grimblast copy area"))




-- wofi binds - clipboard history, run dialog
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd([[pkill wofi || sh -c "cliphist list | uwsm app -- wofi -G -p 'Clipboard history' -H 540 -W 1920 -x 0 -y 540 -b -i --dmenu --pre-display-cmd \"echo '%s' | cut -f 2\" | cliphist decode | wl-copy"]]))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("pkill wofi || uwsm app -- wofi -f --show run --run-always-parse-args -G -y 0 -x 0 -H 216 -W 512 | xargs -I {} zsh -c 'uwsm app -- \"$1\" &' _ {}"))

-- Open a tiled terminal
hl.bind(mainMod .. " + ALT + RETURN", hl.dsp.exec_cmd("uwsm app -- kitty"))


-- dunst history
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("dunstctl history-pop"))


-- show/hide waybar
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("pkill -SIGUSR1 '^waybar$'"))


-- Application binds
-- Google Chrome
hl.bind(mainMod .. " + F1", function()
    hl.dispatch(hl.dsp.focus({ workspace = 1 }))
    hl.dispatch(hl.dsp.exec_cmd("uwsm app -- google-chrome-stable"))
end)
hl.bind(mainMod .. " + ALT + F1", function()
    hl.dispatch(hl.dsp.exec_cmd("uwsm app -- google-chrome-stable --incognito"))
end)
-- Kitty terminal
hl.bind(mainMod .. " + F2", function()
    hl.dispatch(hl.dsp.focus({ workspace = 2 }))
    hl.dispatch(hl.dsp.exec_cmd("uwsm app -- kitty -1"))
end)
-- Thunar file manager
hl.bind(mainMod .. " + F3", function()
    hl.dispatch(hl.dsp.focus({ workspace = 3 }))
    hl.dispatch(hl.dsp.exec_cmd("uwsm app -- thunar"))
end)
-- VSCode
hl.bind(mainMod .. " + F4", function()
    hl.dispatch(hl.dsp.focus({ workspace = 4 }))
    hl.dispatch(hl.dsp.exec_cmd("uwsm app -- code"))
end)
-- GIMP
hl.bind(mainMod .. " + F5", function()
    hl.dispatch(hl.dsp.focus({ workspace = 5 }))
    hl.dispatch(hl.dsp.exec_cmd("uwsm app -- gimp"))
end)
-- VMware
hl.bind(mainMod .. " + F6", function()
    hl.dispatch(hl.dsp.focus({ workspace = 6 }))
    hl.dispatch(hl.dsp.exec_cmd("uwsm app -- vmware"))
end)
-- LibreOffice Writer
hl.bind(mainMod .. " + F7", function()
    hl.dispatch(hl.dsp.focus({ workspace = 7 }))
    hl.dispatch(hl.dsp.exec_cmd("uwsm app -- libreoffice --writer"))
end)
-- PrusaSlicer
hl.bind(mainMod .. " + F8", function()
    hl.dispatch(hl.dsp.focus({ workspace = 8 }))
    hl.dispatch(hl.dsp.exec_cmd("uwsm app -- env GTK_THEME=Adwaita:dark prusa-slicer"))
end)

-- rtorrent
hl.bind(mainMod .. " + T", function()
    hl.dispatch(hl.dsp.focus({ workspace = "special:scratchpad" }))
    hl.dispatch(hl.dsp.exec_cmd("/home/ron/.bin/startrt && uwsm app -- kitty -1 --class 'scratchpad' -e '/home/ron/.bin/chkrt'"))
end)

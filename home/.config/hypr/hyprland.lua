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
-- /:::/  \:::\    /::\____\    /::::::::::\____\/:::/  \:::\   \:::|    |/:::/  \:::\   \:::|    |/:::/____/       /:::/  \:::\   \:::\____\/:: /    |::|   /::\____\/:::/____/     \:::|    |
-- \::/    \:::\  /:::/    /   /:::/~~~~/~~      \::/    \:::\  /:::|____|\::/   |::::\  /:::|____|\:::\    \       \::/    \:::\  /:::/    /\::/    /|::|  /:::/    /\:::\    \     /:::|____|
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
---------------------
----   IMPORTS   ----
---------------------
require("monitors")
require("workspaces")
require("permissions")
require("rules")
require("autostart")
require("plugins")
require("functions")

---------------------------------
---- VARIABLES & HELPERS     ----
---------------------------------
local mainMod     = "SUPER"
local terminal    = "uwsm app -- kitty --class 'super-enter'"
local fileManager = "uwsm app -- thunar"
local menu        = "uwsm app -- walker"

----------------------------------------
---- GLOBAL CONFIGURATION BATCHING  ----
----------------------------------------
hl.config({
    general    = {
        gaps_in              = 9,
        gaps_out             = { top = 18, left = 18, right = 18, bottom = 18 },
        border_size          = 0,
        col                  = {
            active_border   = "rgba(00000000)",
            inactive_border = "rgba(00000000)",
        },
        resize_on_border     = true,
        hover_icon_on_border = true,
        snap                 = { enabled = true, window_gap = 9, monitor_gap = 9 },
        allow_tearing        = false,
        layout               = "dwindle",
    },
    decoration = {
        rounding         = 9,
        rounding_power   = 2,
        active_opacity   = 1.0,
        inactive_opacity = 0.90,
        dim_inactive     = false,
        shadow           = {
            enabled        = true,
            range          = 24,         -- Balanced spread for performance
            scale          = 0.97,
            render_power   = 3,
            color          = 0x77000000,
            color_inactive = 0x22000000,
            offset         = "0 12",
        },
        dim_special      = 0.1,
        blur             = {
            enabled = true,
            size = 3,
            passes = 2,                 -- Reduced pass count for GPU efficiency
            noise = 0.0234,
            popups = true,
            special = true
        },
    },
    animations = { enabled = true },
    dwindle    = { preserve_split = true, force_split = 2 },
    master     = { new_status = "master" },
    scrolling  = { fullscreen_on_one_column = true },
    cursor     = { hide_on_key_press = true, sync_gsettings_theme = true },
    misc       = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        focus_on_activate        = true,
        font_family              = "SF Pro",
    },
    input      = {
        kb_layout    = "us",
        follow_mouse = 1,
        sensitivity  = 0.6,
        touchpad     = { natural_scroll = true, drag_lock = 0, scroll_factor = 1.0 },
        touchdevice  = { enabled = true },
    }
})

-----------------------
----  ANIMATIONS   ----
-----------------------
hl.curve("fluentDecel", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.0 } } })
hl.curve("fluentAccel", { type = "bezier", points = { { 0.3, 0.0 }, { 0.8, 0.15 } } })
hl.curve("oneGravity", { type = "bezier", points = { { 0.333, 0.0 }, { 0.667, 0.333 } } })
hl.curve("snap", { type = "bezier", points = { { 0.1, 1.0 }, { 0.1, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 3.5, bezier = "fluentDecel" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.95, bezier = "oneGravity", style = "slide fade" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 1.5, bezier = "snap", style = "popin 85%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.5, bezier = "fluentAccel", style = "popin 15%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 1.5, bezier = "snap" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 1.89, bezier = "oneGravity", style = "slide top fade" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 1.89, bezier = "oneGravity", style = "slide top fade" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "fluentDecel" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 3, bezier = "fluentDecel" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2.5, bezier = "fluentAccel" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 3, bezier = "fluentDecel" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2.5, bezier = "fluentAccel" })

-----------------------------
---- CUSTOM ACTIONS/GESTURES ----
-----------------------------
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down", action = "special", workspace_name = "scratchpad" })
hl.gesture({
    fingers = 3,
    direction = "up",
    action = function()
        if hl.plugin.hymission ~= nil then
            hl.plugin.hymission.toggle()
        end
    end
})

---------------------
---- KEYBINDINGS ----
---------------------

-- System & Power
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + SHIFT + X",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || uwsm stop"))
hl.bind(mainMod .. " + SHIFT + R",
    hl.dsp.exec_cmd([[uwsm app -- hyprshutdown -t 'Restarting System...' --post-cmd 'systemctl reboot']]))
hl.bind(mainMod .. " + SHIFT + P",
    hl.dsp.exec_cmd([[uwsm app -- hyprshutdown -t 'Powering Off...' --post-cmd 'systemctl poweroff']]))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("systemctl suspend"))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("dunstctl history-pop"))

-- Lid Switches
hl.bind("switch:off:Lid Switch", hl.dsp.dpms({ action = "enable" }), { locked = true })
hl.bind("switch:on:Lid Switch", function()
    hl.dispatch(hl.dsp.exec_cmd("loginctl lock-session"))
    hl.timer(function()
        hl.dispatch(hl.dsp.dpms({ action = "disable" }))
    end, { timeout = 500, type = "oneshot" })
end, { locked = true })

-- Core Launchers
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + ALT + RETURN", hl.dsp.exec_cmd("uwsm app -- kitty"))
hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd("uwsm app -- kitty --class 'super-shift-enter'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))

-- Window Management
hl.bind(mainMod .. " + X", hl.dsp.window.close())
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

-- Window Focus & Movement
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Mouse Window Management
hl.bind(mainMod .. " + mouse:272", hl.dsp.exec_cmd("hyprctl keyword dwindle:smart split 1"), { mouse = true })
hl.bind(mainMod .. " + mouse:272", hl.dsp.exec_cmd("hyprctl keyword dwindle:smart split 0"), { release = true })
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + GRAVE", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mainMod .. " + SHIFT + GRAVE", hl.dsp.window.move({ workspace = "special:scratchpad" }))

-- Rebound Tab Actions
hl.bind("ALT + TAB", hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + TAB", function()
    if hl.plugin.hymission ~= nil then
        hl.plugin.hymission.toggle()
    end
end)

hl.bind(mainMod .. " + Next", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + Prior", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Hardware & Media
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute 0 toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
hl.bind("XF86Display", hl.dsp.exec_cmd("uwsm app -- nwg-displays"))
hl.bind("XF86Favorites", hl.dsp.exec_cmd("uwsm app -- localsend"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("pkill -SIGUSR1 '^waybar$'"))

-- Screenshots
hl.bind("PRINT", hl.dsp.exec_cmd("uwsm app -- grimblast save screen"))
hl.bind("ALT + PRINT", hl.dsp.exec_cmd("uwsm app -- grimblast save active"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("uwsm app -- grimblast copy screen"))
hl.bind("ALT + SHIFT + PRINT", hl.dsp.exec_cmd("uwsm app -- grimblast copy active"))
hl.bind("XF86SelectiveScreenshot", hl.dsp.exec_cmd("uwsm app -- grimblast save area"))
hl.bind("SHIFT + XF86SelectiveScreenshot", hl.dsp.exec_cmd("uwsm app -- grimblast copy area"))

-- Applications
local function run_in_ws(ws, cmd)
    return function()
        hl.dispatch(hl.dsp.focus({ workspace = ws }))
        hl.dispatch(hl.dsp.exec_cmd("uwsm app -- " .. cmd))
    end
end
hl.bind(mainMod .. " + F1", run_in_ws(1, "google-chrome-stable"))
hl.bind(mainMod .. " + ALT + F1", hl.dsp.exec_cmd("uwsm app -- google-chrome-stable --incognito"))
hl.bind(mainMod .. " + F2", run_in_ws(2, "kitty -1"))
hl.bind(mainMod .. " + F3", run_in_ws(3, "thunar"))
hl.bind(mainMod .. " + F4", run_in_ws(4, "code"))
hl.bind(mainMod .. " + F5", run_in_ws(5, "gimp"))
hl.bind(mainMod .. " + F6", run_in_ws(6, "vmware"))
hl.bind(mainMod .. " + F7", run_in_ws(7, "libreoffice --writer"))
hl.bind(mainMod .. " + F8", run_in_ws(8, "env GTK_THEME=Adwaita:dark prusa-slicer"))
hl.bind(mainMod .. " + T", function()
    hl.dispatch(hl.dsp.focus({ workspace = "special:scratchpad" }))
    hl.dispatch(hl.dsp.exec_cmd(
        "/home/ron/.bin/startrt && uwsm app -- kitty -1 --class 'scratchpad' -e '/home/ron/.bin/chkrt'"))
end)
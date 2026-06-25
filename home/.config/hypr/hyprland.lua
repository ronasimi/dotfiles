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
---------------------
----   IMPORTS   ----
---------------------
require("monitors")
require("workspaces")
require("permissions")
require("rules")
require("autostart")
require("plugins")
require("scripts")

---------------------
---- MY PROGRAMS ----
---------------------
local terminal    = "uwsm app -- kitty --class 'super-enter'"
local fileManager = "uwsm app -- thunar"
local menu        =
"pkill wofi || uwsm app -- wofi --show drun --define=drun-print_desktop_file=true --conf /dev/null -G -p 'Type to search' -H 1026 -W 512 -x 0 -y 9 -b -i | xargs -I {} dash -c 'uwsm app -- \"$1\" &' _ {}"

----------------------------------------
---- GLOBAL CONFIGURATION BATCHING  ----
----------------------------------------
-- Batched into a single API call for faster initialization
hl.config({
    general    = {
        gaps_in              = 9,
        gaps_out             =  {top = 9, left = 18, right = 18, bottom = 18},
        border_size          = 0,
        col                  = {
            active_border   = { colors = { "rgba(f4bf75cc)", "rgba(8ab4f8cc)" }, angle = 45 },
            inactive_border = "rgba(272727cc)",
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
        shadow           = {
            enabled        = true,
            range          = 30,
            scale          = 1.0,
            render_power   = 3,
            color          = 0x66000000,
            color_inactive = 0x22000000,
            offset         = "0 8",
        },
        blur             = { enabled = true, size = 3, passes = 3, noise = 0.0234, popups = false, special = false },
        dim_special      = 0.50
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
-- Fluent curves: extremely aggressive initial acceleration, long smooth tail
hl.curve("fluentDecel", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.0 } } })
hl.curve("fluentAccel", { type = "bezier", points = { { 0.3, 0.0 }, { 0.8, 0.15 } } })

-- Slightly softened spring: allows the motion to be seen a fraction longer
hl.curve("fluentSpring", { type = "spring", mass = 1, stiffness = 250, dampening = 30 })

-- Global fallback
hl.animation({ leaf = "global", enabled = true, speed = 3.5, bezier = "fluentDecel" })

-- Window Mechanics
-- In: 350ms, giving the pop-in a smooth, visible expansion
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.5, bezier = "fluentDecel", style = "popin 85%" })
-- Out: 300ms, still slightly faster than the entrance to keep the UI feeling responsive
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "fluentAccel", style = "popin 85%" })
-- Move: 350ms, a highly perceptible, smooth glide across the screen
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3.5, bezier = "fluentDecel" })

-- Workspaces
-- 450ms: Full-screen transitions benefit from a longer duration to prevent spatial disorientation
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.5, bezier = "fluentDecel", style = "slide" })

-- Scratchpad
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 4, spring = "fluentSpring", style = "slide top" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 3.5, bezier = "fluentAccel", style = "slide top" })

-- Fades
hl.animation({ leaf = "fadeIn", enabled = true, speed = 3, bezier = "fluentDecel" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2.5, bezier = "fluentAccel" })

-- Borders and Layers
hl.animation({ leaf = "border", enabled = true, speed = 4, bezier = "fluentDecel" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3.5, bezier = "fluentDecel", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 3, bezier = "fluentAccel", style = "fade" })

-------------------
---- GESTURES  ----
-------------------
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down", action = "special", workspace_name = "scratchpad" })
-- Wofi Window Switcher
hl.gesture({ fingers = 3, direction = "up", action = function() hl.exec_cmd(
    "pkill -SIGUSR1 hyprexpose &") end })

---------------------
---- KEYBINDINGS ----
---------------------
local mainMod = "SUPER"

-- Core
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + X", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + X",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || uwsm stop"))
hl.bind(mainMod .. " + SHIFT + R",
    hl.dsp.exec_cmd([[uwsm app -- hyprshutdown -t 'Restarting System...' --post-cmd 'systemctl reboot']]))
hl.bind(mainMod .. " + SHIFT + P",
    hl.dsp.exec_cmd([[uwsm app -- hyprshutdown -t 'Powering Off...' --post-cmd 'systemctl poweroff']]))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("systemctl suspend"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

-- Focus and Window Movement
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind("ALT + TAB", hl.dsp.exec_cmd( "pkill -SIGUSR1 hyprexpose &" ))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Mouse
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
hl.bind(mainMod .. " + TAB", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.window.move({ workspace = "special:scratchpad" }))
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

-- Lock and Lid
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms off && loginctl lock-session"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms on"), { locked = true })

-- Screenshots
hl.bind("PRINT", hl.dsp.exec_cmd("uwsm app -- grimblast save screen"))
hl.bind("ALT + PRINT", hl.dsp.exec_cmd("uwsm app -- grimblast save active"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("uwsm app -- grimblast copy screen"))
hl.bind("ALT + SHIFT + PRINT", hl.dsp.exec_cmd("uwsm app -- grimblast copy active"))
hl.bind("XF86SelectiveScreenshot", hl.dsp.exec_cmd("uwsm app -- grimblast save area"))
hl.bind("SHIFT + XF86SelectiveScreenshot", hl.dsp.exec_cmd("uwsm app -- grimblast copy area"))

-- Utilities
hl.bind(mainMod .. " + C",
    hl.dsp.exec_cmd(
    [[pkill wofi || dash -c "cliphist list | sed 's/^[0-9]*\t//' | uwsm app -- wofi --style ~/.config/wofi/style-clipboard.css -G -p 'Clipboard history' -H 540 -W 1902 -x 9 -y 540 -b -i --dmenu | cliphist decode | wl-copy"]]))
hl.bind(mainMod .. " + R",
    hl.dsp.exec_cmd(
    "pkill wofi || uwsm app -- wofi -f --show run --run-always-parse-args -G -y 0 -x 0 -H 216 -W 512 | xargs -I {} dash -c 'uwsm app -- \"$1\" &' _ {}"))
hl.bind(mainMod .. " + ALT + RETURN", hl.dsp.exec_cmd("uwsm app -- kitty"))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("dunstctl history-pop"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("pkill -SIGUSR1 '^waybar$'"))

--------------------------
-- Application Bindings --
--------------------------
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

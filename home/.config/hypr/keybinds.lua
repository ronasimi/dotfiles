---------------------
---- VARIABLES   ----
---------------------
local mainMod     = "SUPER"
local terminal    = "uwsm app -- kitty --class 'super-enter'"
local fileManager = "uwsm app -- thunar"
local menu        = "uwsm app -- walker"

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


---------------------------------
---- HYPRGRASS TOUCH GESTURES ----
---------------------------------
if hl.plugin.hyprgrass ~= nil then
    -- 3-Finger Horizontal Swipe: Switch Workspaces
    hl.plugin.hyprgrass.gesture({
        pattern = { kind = "swipe", fingers = 3, direction = "horizontal" },
        action = "workspace",
    })
    
    -- 3-Finger Swipe Down: Toggle Scratchpad
    hl.plugin.hyprgrass.gesture({
        pattern = { kind = "swipe", fingers = 3, direction = "down" },
        action = function()
            hl.dispatch(hl.dsp.workspace.toggle_special("scratchpad"))
        end,
    })
    
    -- 3-Finger Swipe Up: Toggle Hymission Overview
    hl.plugin.hyprgrass.gesture({
        pattern = { kind = "swipe", fingers = 3, direction = "up" },
        action = function()
            if hl.plugin.hymission ~= nil then
                hl.plugin.hymission.toggle()
            end
        end,
    })

    ---------------------------------
    ---- OPTIONAL: EDGE SWIPES   ----
    ---------------------------------
    -- Swipe down from top edge: Toggle Overview (Hymission)
    hl.plugin.hyprgrass.gesture({
        pattern = { kind = "edge", origin = "u", direction = "d" },
        action = function()
            if hl.plugin.hymission ~= nil then
                hl.plugin.hymission.toggle()
            end
        end,
    })
    
    -- Swipe up from bottom edge: Toggle Scratchpad
    hl.plugin.hyprgrass.gesture({
        pattern = { kind = "edge", origin = "d", direction = "u" },
        action = function()
            hl.dispatch(hl.dsp.workspace.toggle_special("scratchpad"))
        end,
    })
end

---------------------
---- KEYBINDINGS ----
---------------------

-- System & Power
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || uwsm stop"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd([[hyprshutdown -t 'Restarting System...' --post-cmd 'systemctl reboot']]))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd([[hyprshutdown -t 'Powering Off...' --post-cmd 'systemctl poweroff']]))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("systemctl suspend"))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("dunstctl history-pop"))

-- Lid Switches
hl.bind("switch:off:Lid Switch", hl.dsp.dpms({ action = "enable" }), { locked = true })
hl.bind("switch:on:Lid Switch", function()
    -- Always trigger the lock; flock in hypridle will handle deduplication
    hl.dispatch(hl.dsp.exec_cmd("loginctl lock-session"))
    
    -- Turn off screen manually (crucial for AC power state where systemd ignores the lid)
    hl.timer(function()
        hl.dispatch(hl.dsp.dpms({ action = "disable" }))
    end, { timeout = 800, type = "oneshot" })
end, { locked = true })

-- Core Launchers
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + ALT + RETURN", hl.dsp.exec_cmd("uwsm app -- kitty"))
hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd("uwsm app -- kitty --class 'super-shift-enter'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("uwsm app -- hyprland-run"))

-- Window Management
hl.bind(mainMod .. " + X", hl.dsp.window.close())
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pin())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

-- Layout Toggle
local current_layout = "dwindle"
hl.bind(mainMod .. " + J", function()
    current_layout = (current_layout == "master") and "dwindle" or "master"
    hl.dispatch(hl.dsp.exec_cmd("hyprctl keyword general:layout " .. current_layout))
end)

-- Window Focus & Movement
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

hl.bind(mainMod .. " + SLASH", hl.dsp.layout("togglesplit"))

-- Directional Split Preselect Binds
hl.bind(mainMod .. " + ALT + left", function() preselect_with_border("l", 0) end)
hl.bind(mainMod .. " + ALT + right", function() preselect_with_border("r", 180) end)
hl.bind(mainMod .. " + ALT + up", function() preselect_with_border("u", 90) end)
hl.bind(mainMod .. " + ALT + down", function() preselect_with_border("d", 270) end)

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
    hl.dispatch(hl.dsp.exec_cmd("/home/ron/.bin/starttilde && uwsm app -- kitty -1 --class 'scratchpad' -e '/home/ron/.bin/chktilde'"))
end)
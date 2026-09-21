---------------------
---- VARIABLES   ----
---------------------
local mainMod     = "SUPER"
local terminal    = "uwsm app -- kitty --class 'super-enter'"
local fileManager = "uwsm app -- thunar"
local menu        = "uwsm app -- walker"
local fx          = __require("functions")

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
    end,
})

-- Native 2-finger pinch zoom follows the cursor. Keyboard zoom binds below
-- provide precise step/toggle control as well.
hl.gesture({ fingers = 2, direction = "pinch", action = "cursor_zoom", zoom_level = 1, mode = "live" })

---------------------------------
---- HYPRGRASS TOUCH GESTURES ----
---------------------------------
if hl.plugin.hyprgrass ~= nil then
    hl.plugin.hyprgrass.gesture({
        pattern = { kind = "swipe", fingers = 3, direction = "horizontal" },
        action = "workspace",
    })

    hl.plugin.hyprgrass.gesture({
        pattern = { kind = "swipe", fingers = 3, direction = "down" },
        action = function()
            hl.dispatch(hl.dsp.workspace.toggle_special("scratchpad"))
        end,
    })

    hl.plugin.hyprgrass.gesture({
        pattern = { kind = "swipe", fingers = 3, direction = "up" },
        action = function()
            if hl.plugin.hymission ~= nil then
                hl.plugin.hymission.toggle()
            end
        end,
    })

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
    hl.dispatch(hl.dsp.exec_cmd("loginctl lock-session"))
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
hl.bind(mainMod .. " + SPACE", fx.toggle_floating)
hl.bind(mainMod .. " + P", hl.dsp.window.pin())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

-- Focus the opposite window mode (i3-style focus mode_toggle)
hl.bind(mainMod .. " + CTRL + SPACE", fx.focus_other_mode)

-- Minimize/restore using a tagged hidden special workspace.
hl.bind(mainMod .. " + N", fx.minimize_active)
hl.bind(mainMod .. " + SHIFT + N", fx.restore_minimized)

-- Urgent window if one exists, otherwise the last-focused window.
hl.bind(mainMod .. " + U", fx.focus_urgent_or_last)

-- Dwindle <-> Master without spawning hyprctl.
hl.bind(mainMod .. " + J", fx.toggle_primary_layout)

-- Layout-aware actions: same key does useful native work in each tiled layout.
hl.bind(mainMod .. " + A", fx.layout_action({
    scrolling = hl.dsp.layout("swapcol l"),
    dwindle   = hl.dsp.layout("swapsplit"),
    monocle   = hl.dsp.layout("cycleprev"),
    master    = hl.dsp.layout("cycleprev"),
}))

hl.bind(mainMod .. " + SHIFT + A", fx.layout_action({
    scrolling = hl.dsp.layout("swapcol r"),
    dwindle   = hl.dsp.layout("togglesplit"),
    monocle   = hl.dsp.layout("cyclenext"),
    master    = hl.dsp.layout("cyclenext"),
}))

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
hl.bind(mainMod .. " + ALT + left", function() fx.preselect_with_border("l", 0) end)
hl.bind(mainMod .. " + ALT + right", function() fx.preselect_with_border("r", 180) end)
hl.bind(mainMod .. " + ALT + up", function() fx.preselect_with_border("u", 90) end)
hl.bind(mainMod .. " + ALT + down", function() fx.preselect_with_border("d", 270) end)

-- Smart mouse window management. SUPER+LMB tears a tiled window out to float;
-- dragging an already-floating (non-pinned) window reinserts it into tiling.
-- A click without a real drag changes nothing.
-- Same-key binds execute in declaration order: capture/toggle state first,
-- then let Hyprland own the interactive mouse move. Release handlers decide
-- whether this was a click or a real drag using binds.drag_threshold.
hl.bind(mainMod .. " + mouse:272", fx.smart_drag_begin)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:272", fx.smart_drag_click_end, { mouse = true, click = true })
hl.bind(mainMod .. " + mouse:272", fx.smart_drag_drag_end, { mouse = true, drag = true })
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

-- Cursor zoom
hl.bind(mainMod .. " + Z", fx.zoom)
hl.bind(mainMod .. " + equal", function() fx.zoom(0.25) end, { repeating = true })
hl.bind(mainMod .. " + minus", function() fx.zoom(-0.25) end, { repeating = true })

-- Toggle compositor-native smart gaps. Smart gaps are OFF at startup and
-- collapse gaps/rounding only when a regular workspace has one visible tiled
-- window.
hl.bind(mainMod .. " + CTRL + G", fx.toggle_smart_gaps)

-- Toggle blur/shadows/animations for battery or low-latency use. The previous
-- values are snapshotted and restored rather than assuming hard-coded defaults.
hl.bind(mainMod .. " + CTRL + B", fx.toggle_performance_mode)

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

-- Context-sensitive scratchpad: reuse an existing scratchpad terminal instead
-- of spawning a duplicate every time.
hl.bind(mainMod .. " + T", fx.toggle_terminal_scratchpad)

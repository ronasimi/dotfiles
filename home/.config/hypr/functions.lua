-----------------------------
---- HYPRLAND UTILITIES  ----
-----------------------------

local M = {}

-- Shared geometry. Waybar is 36px high; utility windows keep another 9px gap.
local WAYBAR_HEIGHT = 36
local EDGE_GAP = 9
local UTILITY_TOP = WAYBAR_HEIGHT + EDGE_GAP
local utility_windows = {}

-- Export the placement constants so rules or future helpers can opt into the
-- same geometry without repeating magic numbers.
M.utility_geometry = {
    waybar_height = WAYBAR_HEIGHT,
    edge_gap = EDGE_GAP,
    top = UTILITY_TOP,
}

local function notify(text, icon)
    hl.notification.create({
        text = text,
        timeout = 1800,
        icon = icon or "info",
    })
end

local function monitor_logical_size(mon)
    if not mon then
        return nil, nil
    end

    -- Current Hyprland exposes the monitor's logical size as mode.width/height.
    -- Fall back to pixel size / scale for compatibility with older Lua objects.
    if mon.mode and mon.mode.width and mon.mode.height then
        return math.floor(mon.mode.width), math.floor(mon.mode.height)
    end

    local scale = mon.scale or 1
    return math.floor(mon.width / scale), math.floor(mon.height / scale)
end

local function has_tag(window, tag)
    if not window or not window.tags then
        return false
    end

    for _, value in ipairs(window.tags) do
        if value == tag or value == (tag .. "*") then
            return true
        end
    end

    return false
end

---------------------------------
---- WAYBAR EDGE AUTO-HIDE   ----
---------------------------------

local is_waybar_visible = false

-- Show when entering the upper edge; hide after leaving the bar's 36px region.
-- Keep a reference to the timer for the lifetime of this module.
M._waybar_hover_timer = hl.timer(function()
    local pos = hl.get_cursor_pos()
    if not pos then
        return
    end

    -- Use monitor-local Y so edge reveal also works with vertically offset
    -- multi-monitor layouts.
    local mon = hl.get_monitor_at_cursor()
    local local_y = pos.y - ((mon and mon.y) or 0)

    if local_y <= (EDGE_GAP * 2) and not is_waybar_visible then
        is_waybar_visible = true
        hl.dispatch(hl.dsp.exec_cmd("pkill -SIGUSR1 '^waybar$'"))
    elseif local_y > WAYBAR_HEIGHT and is_waybar_visible then
        is_waybar_visible = false
        hl.dispatch(hl.dsp.exec_cmd("pkill -SIGUSR1 '^waybar$'"))
    end
end, { timeout = 150, type = "repeat" })

---------------------------------------------------------
---- MONITOR-AWARE FLOATING / UTILITY WINDOW HELPERS ----
---------------------------------------------------------

-- Register a floating utility window. Positioning is monitor-local at rule time
-- and is also recalculated after monitor hotplug/layout changes.
-- Supported anchors: top-right, top-left, bottom-right, bottom-left,
-- bottom-stretch, center.
function M.register_utility_window(opts)
    local spec = {
        class = assert(opts.class, "utility window requires class"),
        classes = opts.classes or { opts.class },
        width = opts.width,
        height = opts.height,
        anchor = opts.anchor or "top-right",
        top = opts.top or UTILITY_TOP,
        right = opts.right or EDGE_GAP,
        bottom = opts.bottom or EDGE_GAP,
        left = opts.left or EDGE_GAP,
        pin = opts.pin ~= false,
        opacity = opts.opacity,
        no_shadow = opts.no_shadow,
    }

    table.insert(utility_windows, spec)

    local size
    local move

    if spec.anchor == "top-right" then
        size = { spec.width, spec.height }
        move = { "monitor_w-window_w-" .. spec.right, spec.top }
    elseif spec.anchor == "top-left" then
        size = { spec.width, spec.height }
        move = { spec.left, spec.top }
    elseif spec.anchor == "bottom-right" then
        size = { spec.width, spec.height }
        move = { "monitor_w-window_w-" .. spec.right, "monitor_h-window_h-" .. spec.bottom }
    elseif spec.anchor == "bottom-left" then
        size = { spec.width, spec.height }
        move = { spec.left, "monitor_h-window_h-" .. spec.bottom }
    elseif spec.anchor == "bottom-stretch" then
        size = { "monitor_w-" .. (spec.left + spec.right), spec.height }
        move = { spec.left, "monitor_h-window_h-" .. spec.bottom }
    elseif spec.anchor == "center" then
        size = { spec.width, spec.height }
        move = { "(monitor_w-window_w)/2", "(monitor_h-window_h)/2" }
    else
        error("unknown utility window anchor: " .. tostring(spec.anchor))
    end

    local rule = {
        name = opts.name,
        match = { class = spec.class },
        float = true,
        pin = spec.pin,
        size = size,
        move = move,
    }

    if spec.opacity ~= nil then
        rule.opacity = spec.opacity
    end
    if spec.no_shadow ~= nil then
        rule.no_shadow = spec.no_shadow
    end

    return hl.window_rule(rule)
end

local function geometry_for_utility(window, spec)
    local mon = window and window.monitor or nil
    if not mon then
        mon = hl.get_active_monitor()
    end
    if not mon then
        return nil
    end

    local mw, mh = monitor_logical_size(mon)
    if not mw or not mh then
        return nil
    end

    local width = spec.width or (window.size and window.size.x) or 640
    local height = spec.height or (window.size and window.size.y) or 480

    if spec.anchor == "bottom-stretch" then
        width = math.max(1, mw - spec.left - spec.right)
    end

    local x
    local y

    if spec.anchor == "top-right" then
        x = mon.x + mw - width - spec.right
        y = mon.y + spec.top
    elseif spec.anchor == "top-left" then
        x = mon.x + spec.left
        y = mon.y + spec.top
    elseif spec.anchor == "bottom-right" then
        x = mon.x + mw - width - spec.right
        y = mon.y + mh - height - spec.bottom
    elseif spec.anchor == "bottom-left" or spec.anchor == "bottom-stretch" then
        x = mon.x + spec.left
        y = mon.y + mh - height - spec.bottom
    elseif spec.anchor == "center" then
        x = mon.x + math.floor((mw - width) / 2)
        y = mon.y + math.floor((mh - height) / 2)
    else
        return nil
    end

    return {
        x = math.floor(x),
        y = math.floor(y),
        width = math.floor(width),
        height = math.floor(height),
    }
end

local function reflow_window(window, spec)
    if not window or not window.mapped then
        return
    end

    local geo = geometry_for_utility(window, spec)
    if not geo then
        return
    end

    hl.dispatch(hl.dsp.window.resize({
        window = window,
        x = geo.width,
        y = geo.height,
        relative = false,
    }))
    hl.dispatch(hl.dsp.window.move({
        window = window,
        x = geo.x,
        y = geo.y,
        relative = false,
    }))
end

function M.reflow_utility_windows()
    for _, spec in ipairs(utility_windows) do
        for _, class_name in ipairs(spec.classes) do
            local windows = hl.get_windows({ class = class_name })
            for _, window in ipairs(windows) do
                reflow_window(window, spec)
            end
        end
    end
end

local utility_reflow_timer = nil

local function schedule_utility_reflow()
    -- Holding the timer object guarantees it survives until the one-shot runs.
    -- Replacing it also naturally debounces bursts of monitor-layout events.
    utility_reflow_timer = hl.timer(function()
        M.reflow_utility_windows()
        utility_reflow_timer = nil
    end, { timeout = 100, type = "oneshot" })
end

local function utility_spec_for_window(window)
    if not window then
        return nil
    end

    for _, spec in ipairs(utility_windows) do
        for _, class_name in ipairs(spec.classes) do
            if window.class == class_name then
                return spec
            end
        end
    end

    return nil
end

-- Re-anchor utility windows after their opening size settles, and whenever
-- monitor geometry changes.
hl.on("window.open", function(window)
    if utility_spec_for_window(window) then
        schedule_utility_reflow()
    end
end)

hl.on("window.class", function(window)
    if utility_spec_for_window(window) then
        schedule_utility_reflow()
    end
end)

hl.on("monitor.added", schedule_utility_reflow)
hl.on("monitor.removed", schedule_utility_reflow)
hl.on("monitor.layout_changed", schedule_utility_reflow)
hl.on("config.reloaded", schedule_utility_reflow)

------------------------------------------------------------
---- DWINDLE SPLIT PREVIEW / BORDER STATE                ----
------------------------------------------------------------

local split_preview_active = false

function M.reset_border_state()
    if not split_preview_active then
        return
    end

    split_preview_active = false
    hl.config({
        general = {
            border_size = 0,
            col = { active_border = "rgba(00000000)" },
        }
    })
end

function M.preselect_with_border(direction, angle)
    local window = hl.get_active_window()
    if not window or window.floating then
        return
    end

    hl.dispatch(hl.dsp.layout("preselect " .. direction))
    split_preview_active = true

    hl.config({
        general = {
            border_size = 1,
            col = {
                active_border = {
                    colors = { "#8ab4f8ff", "#27272773" },
                    angle = angle,
                },
            },
        }
    })
end

hl.on("window.open", M.reset_border_state)
hl.on("window.active", M.reset_border_state)
hl.on("workspace.active", M.reset_border_state)

-------------------------------------------
---- NATIVE SUPER + DRAG TILED MOVE     ----
-------------------------------------------

-- Keep the user's normal Dwindle settings untouched at rest. During a mouse
-- move, temporarily enable the two pointer-aware placement options so a tiled
-- window is reinserted according to where it is released. No float/tile state
-- transition is performed here; hl.dsp.window.drag() owns the actual move.
function M.tiled_drag_begin()
    hl.config({
        dwindle = {
            smart_split = true,
            precise_mouse_move = true,
        }
    })
end

function M.tiled_drag_end()
    hl.config({
        dwindle = {
            smart_split = false,
            precise_mouse_move = false,
        }
    })
end

-------------------------------------------
---- FOCUS HELPERS                     ----
-------------------------------------------

function M.focus_other_mode()
    local window = hl.get_active_window()
    if not window then
        return
    end

    hl.dispatch(hl.dsp.window.cycle_next({ floating = not window.floating }))
end

function M.focus_urgent_or_last()
    hl.dispatch(hl.dsp.focus({ urgent_or_last = true }))
end

-------------------------------------------
---- MINIMIZE / RESTORE                ----
-------------------------------------------

local minimize_stack = {}

function M.minimize_active()
    local window = hl.get_active_window()
    if not window then
        return
    end

    if window.pinned then
        notify("Pinned windows cannot be minimized", "warn")
        return
    end

    if has_tag(window, "minimized") then
        return
    end

    table.insert(minimize_stack, window)
    hl.dispatch(hl.dsp.window.tag({ window = window, tag = "+minimized" }))
    hl.dispatch(hl.dsp.window.move({
        window = window,
        workspace = "special:minimized",
        follow = false,
    }))
end

function M.restore_minimized()
    local window = nil

    while #minimize_stack > 0 and not window do
        local candidate = table.remove(minimize_stack)
        if candidate and candidate.mapped and has_tag(candidate, "minimized") then
            window = candidate
        end
    end

    if not window then
        local minimized = hl.get_windows({ tag = "minimized" })
        window = minimized[1]
    end

    if not window then
        notify("No minimized windows", "info")
        return
    end

    local workspace = hl.get_active_workspace()
    if not workspace then
        return
    end

    hl.dispatch(hl.dsp.window.move({
        window = window,
        workspace = workspace,
        follow = false,
    }))
    hl.dispatch(hl.dsp.window.tag({ window = window, tag = "-minimized" }))
    hl.dispatch(hl.dsp.focus({ window = window }))
end

-------------------------------------------
---- CURSOR ZOOM                       ----
-------------------------------------------

local MIN_ZOOM = 1.0
local MAX_ZOOM = 3.0
local ZOOM_TOGGLE_FACTOR = 1.5

function M.zoom(offset)
    local current = hl.get_config("cursor.zoom_factor") or MIN_ZOOM

    if offset ~= nil then
        current = current + offset
    elseif current ~= MIN_ZOOM then
        current = MIN_ZOOM
    else
        current = ZOOM_TOGGLE_FACTOR
    end

    current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
    hl.config({ cursor = { zoom_factor = current } })
end

-------------------------------------------
---- PERFORMANCE / BATTERY MODE        ----
-------------------------------------------

local performance_snapshot = nil

function M.toggle_performance_mode()
    if performance_snapshot then
        hl.config({
            animations = { enabled = performance_snapshot.animations },
            decoration = {
                blur = { enabled = performance_snapshot.blur },
                shadow = { enabled = performance_snapshot.shadow },
            },
        })
        performance_snapshot = nil
        notify("Visual effects restored", "ok")
        return
    end

    performance_snapshot = {
        animations = hl.get_config("animations.enabled"),
        blur = hl.get_config("decoration.blur.enabled"),
        shadow = hl.get_config("decoration.shadow.enabled"),
    }

    hl.config({
        animations = { enabled = false },
        decoration = {
            blur = { enabled = false },
            shadow = { enabled = false },
        },
    })
    notify("Performance mode: effects disabled", "info")
end

-------------------------------------------
---- TILDE SCRATCHPAD                  ----
-------------------------------------------

local TILDE_CLASS = "scratchpad"
local TILDE_WORKSPACE = "special:scratchpad"
local TILDE_COMMAND = "/home/ron/.bin/starttilde && uwsm app -- kitty -1 --class 'scratchpad' -e '/home/ron/.bin/chktilde'"

function M.toggle_tilde()
    local windows = hl.get_windows({ class = TILDE_CLASS })

    if #windows == 0 then
        -- Open the special workspace first so the terminal appears immediately
        -- when the process creates its window. Avoid toggling it closed in the
        -- unusual case that the empty scratchpad workspace is already visible.
        local active_special = hl.get_active_special_workspace()
        if not active_special or active_special.addressable_name ~= TILDE_WORKSPACE then
            hl.dispatch(hl.dsp.workspace.toggle_special("scratchpad"))
        end
        hl.dispatch(hl.dsp.exec_cmd(TILDE_COMMAND))
        return
    end

    local window = windows[1]
    if window.workspace and window.workspace.addressable_name ~= TILDE_WORKSPACE then
        hl.dispatch(hl.dsp.window.move({
            window = window,
            workspace = TILDE_WORKSPACE,
            follow = false,
        }))
    end

    hl.dispatch(hl.dsp.workspace.toggle_special("scratchpad"))
end

return M

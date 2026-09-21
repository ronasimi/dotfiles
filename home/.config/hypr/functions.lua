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
---- SMART SUPER + DRAG TILE/FLOAT     ----
-------------------------------------------

local smart_drag = nil

function M.smart_drag_begin()
    local window = hl.get_active_window()
    if not window then
        smart_drag = nil
        return
    end

    smart_drag = {
        window = window,
        was_floating = window.floating,
        was_pinned = window.pinned,
    }

    -- Detach tiled windows immediately so the native mouse-drag dispatcher
    -- can move them freely. keybinds.lua starts the actual interactive drag.
    if not window.floating then
        hl.dispatch(hl.dsp.window.float({ window = window, action = "set" }))
        if M.schedule_smart_gaps_refresh then
            M.schedule_smart_gaps_refresh()
        end
    end
end

-- A click (movement stayed under binds.drag_threshold) is a no-op: restore the
-- original state if we temporarily detached a tiled window on button press.
function M.smart_drag_click_end()
    if not smart_drag then
        return
    end

    if not smart_drag.was_floating then
        hl.dispatch(hl.dsp.window.float({ window = smart_drag.window, action = "unset" }))
        if M.schedule_smart_gaps_refresh then
            M.schedule_smart_gaps_refresh()
        end
    end

    smart_drag = nil
end

-- A real drag commits a mode transition. Tiled -> floating remains detached;
-- floating -> tiled is reinserted into the active layout. Pinned windows remain
-- floating because pinning only has meaningful semantics for floating windows.
function M.smart_drag_drag_end()
    if not smart_drag then
        return
    end

    if smart_drag.was_floating and not smart_drag.was_pinned then
        hl.dispatch(hl.dsp.window.float({ window = smart_drag.window, action = "unset" }))
        if M.schedule_smart_gaps_refresh then
            M.schedule_smart_gaps_refresh()
        end
    end

    smart_drag = nil
end

-------------------------------------------
---- LAYOUT-AWARE COMPOSITOR ACTIONS   ----
-------------------------------------------

function M.layout_action(actions)
    return function()
        local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
        if not workspace then
            return
        end

        local dispatcher = actions[workspace.tiled_layout]
        if dispatcher then
            hl.dispatch(dispatcher)
        end
    end
end

function M.toggle_primary_layout()
    local current = hl.get_config("general.layout")
    local next_layout = (current == "master") and "dwindle" or "master"
    hl.config({ general = { layout = next_layout } })
    notify("Layout: " .. next_layout, "info")
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
---- SMART GAPS                         ----
-------------------------------------------

-- Default: OFF. This implementation intentionally avoids workspace-rule
-- runtime handles: Hyprland 0.55 exposes runtime handles for named window
-- rules, but not for workspace rules. Gaps are therefore updated with the
-- documented hl.get_config()/hl.config() path when the active regular
-- workspace transitions between one tiled window and any other state.
local smart_gaps_enabled = false
local smart_gaps_applied = false
local smart_gap_base = nil
local smart_gap_refresh_timer = nil

-- Named window rules *are* runtime-toggleable on Hyprland 0.55+. Keep this
-- rule disabled until smart gaps are enabled. It handles rounding/borders on
-- every matching workspace while the event-driven code below handles gaps.
local smart_gap_window_rule = hl.window_rule({
    name = "smart-gaps-single-tiled",
    match = { float = false, workspace = "w[tv1]s[false]" },
    border_size = 0,
    rounding = 0,
})

if smart_gap_window_rule and smart_gap_window_rule.set_enabled then
    smart_gap_window_rule:set_enabled(false)
end

local function copy_gaps(value, fallback)
    if type(value) ~= "table" then
        return fallback
    end

    return {
        top = value.top or fallback.top,
        left = value.left or fallback.left,
        right = value.right or fallback.right,
        bottom = value.bottom or fallback.bottom,
    }
end

local function capture_smart_gap_base()
    if smart_gap_base then
        return
    end

    -- functions.lua is imported before the main hl.config() batch, so capture
    -- these lazily on first enable rather than at module load time.
    smart_gap_base = {
        gaps_in = copy_gaps(hl.get_config("general.gaps_in"), {
            top = 9, left = 9, right = 9, bottom = 9,
        }),
        gaps_out = copy_gaps(hl.get_config("general.gaps_out"), {
            top = 18, left = 18, right = 18, bottom = 18,
        }),
    }
end

local function active_regular_workspace_has_one_tiled()
    -- Match the official smart-gap selector's s[false] behavior.
    if hl.get_active_special_workspace() ~= nil then
        return false
    end

    local workspace = hl.get_active_workspace()
    if not workspace then
        return false
    end

    local selector = workspace.id or workspace.addressable_name or workspace.name
    if selector == nil then
        return false
    end

    local windows = hl.get_workspace_windows(selector) or {}
    local tiled = 0

    for _, window in ipairs(windows) do
        if window and window.mapped ~= false and not window.floating then
            tiled = tiled + 1
            if tiled > 1 then
                return false
            end
        end
    end

    return tiled == 1
end

local function apply_smart_gap_state(gapless)
    capture_smart_gap_base()

    if smart_gaps_applied == gapless then
        return
    end

    smart_gaps_applied = gapless

    if gapless then
        hl.config({
            general = {
                gaps_in = 0,
                gaps_out = 0,
            }
        })
    else
        hl.config({
            general = {
                gaps_in = smart_gap_base.gaps_in,
                gaps_out = smart_gap_base.gaps_out,
            }
        })
    end
end

function M.refresh_smart_gaps()
    if not smart_gaps_enabled then
        return
    end

    apply_smart_gap_state(active_regular_workspace_has_one_tiled())
end

function M.schedule_smart_gaps_refresh()
    if not smart_gaps_enabled or smart_gap_refresh_timer ~= nil then
        return
    end

    -- Window/layout dispatchers complete after the current Lua callback. A tiny
    -- one-shot lets Hyprland update window.floating/workspace membership first.
    smart_gap_refresh_timer = hl.timer(function()
        smart_gap_refresh_timer = nil
        M.refresh_smart_gaps()
    end, { timeout = 20, type = "oneshot" })
end

function M.set_smart_gaps(enabled, quiet)
    enabled = not not enabled

    if enabled == smart_gaps_enabled then
        return true
    end

    capture_smart_gap_base()
    smart_gaps_enabled = enabled

    if smart_gap_window_rule and smart_gap_window_rule.set_enabled then
        smart_gap_window_rule:set_enabled(enabled)
    end

    if enabled then
        M.refresh_smart_gaps()
    else
        if smart_gap_refresh_timer and smart_gap_refresh_timer.set_enabled then
            smart_gap_refresh_timer:set_enabled(false)
        end
        smart_gap_refresh_timer = nil
        apply_smart_gap_state(false)
    end

    if not quiet then
        notify("Smart gaps: " .. (enabled and "enabled" or "disabled"), enabled and "ok" or "info")
    end

    return true
end

function M.toggle_smart_gaps()
    return M.set_smart_gaps(not smart_gaps_enabled)
end

function M.smart_gaps_enabled()
    return smart_gaps_enabled
end

-- Keep smart gaps synchronized with the active workspace without polling.
-- All of these events are available in Hyprland 0.55's Lua API.
local function smart_gap_event_refresh()
    M.schedule_smart_gaps_refresh()
end

hl.on("window.open", smart_gap_event_refresh)
hl.on("window.close", smart_gap_event_refresh)
hl.on("window.destroy", smart_gap_event_refresh)
hl.on("window.active", smart_gap_event_refresh)
hl.on("window.move_to_workspace", smart_gap_event_refresh)
hl.on("workspace.active", smart_gap_event_refresh)
hl.on("workspace.created", smart_gap_event_refresh)
hl.on("workspace.removed", smart_gap_event_refresh)
hl.on("monitor.focused", smart_gap_event_refresh)

-- Route the normal float toggle through a tiny wrapper so smart gaps refresh
-- immediately after a window switches between tiled and floating.
function M.toggle_floating()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    M.schedule_smart_gaps_refresh()
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
---- CONTEXT-SENSITIVE SCRATCHPAD      ----
-------------------------------------------

local SCRATCHPAD_CLASS = "scratchpad"
local SCRATCHPAD_WORKSPACE = "special:scratchpad"
local SCRATCHPAD_COMMAND = "/home/ron/.bin/starttilde && uwsm app -- kitty -1 --class 'scratchpad' -e '/home/ron/.bin/chktilde'"

function M.toggle_terminal_scratchpad()
    local windows = hl.get_windows({ class = SCRATCHPAD_CLASS })

    if #windows == 0 then
        -- Open the special workspace first so the terminal appears immediately
        -- when the process creates its window. Avoid toggling it closed in the
        -- unusual case that the empty scratchpad workspace is already visible.
        local active_special = hl.get_active_special_workspace()
        if not active_special or active_special.addressable_name ~= SCRATCHPAD_WORKSPACE then
            hl.dispatch(hl.dsp.workspace.toggle_special("scratchpad"))
        end
        hl.dispatch(hl.dsp.exec_cmd(SCRATCHPAD_COMMAND))
        return
    end

    local window = windows[1]
    if window.workspace and window.workspace.addressable_name ~= SCRATCHPAD_WORKSPACE then
        hl.dispatch(hl.dsp.window.move({
            window = window,
            workspace = SCRATCHPAD_WORKSPACE,
            follow = false,
        }))
    end

    hl.dispatch(hl.dsp.workspace.toggle_special("scratchpad"))
end

return M

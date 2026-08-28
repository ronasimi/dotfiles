-----------------------------
---- HYPRLAND DAEMONS    ----
-----------------------------

-- Auto-hide Waybar based on cursor position
local is_waybar_visible = false

local waybar_hover_timer = hl.timer(function()
    local pos = hl.get_cursor_pos()
    if pos then
        if pos.y <= 18 and not is_waybar_visible then
            is_waybar_visible = true
            hl.dispatch(hl.dsp.exec_cmd("pkill -SIGUSR1 '^waybar$'"))
        elseif pos.y > 36 and is_waybar_visible then
            is_waybar_visible = false
            hl.dispatch(hl.dsp.exec_cmd("pkill -SIGUSR1 '^waybar$'"))
        end
    end
end, { timeout = 150, type = "repeat" })

-----------------------------------------------------------------------------
-- Dwindle Layout: Directional Split Preselect & Dynamic Border Watchers
-----------------------------------------------------------------------------

-- 1. The Default State: Solid #272727 at 45% opacity (73 in hex)
-- Removed 'local' to allow keybinds.lua to access this function
function reset_border_state()
    hl.config({
        general = {
            border_size = 1,
            ["col.active_border"] = {
                colors = { "#27272773" } 
            }
        }
    })
end

-- 2. The Directional Split State: Blue gradient pointing toward the split
-- Removed 'local' to allow keybinds.lua to access this function
function preselect_with_border(direction, angle)
    -- Tell the dwindle layout which way to split next
    hl.dispatch(hl.dsp.layout("preselect " .. direction))
    
    -- Change the active border to a gradient
    -- Starts with solid blue (#8ab4f8ff) and fades into 45% opaque dark gray (#27272773)
    hl.config({
        general = {
            border_size = 1,
            ["col.active_border"] = {
                colors = { "#8ab4f8ff", "#27272773" },
                angle = angle
            }
        }
    })
end

-- 3. The Watchers: Reverting to the default gray state automatically
-- Fires when the split is consumed by a new window
hl.on("window.open", function(window_address) 
    reset_border_state() 
end)

-- Fires if you change your mind and switch focus away from the preselected window
hl.on("window.active", function(window_address) 
    reset_border_state() 
end)

-- Fires if you change your mind and switch workspaces entirely
hl.on("workspace.active", function(workspace_id) 
    reset_border_state() 
end)
-----------------------------
---- NATIVE LUA SCRIPTS  ----
-----------------------------

-- Waybar Top-Edge Hover Autohide
local is_waybar_visible = false -- Set to true because Waybar launches visible

local waybar_hover_timer = hl.timer(function()
    local pos = hl.get_cursor_pos()
    if pos then
        if pos.y <= 12 and not is_waybar_visible then
            hl.exec_cmd("pkill -SIGUSR1 '^waybar$'")
            is_waybar_visible = true
        elseif pos.y > 12 and is_waybar_visible then
            hl.exec_cmd("pkill -SIGUSR1 '^waybar$'")
            is_waybar_visible = false
        end
    end
end, { timeout = 100, type = "repeat" })
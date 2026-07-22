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
            hl.exec_cmd("pkill -SIGUSR1 '^waybar$'")
        elseif pos.y > 36 and is_waybar_visible then
            is_waybar_visible = false
            hl.exec_cmd("pkill -SIGUSR1 '^waybar$'")
        end
    end
end, { timeout = 150, type = "repeat" })

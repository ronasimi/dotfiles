-----------------------------
---- NATIVE LUA SCRIPTS  ----
-----------------------------

-- Waybar Top-Edge Hover Autohide
local is_waybar_visible = false

-- Increased timeout to 150ms. 
-- 150ms is visually imperceptible for hover intents, but saves CPU cycles over 100ms.
local waybar_hover_timer = hl.timer(function()
    local pos = hl.get_cursor_pos()
    
    -- Safety guard: only execute logic if cursor position is successfully polled
    if pos then
        if pos.y <= 18 and not is_waybar_visible then
            hl.exec_cmd("pkill -SIGUSR1 '^waybar$'")
            is_waybar_visible = true
        elseif pos.y > 36 and is_waybar_visible then
            hl.exec_cmd("pkill -SIGUSR1 '^waybar$'")
            is_waybar_visible = false
        end
    end
end, { timeout = 150, type = "repeat" })


-- Toggle layout (Optimized string assignment to avoid redundant subshells)
local current_layout = "dwindle" 

local function toggle_layout()
    -- Inline ternary logic
    current_layout = (current_layout == "master") and "dwindle" or "master"
    hl.exec_cmd("hyprctl keyword general:layout " .. current_layout)
end

-- Uncomment to bind:
-- hl.bind("SUPER + ALT + L", toggle_layout)

-- 1. Narrow the scope: Only target windows with the class 'scratchpad'
local workspace_rules = {
    { class_regex = "scratchpad", ws = "special:scratchpad" }
}

-- 2. Apply the rules correctly
for _, rule in ipairs(workspace_rules) do
    hl.window_rule({ 
        match = { class = rule.class_regex }, 
        workspace = rule.ws,
        animation = "slide top" -- You can combine these now
    })
end

-- 3. Remove the hl.config({ windowrulev2 = ... }) block 
-- It is redundant if you define the animation within the window_rule call above.
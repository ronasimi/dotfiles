-------------------------
---- WORKSPACE RULES ----
-------------------------

-- Intentionally kept as a plain Hyprland config include.
--
-- Runtime smart-gaps state lives in functions.lua because keybinds.lua already
-- imports that module. Keeping this file as a normal config include avoids
-- treating an empty or user-customized workspaces.lua as a value-returning Lua
-- module. Add static per-workspace rules here as needed.

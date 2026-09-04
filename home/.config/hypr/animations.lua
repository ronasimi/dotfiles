-----------------------
----  ANIMATIONS   ----
-----------------------

-- Core Physics Curves
hl.curve("fast_window_spring", { type = "spring", mass = 1, stiffness = 400.0, dampening = 24.5 }) 
hl.curve("window_spring_out", { type = "spring", mass = 1, stiffness = 350.0, dampening = 29.5 }) 
hl.curve("workspace_slide", { type = "spring", mass = 1, stiffness = 380.0, dampening = 27.5 }) 
-- Heavily over-damped spring for move/resize to completely eliminate any overshoot or bounceback.
hl.curve("no_overshoot_spring", { type = "spring", mass = 1, stiffness = 400.0, dampening = 50.0 })
hl.curve("human_optimal_in", { type = "spring", mass = 1, stiffness = 520.0, dampening = 27.0 })
hl.curve("smooth_ease", { type = "bezier", points = { { 0.34, 1.15 }, { 0.64, 1.0 } } })

hl.config({ animations = { enabled = true } })

-- Global Speed
hl.animation({ leaf = "global", enabled = true, speed = 3.5, spring = "fast_window_spring" })

-- Workspaces
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.5, spring = "workspace_slide", style = "slide fade" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 3.5, spring = "workspace_slide", style = "slide top fade" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 3.5, spring = "workspace_slide", style = "slide top fade" })

-- Windows
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.5, spring = "human_optimal_in", style = "popin 85%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3.5, spring = "no_overshoot_spring" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.5, spring = "window_spring_out", style = "popin 80%" }) 

-- UI Elements & Fades
hl.animation({ leaf = "border", enabled = true, speed = 3.5, bezier = "smooth_ease" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2, bezier = "smooth_ease" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2, bezier = "smooth_ease" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2, bezier = "smooth_ease" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2.5, bezier = "smooth_ease" })

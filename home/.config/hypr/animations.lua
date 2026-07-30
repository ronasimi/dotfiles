-----------------------
----  ANIMATIONS   ----
-----------------------

-- Core Physics Curves
hl.curve("fast_window_spring", { type = "spring", mass = 1, stiffness = 199.9, dampening = 23.0 }) 
hl.curve("window_spring_out", { type = "spring", mass = 1, stiffness = 194.9, dampening = 24.0 }) 
hl.curve("workspace_slide", { type = "spring", mass = 1, stiffness = 322.5, dampening = 35.9 }) 
hl.curve("smooth_ease", { type = "bezier", points = { { 0.42, 0.0 }, { 0.58, 1.0 } } })

hl.config({ animations = { enabled = true } })

-- Global Speed
hl.animation({ leaf = "global", enabled = true, speed = 4, spring = "fast_window_spring" })

-- Workspaces
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, spring = "workspace_slide", style = "slide fade" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 4, spring = "workspace_slide", style = "slide top fade" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 4, spring = "workspace_slide", style = "slide top fade" })

-- Windows
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4, spring = "fast_window_spring", style = "popin 85%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, spring = "fast_window_spring" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, spring = "window_spring_out", style = "popin 80%" }) 

-- UI Elements & Fades
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "smooth_ease" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2, bezier = "smooth_ease" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2, bezier = "smooth_ease" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2, bezier = "smooth_ease" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2.5, bezier = "smooth_ease" })

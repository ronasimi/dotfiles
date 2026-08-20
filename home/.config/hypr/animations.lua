-----------------------
----  ANIMATIONS   ----
-----------------------

-- Core Physics Curves
-- Increased stiffness for a snappy pop, with dampening tuned for a whimsical, underdamped bounce.
hl.curve("fast_window_spring", { type = "spring", mass = 1, stiffness = 400.0, dampening = 26.0 }) 
-- Slightly higher dampening on the exit so windows don't wildly bounce as they disappear.
hl.curve("window_spring_out", { type = "spring", mass = 1, stiffness = 350.0, dampening = 31.0 }) 
-- Snappy workspace transitions with a very subtle settling bounce.
hl.curve("workspace_slide", { type = "spring", mass = 1, stiffness = 380.0, dampening = 29.0 }) 
-- Replaced standard ease with an "ease-out-back" curve to give UI elements a slight overshoot pop.
hl.curve("smooth_ease", { type = "bezier", points = { { 0.34, 1.15 }, { 0.64, 1.0 } } })

hl.config({ animations = { enabled = true } })

-- Global Speed (Tuned down slightly from 4 to 3.5 to emphasize the snap)
hl.animation({ leaf = "global", enabled = true, speed = 3.5, spring = "fast_window_spring" })

-- Workspaces
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.5, spring = "workspace_slide", style = "slide fade" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 3.5, spring = "workspace_slide", style = "slide top fade" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 3.5, spring = "workspace_slide", style = "slide top fade" })

-- Windows
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.5, spring = "fast_window_spring", style = "popin 85%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3.5, spring = "fast_window_spring" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.5, spring = "window_spring_out", style = "popin 80%" }) 

-- UI Elements & Fades
hl.animation({ leaf = "border", enabled = true, speed = 3.5, bezier = "smooth_ease" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2, bezier = "smooth_ease" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2, bezier = "smooth_ease" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2, bezier = "smooth_ease" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2.5, bezier = "smooth_ease" })

# Hyprland Lua configuration

Modular Hyprland Lua configuration with Dwindle/Master layout controls, monitor-aware utility-window placement, smart tiled/floating mouse dragging, scratchpads, touch gestures, and optional compositor effects.

## Keybinds

`SUPER` is the primary modifier.

### Application launchers

| Keybind | Action |
|---|---|
| `SUPER + Return` | Open the pinned utility Kitty terminal (`super-enter`) |
| `SUPER + Alt + Return` | Open a normal Kitty terminal |
| `SUPER + Shift + Return` | Open the wide bottom utility terminal |
| `SUPER + E` | Open Thunar |
| `SUPER + D` | Open Walker |
| `SUPER + R` | Open `hyprland-run` |
| `SUPER + T` | Toggle/reuse the terminal scratchpad; spawn it only if needed |

#> **Smart gaps compatibility:** Smart gaps start OFF. `SUPER + CTRL + G` uses only Hyprland 0.55+ documented Lua APIs; no workspace-rule runtime handle is required.

## Window management

| Keybind | Action |
|---|---|
| `SUPER + X` | Close active window |
| `SUPER + Space` | Toggle active window tiled/floating |
| `SUPER + P` | Pin/unpin active floating window |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + M` | Toggle maximized mode |
| `SUPER + Ctrl + Space` | Focus a window in the opposite mode (tiled ↔ floating) |
| `SUPER + N` | Minimize active window to `special:minimized` |
| `SUPER + Shift + N` | Restore the most recently minimized window |
| `SUPER + U` | Focus an urgent window, otherwise the last-focused window |

### Mouse window management

| Keybind | Action |
|---|---|
| `SUPER + Left Drag` | Smart move: tiled → floating; floating → tiled on completed drag |
| `SUPER + Left Click` | No mode change if movement stays below the drag threshold |
| `SUPER + Right Drag` | Resize active window |

Pinned floating windows remain floating after `SUPER + Left Drag`.

### Focus and window movement

| Keybind | Action |
|---|---|
| `SUPER + ←/→/↑/↓` | Focus window in that direction |
| `SUPER + Shift + ←/→/↑/↓` | Move active window in that direction |

### Layout controls

| Keybind | Action |
|---|---|
| `SUPER + J` | Toggle the primary layout between Dwindle and Master |
| `SUPER + /` | Toggle Dwindle split orientation |
| `SUPER + A` | Layout-aware previous/left action |
| `SUPER + Shift + A` | Layout-aware next/right action |
| `SUPER + Alt + ←` | Preselect next Dwindle split to the left |
| `SUPER + Alt + →` | Preselect next Dwindle split to the right |
| `SUPER + Alt + ↑` | Preselect next Dwindle split upward |
| `SUPER + Alt + ↓` | Preselect next Dwindle split downward |

`SUPER + A` / `SUPER + Shift + A` adapt to the current tiled layout:

- **Dwindle:** swap split / toggle split
- **Master:** cycle previous / next
- **Monocle:** cycle previous / next
- **Scrolling:** swap column left / right

### Workspaces and overview

| Keybind | Action |
|---|---|
| `SUPER + 1…0` | Switch to workspace 1…10 |
| `SUPER + Shift + 1…0` | Move active window to workspace 1…10 |
| `SUPER + Grave` | Toggle `special:scratchpad` |
| `SUPER + Shift + Grave` | Move active window to `special:scratchpad` |
| `Alt + Tab` | Switch to the previous workspace |
| `SUPER + Tab` | Toggle Hymission overview |
| `SUPER + Page Down` | Switch to next existing workspace |
| `SUPER + Page Up` | Switch to previous existing workspace |
| `SUPER + Mouse Wheel Down` | Switch to next existing workspace |
| `SUPER + Mouse Wheel Up` | Switch to previous existing workspace |

### Appearance and compositor controls

| Keybind | Action |
|---|---|
| `SUPER + Ctrl + G` | Toggle smart gaps; **disabled by default** |
| `SUPER + Ctrl + B` | Toggle low-effects performance/battery mode |
| `SUPER + B` | Toggle Waybar visibility |
| `SUPER + Z` | Toggle cursor zoom between 1.0× and 1.5× |
| `SUPER + =` | Increase cursor zoom by 0.25× |
| `SUPER + -` | Decrease cursor zoom by 0.25× |

When smart gaps are enabled, a regular workspace with exactly one visible tiled window removes its inner/outer gaps and window rounding. Special workspaces are excluded. Reloading the config returns smart gaps to the default **off** state.

### System and power

| Keybind | Action |
|---|---|
| `SUPER + L` | Lock session |
| `SUPER + Shift + X` | Exit Hyprland session |
| `SUPER + Shift + R` | Reboot |
| `SUPER + Shift + P` | Power off |
| `SUPER + Shift + S` | Suspend |
| `SUPER + Escape` | Pop the most recent notification from Dunst history |

Closing the lid locks the session and turns the display off; opening it re-enables DPMS.

### Audio, brightness, and hardware keys

| Keybind | Action |
|---|---|
| `XF86AudioRaiseVolume` | Raise volume 5% |
| `XF86AudioLowerVolume` | Lower volume 5% |
| `XF86AudioMute` | Toggle output mute |
| `XF86AudioMicMute` | Toggle microphone mute |
| `XF86MonBrightnessUp` | Raise brightness 5% |
| `XF86MonBrightnessDown` | Lower brightness 5% |
| `XF86Display` | Open `nwg-displays` |
| `XF86Favorites` | Open LocalSend |

### Screenshots

| Keybind | Action |
|---|---|
| `Print` | Save full-screen screenshot |
| `Alt + Print` | Save active-window screenshot |
| `Shift + Print` | Copy full-screen screenshot |
| `Alt + Shift + Print` | Copy active-window screenshot |
| `XF86SelectiveScreenshot` | Save selected-area screenshot |
| `Shift + XF86SelectiveScreenshot` | Copy selected-area screenshot |

### Workspace application shortcuts

These shortcuts switch to the target workspace before launching the application.

| Keybind | Workspace | Application |
|---|---:|---|
| `SUPER + F1` | 1 | Google Chrome |
| `SUPER + Alt + F1` | current | Google Chrome Incognito |
| `SUPER + F2` | 2 | Kitty |
| `SUPER + F3` | 3 | Thunar |
| `SUPER + F4` | 4 | Visual Studio Code |
| `SUPER + F5` | 5 | GIMP |
| `SUPER + F6` | 6 | VMware |
| `SUPER + F7` | 7 | LibreOffice Writer |
| `SUPER + F8` | 8 | PrusaSlicer |

## Gestures

### Native Hyprland gestures

| Gesture | Action |
|---|---|
| 3-finger horizontal swipe | Switch workspace |
| 3-finger swipe down | Toggle scratchpad |
| 3-finger swipe up | Toggle Hymission overview |
| 2-finger pinch | Live cursor-anchored compositor zoom |

### Hyprgrass gestures

When the Hyprgrass plugin is loaded:

| Gesture | Action |
|---|---|
| 3-finger horizontal swipe | Switch workspace |
| 3-finger swipe down | Toggle scratchpad |
| 3-finger swipe up | Toggle Hymission overview |
| Top-edge swipe down | Toggle Hymission overview |
| Bottom-edge swipe up | Toggle scratchpad |

## Utility-window placement

Utility windows are positioned relative to their current monitor rather than fixed screen coordinates.

- Waybar height: **36 px**
- Gap below Waybar: **9 px**
- Effective top offset: **45 px**
- Right-edge gap: **9 px**

Top-right utility placement is used for `pavucontrol`/`nmtui`, Overskride, `nwg-displays`, and `tnywfi`. Existing utility windows are reflowed after monitor layout changes and config reloads.

## Configuration layout

| File | Purpose |
|---|---|
| `hyprland.lua` | Main imports and global compositor configuration |
| `keybinds.lua` | Keybinds and gestures |
| `functions.lua` | Reusable compositor helpers and stateful behaviors |
| `rules.lua` | Window/layer rules and utility-window registrations |
| `workspaces.lua` | Workspace rules and smart-gaps toggle state |
| `animations.lua` | Animation curves and animation configuration |
| `plugins.lua` | Hymission and Hyprgrass configuration |
| `monitors.lua` | Monitor configuration loader |
| `permissions.lua` | Optional Hyprland permission rules |
| `autostart.lua` | Startup applications and services |
| `hypridle.conf` | Idle/lock/DPMS behavior |

## Dwindle spiral behavior

The default tiled layout uses classic dynamic Dwindle behavior:

- `force_split = 2`: the newly opened child is placed on the right or bottom.
- `preserve_split = false`: split orientation is recalculated from the parent aspect ratio, producing the alternating left/right then top/bottom spiral.
- `smart_split = false`: normal window creation is not influenced by pointer position.
- `precise_mouse_move = true`: manual `SUPER + drag` reinsertion can still use the pointer for accurate drop placement.

If an existing workspace was created under a different split policy, open the test windows on a fresh workspace (or recreate them) to verify the new tree shape.

# Hyprland Lua configuration

Modular Hyprland Lua configuration with Dwindle/Master layout controls, monitor-aware utility-window placement, native tiled mouse reordering, scratchpads, touch gestures, and optional compositor effects.

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
| `SUPER + Left Drag` | Move/reorder the active window; tiled windows stay tiled and are placed from the drop position |
| `SUPER + Right Drag` | Resize active window |

`SUPER + Left Drag` does not change tiled/floating state. Dwindle pointer-aware placement is enabled only while the drag is active.

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
| `SUPER + Alt + ←` | Preselect next Dwindle split to the left |
| `SUPER + Alt + →` | Preselect next Dwindle split to the right |
| `SUPER + Alt + ↑` | Preselect next Dwindle split upward |
| `SUPER + Alt + ↓` | Preselect next Dwindle split downward |

### Workspaces and overview

| Keybind | Action |
|---|---|
| `SUPER + 1…0` | Switch to workspace 1…10 |
| `SUPER + Shift + 1…0` | Move active window to workspace 1…10 |
| `SUPER + Grave` (`~` key) | Launch Tilde if needed; otherwise show/hide the existing Tilde window |
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
| `SUPER + Ctrl + B` | Toggle low-effects performance/battery mode |
| `SUPER + B` | Toggle Waybar visibility |
| `SUPER + Z` | Toggle cursor zoom between 1.0× and 1.5× |
| `SUPER + =` | Increase cursor zoom by 0.25× |
| `SUPER + -` | Decrease cursor zoom by 0.25× |


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
| `workspaces.lua` | Optional workspace-specific Lua configuration (currently empty, matching the original config) |
| `animations.lua` | Animation curves and animation configuration |
| `plugins.lua` | Hymission and Hyprgrass configuration |
| `monitors.lua` | Monitor configuration loader |
| `permissions.lua` | Optional Hyprland permission rules |
| `autostart.lua` | Startup applications and services |
| `hypridle.conf` | Idle/lock/DPMS behavior |

## Dwindle spiral behavior

The default tiled layout uses the original Dwindle settings from this configuration:

- `preserve_split = true`
- `force_split = 2`

Inner/outer gaps always remain at the normal configured values; no smart-gaps feature or toggle is installed.

If an existing workspace was created under a different split policy, open the test windows on a fresh workspace (or recreate them) to verify the new tree shape.

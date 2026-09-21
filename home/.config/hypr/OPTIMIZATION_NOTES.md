# Hyprland Lua optimization notes

This revision keeps the existing visual style and application workflow while moving compositor logic into native Lua paths wherever practical.

## Utility-window geometry

`functions.lua` now owns reusable utility-window placement through `register_utility_window()` and `reflow_utility_windows()`.

Defaults:

- Waybar height: **36 px**
- Gap below Waybar: **9 px**
- Effective top inset: **45 px**
- Right-edge inset: **9 px**

The following utility windows use the shared top-right anchor:

- `nmtui` / `org.pulseaudio.pavucontrol` — 600×566
- `io.github.kaii_lb.Overskride` — 942×616
- `nwg-displays` — 916×472
- `tnywfi` — 480×450

Placement is monitor-relative at window-rule time and is re-applied after utility window creation/class changes, monitor hotplug/layout changes, and config reloads. The bottom `super-shift-enter` terminal is also monitor-relative, retaining 18 px left/right/bottom margins.

## SUPER + drag

- **SUPER + LMB drag on tiled window:** remains tiled and is moved/reinserted according to the release position.
- **SUPER + LMB drag on floating window:** remains floating and moves normally.
- **SUPER + RMB:** resize as before.
- The previous automatic tiled ↔ floating transition logic has been removed.
- `smart_split` and `precise_mouse_move` are enabled only while `SUPER + LMB` is held, then restored to `false`.
- At rest, Dwindle remains exactly at the original layout settings: `preserve_split = true` and `force_split = 2`.
- Smart gaps are not configured and there is no smart-gaps toggle.

## New compositor functions / bindings

| Binding | Action |
|---|---|
| `SUPER + CTRL + SPACE` | Focus the opposite window mode (tiled ↔ floating) |
| `SUPER + N` | Minimize active window to tagged `special:minimized` |
| `SUPER + SHIFT + N` | Restore the most recently minimized window |
| `SUPER + U` | Focus urgent window, otherwise last-focused window |
| `SUPER + J` | Toggle Dwindle ↔ Master using the original config behavior |
| `SUPER + Z` | Toggle cursor zoom 1.0 ↔ 1.5 |
| `SUPER + =` | Increase cursor zoom by 0.25 |
| `SUPER + -` | Decrease cursor zoom by 0.25 |
| `SUPER + CTRL + B` | Toggle low-effects performance/battery mode |
| `SUPER + Grave` (`~` key) | Launch Tilde once, then show/hide the existing Tilde window |
| 2-finger pinch | Live cursor-anchored compositor zoom |


## Automatic behavior

- **Split preselect border:** the temporary blue directional border is restored to the actual zero-border baseline instead of accidentally leaving `border_size = 1` after focus/workspace events.
- **Waybar reveal:** cursor-edge detection is monitor-local, so vertically offset multi-monitor layouts work correctly.
- **Monitor changes:** utility windows are reflowed after add/remove/layout changes.
- **Performance mode:** snapshots and restores the current animation, blur, and shadow enabled states instead of assuming fixed defaults.

## Files changed

- `functions.lua`
- `hyprland.lua`
- `keybinds.lua`
- `rules.lua`
- `README.md`

`SUPER + J` uses the original `hyprctl keyword general:layout` toggle from the source config. The SUPER-drag path remains compositor-native and no longer changes window mode.

## Lua module loading

`functions.lua` is the value-returning helper module used by `rules.lua` and `keybinds.lua`, so callers load it with Hyprland's `__require()`. The former empty `workspaces.lua` include was removed as dead configuration.

## Helper-script cleanup

- Removed unreferenced `scripts/track_backlight.sh` and `scripts/wofi-switcher.py`.
- Removed stale `monitors.conf`, empty `workspaces.conf`, and empty `workspaces.lua`; `hyprland.lua` no longer imports the no-op workspace module.
- `media_pause.sh` is now event-driven (`pause`/`resume`) and contains no sleeps or process-polling loop. Hypridle invokes it only at lock/unlock boundaries; it exits immediately after state capture/restore and leaves no resident watcher.
- `netlock.sh` uses one bounded `iw` request rather than three external commands/pipeline stages.
- `battlock.sh` performs only direct sysfs reads and shell built-ins.


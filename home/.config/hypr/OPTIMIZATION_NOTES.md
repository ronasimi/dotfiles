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

- **SUPER + LMB drag on tiled window:** detach to floating and drag freely.
- **SUPER + LMB drag on ordinary floating window:** drag, then reinsert into tiling.
- **SUPER + LMB click without a drag:** restore the original mode.
- **Pinned floating windows:** remain floating after drag.
- **SUPER + RMB:** resize as before.
- `binds.drag_threshold = 8` controls click-vs-drag classification.
- Dwindle keeps the original spiral semantics with `force_split = 2`, `preserve_split = true`, and `smart_split = false`. New windows therefore continue to enter on the right/bottom of the active split.
- `precise_mouse_move = true` remains enabled independently so `SUPER+drag` can still use pointer-directed drop placement when rearranging/reinserting windows.

## New compositor functions / bindings

| Binding | Action |
|---|---|
| `SUPER + CTRL + SPACE` | Focus the opposite window mode (tiled ↔ floating) |
| `SUPER + N` | Minimize active window to tagged `special:minimized` |
| `SUPER + SHIFT + N` | Restore the most recently minimized window |
| `SUPER + U` | Focus urgent window, otherwise last-focused window |
| `SUPER + J` | Toggle Dwindle ↔ Master using native Lua config |
| `SUPER + A` | Layout-aware previous/left action |
| `SUPER + SHIFT + A` | Layout-aware next/right action |
| `SUPER + Z` | Toggle cursor zoom 1.0 ↔ 1.5 |
| `SUPER + =` | Increase cursor zoom by 0.25 |
| `SUPER + -` | Decrease cursor zoom by 0.25 |
| `SUPER + CTRL + G` | Toggle smart gaps (OFF by default) |
| `SUPER + CTRL + B` | Toggle low-effects performance/battery mode |
| `SUPER + T` | Context-sensitive scratchpad: reuse existing terminal before spawning |
| 2-finger pinch | Live cursor-anchored compositor zoom |

The layout-aware `SUPER + A` pair performs:

- Scrolling: swap column left/right
- Dwindle: swap split / toggle split
- Master: cycle previous/next
- Monocle: cycle previous/next

## Automatic behavior

- **Smart gaps:** disabled by default. `SUPER + CTRL + G` uses a Hyprland 0.55-compatible event-driven gap controller plus a named runtime-toggleable window rule; no workspace-rule handle API is required.
- **Split preselect border:** the temporary blue directional border is restored to the actual zero-border baseline instead of accidentally leaving `border_size = 1` after focus/workspace events.
- **Waybar reveal:** cursor-edge detection is monitor-local, so vertically offset multi-monitor layouts work correctly.
- **Monitor changes:** utility windows are reflowed after add/remove/layout changes.
- **Performance mode:** snapshots and restores the current animation, blur, and shadow enabled states instead of assuming fixed defaults.

## Files changed

- `functions.lua`
- `hyprland.lua`
- `keybinds.lua`
- `rules.lua`
- `workspaces.lua`
- `README.md`

No external synchronous `hyprctl keyword` calls remain in the layout or SUPER-drag hot paths.


## Lua module loading

`functions.lua` is the value-returning Lua module used by rules and keybinds, so callers load it with Hyprland's `__require()` (the original Lua module loader). `workspaces.lua` remains a plain config include and is never indexed as a returned module. This prevents a stale or empty `workspaces.lua` from making `require("workspaces")` evaluate to boolean `true` and breaking the smart-gaps bind.



## Smart gaps compatibility fix

The earlier runtime check for `hl.get_workspace_rules` was removed. Hyprland 0.55 documents runtime handles for named window/layer rules, not workspace rules. Smart-gap gaps now use `hl.get_config()` / `hl.config()` and compositor events, while the named window rule handles zero rounding/borders.


### Dwindle spiral correction
`preserve_split` is intentionally `false` while `force_split = 2`. This keeps insertion on the right/bottom but allows the split axis to alternate dynamically from node aspect ratio, restoring the classic Dwindle spiral.

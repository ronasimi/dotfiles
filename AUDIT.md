# Dotfiles vs. current home audit

Audit basis: the supplied `dotfiles-t14 (1).zip` repository copy compared with the supplied recursive home-directory listing from September 20, 2026.

The home listing contains names, types, sizes, timestamps and symlink targets, but not the contents of ordinary files. Therefore this audit can prove which files/config directories are present and which paths are live-linked to the repo; it cannot content-diff non-symlinked home files.

## Confirmed live-managed paths

The current home directory links the following repository areas back into `~/.dotfiles/home`:

- shell/user files: `.bin`, `.nano`, `.tmux`, `.face`, `.gtkrc-2.0`, `.nanorc`, `.p10k.zsh`, `.rtorrent.rc`, `.tmux.conf`, `.Xresources`, `.zprofile`, `.zshenv`, `.zshrc`;
- desktop/app configs: Btop, Dunst, Elephant, Fontconfig, GTK 2/3/4, Hyprland, imv, Kitty, MPV, Ranger, Sys64/Syshud, systemd user units, UWSM, Walker, Waybar, xdg-desktop-portal, yt-dlp and Zathura;
- single-file configs: Chrome flags, Code flags, and VS Code `User/settings.json`.

These paths are captured exactly in `manifests/home.txt` so the installer does not symlink all of `~/.config` or all of VS Code's mutable application state.

## Removed as stale or superseded

The source repo contained configs that are not present as live current-home configs and are superseded by the active setup:

| Removed | Current replacement / reason |
|---|---|
| `.config/rofi` | Walker + Elephant |
| `.config/wofi` | Walker + Elephant |
| `.config/fuzzel` | Walker + Elephant |
| `.config/hyprexpose` | Hymission plugin path in the current Hyprland Lua config |
| `.config/htop` | Btop/Nvtop are the active monitoring stack |
| `.config/amdtop` | No current `.config/amdtop`; the current home uses other GPU monitoring state |
| `.config/electron-flags.conf` | Not present in the current top-level `.config` inventory |
| `.xinitrc` | Current session starts Hyprland through UWSM from `.zprofile` |
| generated systemd wants links | Recreated by `install.sh`, not source-controlled |
| one-off `agent-reminder-work-20260920-090000.*` | Dated runtime task, not durable configuration |
| Ranger history/tagged state | Runtime state, not configuration |

Legacy helper scripts tied to Rofi/Wofi, dmenu/i3, urxvt, feh and xdotool were removed with those old paths. The old polling `barauto.sh` was also removed because the active Hyprland Lua implementation already owns Waybar reveal behavior.

The Hyprland repo also still physically contained files that its own documentation said had already been removed. Those stale archive remnants (`track_backlight.sh`, `wofi-switcher.py`, `monitors.conf`, `workspaces.conf`, `workspaces.lua`) are now actually gone.

## Current-home files worth adopting

These paths exist in the current home but are not currently linked to this repo. They are listed in `manifests/suggested.txt` rather than being guessed from the directory listing:

- `.gitconfig`;
- `.config/autostart/`;
- `.config/mimeapps.list`;
- `.config/pikaur.conf`;
- `.config/user-dirs.dirs`;
- `.config/thefuck/`;
- `.config/qt6ct/`;
- `.config/nwg-look/`;
- `.config/xsettingsd/`;
- `.config/Kvantum/`;
- `.config/Thunar/uca.xml`;
- `.hyprlogin.png`;
- `Projects/Wallpapers/ivan.levyv.png`.

The repo copies of `pikaur.conf`, `user-dirs.dirs` and `thefuck/settings.py` were removed instead of kept as stale fallbacks because the directory inventory shows that the live non-symlinked copies differ from those archived repo copies.

Use `./backup.sh --adopt-suggested` on the real machine to import their actual current contents and make them managed.

## Intentionally excluded

The following should remain outside the dotfiles repo unless deliberately sanitized:

- browser profiles, keyrings, `.gnupg`, authentication/token files and private SSH material;
- `.histfile`, caches, thumbnails, crash recovery and compiler caches;
- `.claude.json`, `.env` files and application credential stores;
- Docker/Ollama/VM data and downloaded models;
- generated systemd wants directories and transient timers.

## Remaining portability notes

The link/install framework uses `$HOME`, but a few application configs still contain machine-specific `/home/ron` paths, including rTorrent locations, GTK bookmarks, some UI asset references and the selected Hyprpaper wallpaper. They are documented in the README so they can be normalized later without changing currently working application syntax blindly.

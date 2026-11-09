<h1 align="center" style="color:#d0d0d0">
  <span style="color:#75b5aa">⬢</span> Dotfiles
</h1>

<p align="center">
  <span style="color:#8ab4f8">Arch</span> · <span style="color:#aa759f">Hyprland</span> · <span style="color:#90a959">UWSM</span> · <span style="color:#f4bf75">Walker + Elephant</span>
</p>

<p align="center" style="color:#818181">
  ThinkPad T14 Gen 1 (AMD) — full desktop restore from a single script
</p>

---

## Quick Start

```bash
git clone https://github.com/ronasimi/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

That's it. Packages install, configs symlink, system files land in `/etc`, services enable. Log out and back in.

<span style="color:#f4bf75">⚡</span> Non-interactive: `./install.sh --yes`

---

## What Gets Installed

| Layer | Source | Target |
|-------|--------|--------|
| <span style="color:#8ab4f8">Packages</span> | `packages/required.txt` + `apps.txt` | pacman / pikaur |
| <span style="color:#90a959">Dotfiles</span> | `home/` → symlinks | `$HOME` |
| <span style="color:#f4bf75">System</span> | `etc/` | `/etc` (tlp, udev, environment) |
| <span style="color:#aa759f">Services</span> | `manifests/systemd-user.txt` | user systemd |

---

## Desktop Stack

```
<span style="color:#aa759f">Compositor</span>   Hyprland (Lua config)
<span style="color:#aa759f">WM</span>           UWSM
<span style="color:#aa759f">Launcher</span>     Walker + Elephant
<span style="color:#aa759f">Bar</span>          Waybar
<span style="color:#aa759f">Terminal</span>     Kitty
<span style="color:#aa759f">Clipboard</span>    wl-clip-persist + Elephant history
<span style="color:#aa759f">Notifications</span> Dunst
<span style="color:#aa759f">Power</span>        TLP + hypridle
<span style="color:#aa759f">Login</span>        Hyprlogin
```

---

## Repository Layout

```
├── install.sh              <span style="color:#5d5d5d"># fresh machine restore</span>
├── backup.sh               <span style="color:#5d5d5d"># sync live configs back</span>
├── home/                   <span style="color:#5d5d5d"># → $HOME (symlinked)</span>
│   ├── .bin/               <span style="color:#5d5d5d"># custom scripts</span>
│   ├── .config/hypr/       <span style="color:#5d5d5d"># Hyprland Lua config</span>
│   ├── .config/waybar/     <span style="color:#5d5d5d"># bar config</span>
│   ├── .config/walker/     <span style="color:#5d5d5d"># launcher</span>
│   ├── .config/elephant/   <span style="color:#5d5d5d"># backend providers</span>
│   └── ...
├── etc/                    <span style="color:#5d5d5d"># → /etc (copied)</span>
│   ├── tlp.conf
│   ├── environment
│   └── udev/rules.d/
├── manifests/              <span style="color:#5d5d5d"># what to link & enable</span>
└── packages/               <span style="color:#5d5d5d"># what to install</span>
```

---

## Useful Commands

<span style="color:#90a959">**Back up current machine → repo:**</span>
```bash
cd ~/.dotfiles && ./backup.sh
```

<span style="color:#8ab4f8">**Dry-run a restore (no changes):**</span>
```bash
./install.sh --dry-run
```

<span style="color:#f4bf75">**Restore everything including full package snapshot:**</span>
```bash
./install.sh --all-packages --yes
```

---

## Notes

- <span style="color:#ac4142">Do not run as root.</span> Uses `sudo` internally for `/etc` and package ops.
- Hyprland plugins are <span style="color:#f4bf75">not</span> auto-installed — manage them explicitly with `hyprpm`.
- After restore: `systemctl --user --failed` to verify services.
- Sensitive data (keys, tokens, session state) is gitignored and never committed.

---

<p align="center" style="color:#5d5d5d">
  <span style="color:#75b5aa">─</span> maintained by <span style="color:#8ab4f8">ron</span> <span style="color:#75b5aa">─</span>
</p>

#!/usr/bin/env bash
set -Eeuo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
HOME_MANIFEST="$REPO_DIR/manifests/home.txt"
SYSTEMD_MANIFEST="$REPO_DIR/manifests/systemd-user.txt"
INSTALL_PACKAGES=1
INSTALL_ALL_PACKAGES=0
INSTALL_SYSTEM=1
ENABLE_SERVICES=1
DRY_RUN=0
ASSUME_YES=0
PACKAGE_FAILURES=()

usage() {
  cat <<'USAGE'
Usage: ./install.sh [options]

Restore this repository on an Arch Linux installation.

Options:
  --no-packages   Skip package installation.
  --all-packages  Also restore explicit-native/explicit-foreign package snapshots.
  --no-system     Do not install /etc/tlp.conf or udev rules.
  --no-services   Do not enable user/system services.
  --yes           Pass non-interactive confirmation flags where supported.
  --dry-run       Print actions without changing the system.
  -h, --help      Show this help.

Run this script as your normal user, not root.
USAGE
}

log()  { printf '[install] %s\n' "$*"; }
warn() { printf '[install] warning: %s\n' "$*" >&2; }
run() {
  if ((DRY_RUN)); then
    printf '[install] +'; printf ' %q' "$@"; printf '\n'
  else
    "$@"
  fi
}

while (($#)); do
  case "$1" in
    --no-packages) INSTALL_PACKAGES=0 ;;
    --all-packages) INSTALL_ALL_PACKAGES=1 ;;
    --no-system) INSTALL_SYSTEM=0 ;;
    --no-services) ENABLE_SERVICES=0 ;;
    --yes) ASSUME_YES=1 ;;
    --dry-run) DRY_RUN=1 ;;
    -h|--help) usage; exit 0 ;;
    *) warn "unknown option: $1"; usage >&2; exit 2 ;;
  esac
  shift
done

if ((EUID == 0)); then
  warn "do not run install.sh as root; it needs your real HOME and user systemd instance"
  exit 1
fi

if [[ ! -f /etc/arch-release ]] && command -v pacman >/dev/null 2>&1; then
  warn "pacman exists but /etc/arch-release is missing; proceeding as an Arch-like system"
elif [[ ! -f /etc/arch-release ]] && ((INSTALL_PACKAGES)); then
  warn "this package installer targets Arch Linux; use --no-packages on other distributions"
  exit 1
fi

manifest_paths() {
  local file=$1 line
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -n "$line" ]] && printf '%s\n' "$line"
  done < "$file"
}

PACMAN_CONFIRM=()
AUR_CONFIRM=()
if ((ASSUME_YES)); then
  PACMAN_CONFIRM=(--noconfirm)
  AUR_CONFIRM=(--noconfirm)
fi

ensure_bootstrap() {
  log "updating package metadata and installing bootstrap tools"
  run sudo pacman -Syu --needed "${PACMAN_CONFIRM[@]}" base-devel git rsync
}

ensure_pikaur() {
  command -v pikaur >/dev/null 2>&1 && return 0
  if ((DRY_RUN)); then
    log "would bootstrap pikaur from the AUR"
    return 0
  fi
  local tmp
  tmp="$(mktemp -d)"
  trap 'rm -rf -- "${tmp:-}"' RETURN
  git clone --depth 1 https://aur.archlinux.org/pikaur.git "$tmp/pikaur"
  (
    cd "$tmp/pikaur"
    makepkg -si --needed "${PACMAN_CONFIRM[@]}"
  )
  rm -rf -- "$tmp"
  trap - RETURN
}

install_package_file() {
  local file=$1 label=$2 pkg
  [[ -f "$file" ]] || return 0
  local -a official=() aur=()

  while IFS= read -r pkg; do
    if pacman -Si -- "$pkg" >/dev/null 2>&1; then
      official+=("$pkg")
    else
      aur+=("$pkg")
    fi
  done < <(manifest_paths "$file")

  if ((${#official[@]})); then
    log "installing $label packages from Arch repositories (${#official[@]})"
    if ! run sudo pacman -S --needed "${PACMAN_CONFIRM[@]}" "${official[@]}"; then
      warn "one or more repository packages failed in $file"
      PACKAGE_FAILURES+=("$file:repository")
    fi
  fi

  if ((${#aur[@]})); then
    ensure_pikaur
    log "installing $label packages via pikaur/AUR (${#aur[@]})"
    for pkg in "${aur[@]}"; do
      if ! run pikaur -S --needed "${AUR_CONFIRM[@]}" -- "$pkg"; then
        warn "package failed: $pkg"
        PACKAGE_FAILURES+=("$pkg")
      fi
    done
  fi
}

if ((INSTALL_PACKAGES)); then
  ensure_bootstrap
  install_package_file "$REPO_DIR/packages/required.txt" "required"
  install_package_file "$REPO_DIR/packages/apps.txt" "desktop application"
  if ((INSTALL_ALL_PACKAGES)); then
    install_package_file "$REPO_DIR/packages/explicit-native.txt" "explicit native snapshot"
    install_package_file "$REPO_DIR/packages/explicit-foreign.txt" "explicit foreign snapshot"
  fi
fi

STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_ROOT="$HOME/.dotfiles-backup/$STAMP"
BACKUP_USED=0

backup_existing() {
  local dst=$1 rel=$2 backup="$BACKUP_ROOT/$rel"
  [[ -e "$dst" || -L "$dst" ]] || return 0
  run mkdir -p -- "$(dirname -- "$backup")"
  run mv -- "$dst" "$backup"
  BACKUP_USED=1
  log "backed up existing ~/$rel"
}

link_path() {
  local rel=$1 src="$REPO_DIR/home/$rel" dst="$HOME/$rel"
  if [[ ! -e "$src" && ! -L "$src" ]]; then
    warn "manifest source missing, skipping: home/$rel"
    return 0
  fi

  if [[ -L "$dst" ]]; then
    local current
    current="$(readlink -f -- "$dst" 2>/dev/null || true)"
    if [[ "$current" == "$(readlink -f -- "$src" 2>/dev/null || realpath -m -- "$src")" ]]; then
      log "already linked: ~/$rel"
      return 0
    fi
  fi

  backup_existing "$dst" "$rel"
  run mkdir -p -- "$(dirname -- "$dst")"
  run ln -s -- "$src" "$dst"
  log "linked: ~/$rel"
}

log "linking managed home paths"
while IFS= read -r rel; do
  link_path "$rel"
done < <(manifest_paths "$HOME_MANIFEST")

if ((INSTALL_SYSTEM)); then
  log "installing system configuration"
  if [[ -f "$REPO_DIR/etc/tlp.conf" ]]; then
    if [[ -e /etc/tlp.conf ]]; then
      run sudo cp -a -- /etc/tlp.conf "/etc/tlp.conf.dotfiles-$STAMP.bak"
    fi
    run sudo install -Dm644 -- "$REPO_DIR/etc/tlp.conf" /etc/tlp.conf
  fi
  if [[ -d "$REPO_DIR/etc/udev/rules.d" ]]; then
    while IFS= read -r -d '' rule; do
      run sudo install -Dm644 -- "$rule" "/etc/udev/rules.d/$(basename -- "$rule")"
    done < <(find "$REPO_DIR/etc/udev/rules.d" -maxdepth 1 -type f -name '*.rules' -print0)
    if command -v udevadm >/dev/null 2>&1; then
      run sudo udevadm control --reload-rules
    fi
  fi
fi

if ((ENABLE_SERVICES)); then
  if command -v systemctl >/dev/null 2>&1; then
    log "refreshing user systemd units"
    run systemctl --user daemon-reload || warn "could not reload user systemd manager"
    if [[ -f "$SYSTEMD_MANIFEST" ]]; then
      while IFS= read -r unit; do
        if ((DRY_RUN)) || systemctl --user cat -- "$unit" >/dev/null 2>&1; then
          run systemctl --user enable -- "$unit" || warn "could not enable user unit: $unit"
        else
          warn "user unit not installed, skipping: $unit"
        fi
      done < <(manifest_paths "$SYSTEMD_MANIFEST")
    fi

    if ((INSTALL_SYSTEM)) && systemctl list-unit-files tlp.service >/dev/null 2>&1; then
      run sudo systemctl enable --now tlp.service || warn "could not enable tlp.service"
    fi
  fi
fi

if command -v pkgfile >/dev/null 2>&1; then
  run sudo pkgfile --update || warn "pkgfile database update failed"
fi

if [[ -x "$HOME/.bin" ]]; then :; fi
if [[ -d "$HOME/.bin" ]]; then
  find "$HOME/.bin" -maxdepth 1 -type f -exec chmod u+x {} + 2>/dev/null || true
fi
if [[ -d "$HOME/.config/hypr/scripts" ]]; then
  find "$HOME/.config/hypr/scripts" -maxdepth 1 -type f -name '*.sh' -exec chmod u+x {} + 2>/dev/null || true
fi

printf '\n'
log "restore complete"
if ((BACKUP_USED)); then
  log "previous files were saved under: $BACKUP_ROOT"
fi
if ((${#PACKAGE_FAILURES[@]})); then
  warn "some optional/package restores failed: ${PACKAGE_FAILURES[*]}"
fi
log "log out/in before judging session services; Hyprland plugins are intentionally not auto-installed"

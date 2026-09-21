#!/usr/bin/env dash
# Event-driven media pause/resume helper for hypridle.
# Short-lived only: no sleeps, resident watcher, or process-polling loop.

runtime_dir=${XDG_RUNTIME_DIR:-/tmp}
state_file="$runtime_dir/hypr-media-paused"
lock_file="$runtime_dir/hypr-media-state.lock"
action=${1:-pause}

# Serialize overlapping lock/sleep events without ever waiting for another instance.
exec 9>"$lock_file" || exit 0
flock -n 9 || exit 0

pause_players() {
    # A second lock notification can arrive while already locked. Keep the first state.
    [ -e "$state_file" ] && return 0

    : > "$state_file" || return 0

    playerctl -l 2>/dev/null | while IFS= read -r player; do
        [ -n "$player" ] || continue
        status=$(playerctl -p "$player" status 2>/dev/null) || status=''
        [ "$status" = 'Playing' ] && printf '%s\n' "$player" >> "$state_file"
    done

    # One command pauses all players; only previously-playing players are restored later.
    playerctl -a pause >/dev/null 2>&1 || true
}

resume_players() {
    [ -e "$state_file" ] || return 0

    # Remove the marker first so a new lock event can establish fresh state immediately.
    saved_state="$state_file.resume.$$"
    mv "$state_file" "$saved_state" 2>/dev/null || return 0

    while IFS= read -r player; do
        [ -n "$player" ] || continue
        playerctl -p "$player" play >/dev/null 2>&1 || true
    done < "$saved_state"

    rm -f "$saved_state"
}

case "$action" in
    pause)  pause_players ;;
    resume) resume_players ;;
    *)
        printf 'usage: %s {pause|resume}\n' "${0##*/}" >&2
        exit 2
        ;;
esac

repos=$(checkupdates 2>/dev/null && pikaur -Qua 2>/dev/null)
dunstify -u low "Available Updates" "$repos"

repos=$(checkupdates 2>/dev/null && pikaur -Qua 2>/dev/null)
dunstify -u low -t 0 "Available Updates" "$repos"

repos=$(checkupdates 2>/dev/null && pikaur -Qua 2>/dev/null)
dunstify -u low -t 30 "Available Updates" "$repos"
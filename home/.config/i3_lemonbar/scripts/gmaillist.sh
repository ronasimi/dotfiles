
#!/bin/bash

. ~/.private/accounts

# Arbitrary but unique message id
msgId="991090"
dunstify -u low -t 30000 -r "$msgId" "Fetching gmail..."
mail=$(curl -u $MAIL_USER:$MAIL_PASS --silent "https://mail.google.com/mail/feed/atom" | grep -oPm1 "(?<=<title>)[^<]+" | sed '1d')
dunstify -u low -t 20000 -r "$msgId" "Unread emails:" "$mail"

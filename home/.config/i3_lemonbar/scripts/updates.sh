#!/bin/bash
# check for package and aur updates
sleep 60

wget -q --spider http://www.archlinux.org

if [ $? -eq 0 ]; then
  pkg=$(checkupdates 2>/dev/null | sed '/^\s*$/d' | wc -l)
  aur=$(pikaur -Qua 2>/dev/null | sed '/^\s*$/d' | wc -l)
  upd=$(($pkg + $aur))
else
  upd="err"
fi

echo ${upd}

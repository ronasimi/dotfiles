#!/bin/bash
# check for package and aur updates

  pkg=$(checkupdates | sed '/^\s*$/d' | wc -l)
  aur=$(pikaur -Qua 2>/dev/null | sed '/^\s*$/d' | wc -l)
  upd=$(($pkg + $aur))

  echo ${upd}

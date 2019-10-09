#!/bin/sh
case $1/$2 in
  pre/*)
    touch /tmp/brightness-value
    xbacklight -get > /tmp/brightness-value
  ;;
  post/*)
    xbacklight -set $(cat /tmp/brightness-value)
    rm /tmp/brightness-value
  ;;
esac

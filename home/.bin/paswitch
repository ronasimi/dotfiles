#!/bin/bash

case "${1:-}" in
  (""|list)
    pacmd list-sinks |
      grep -E 'index:|name:'
    ;;
  ([0-9]*)
    echo switching default
    pacmd set-default-sink $1 ||
      echo failed
    echo switching applications
    pacmd list-sink-inputs |
      awk '/index:/{print $2}' |
      xargs -r -I{} pacmd move-sink-input {} $1 ||
        echo failed
    ;;
  (*)
    echo "Usage: $0 [|list|<sink name to switch to>]"
    ;;
esac

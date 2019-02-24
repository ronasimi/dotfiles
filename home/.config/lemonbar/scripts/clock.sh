#!/bin/bash

uniq_linebuffered() {
  awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
  }

# This loop will fill a buffer with our infos, and output it to stdout.
while true ; do
   # "date" output is checked once a second, but an event is only
   # generated if the output changed compared to the previous run.
stdbuf -oL date +"%R"
   sleep 3 || break
done > >(uniq_linebuffered) &


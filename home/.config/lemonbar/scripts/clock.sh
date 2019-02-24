#!/bin/bash

uniq_linebuffered() {
  awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
  }

# This loop will fill a buffer with our infos, and output it to stdout.
while true ; do
   # "date" output is checked once a second, but an event is only
   # generated if the output changed compared to the previous run.
date +"%R"
   sleep 1 || break
done > >(uniq_linebuffered) &


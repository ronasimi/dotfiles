#!/bin/bash
# This loop will fill a buffer with our infos, and output it to stdout.
# "time" output is checked every 3 seconds, but an event is only
# generated if the output changed compared to the previous run.

uniq_linebuffered() {
    awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
    }


while true ; do

    echo "CLK$(date +%R)"
    sleep 4 || break

done > >(uniq_linebuffered) &

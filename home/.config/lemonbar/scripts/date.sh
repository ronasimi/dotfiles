#!/bin/bash
# This loop will fill a buffer with our infos, and output it to stdout.
# "date" output is checked every 7 seconds, but an event is only
# generated if the output changed compared to the previous run.

uniq_linebuffered() {
    awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
    }


while true ; do
    echo "DAY$(date +"%a %b %d")"
    sleep 7 || break

done > >(uniq_linebuffered) &

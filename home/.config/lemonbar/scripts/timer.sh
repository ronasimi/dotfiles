#!/bin/bash
# This loop will fill a buffer with our infos, and output it to stdout.
# "timer" executable outputs the current minute every seconds but an event is only
# generated if the output changed compared to the previous run.

uniq_linebuffered() {
  awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
    }

$(dirname $0)/timer | (uniq_linebuffered)

#!/bin/bash
# This loop will fill a buffer with our infos, and output it to stdout.
# "date" output is checked every 3 seconds, but an event is only
# generated if the output changed compared to the previous run.

uniq_linebuffered() {
  awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
    }

tm() {
  date +%M; sleep 3; tm;
    };tm | (uniq_linebuffered)

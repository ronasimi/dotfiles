#! /bin/bash
# output time to panel_fifo for i3_lemonbar

# config
panel_fifo="/tmp/i3_lemonbar_${USER}"

"$(dirname $0)"/scripts/date >"${panel_fifo}" &
"$(dirname $0)"/scripts/clock >"${panel_fifo}" &

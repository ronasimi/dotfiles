#!/bin/bash
#output time to panel_fifo for i3_lemonbar

# config
. "$(dirname $0)"/../i3_lemonbar_config

# kill any existing processes
killall date 2>/dev/null
killall clock 2>/dev/null

"$(dirname $0)"/date >"${panel_fifo}" &
"$(dirname $0)"/clock >"${panel_fifo}" &

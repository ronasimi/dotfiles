#!/bin/bash

# First we append the saved layout of worspace N to workspace M
i3-msg "workspace 1:; append_layout ~/.config/i3/layouts/ws1.json"

# And finally we fill the containers with the programs they had
(exec chromium &)
sleep 0.5
(exec chromium --incognito &)

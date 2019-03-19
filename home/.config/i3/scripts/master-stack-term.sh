#!/bin/bash

# First we append the saved layout of worspace N to workspace M
i3-msg "workspace 2:; append_layout ~/.config/i3/layouts/master-stack.json"

# And finally we fill the containers with the programs they had
(urxvtc &)
(urxvtc &)
(urxvtc &)

#!/bin/bash

# First we append the saved layout of worspace N to workspace M
i3-msg "workspace 4:; append_layout ~/.config/i3/layouts/ws4.json"

# And finally we fill the containers with the programs they had
(exec atom &)
(alacritty --working-directory /home/ron/repos &)

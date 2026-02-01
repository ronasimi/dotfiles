#!/bin/bash

# Define an array of commands/scripts to run
COMMANDS=(
    "./food --burger"
    "./food --coffee"
    "./food --hotcoffee"
    "./food --pancakes"
    "./food --pizza"
    "./food --pizza2"
    "./food --poptart"
    "./food --rice"
    "./food --vburger"
    "./food --waffles"
)

# Get the number of commands in the array
NUM_COMMANDS=${#COMMANDS[@]}

# Generate a random index between 0 and NUM_COMMANDS-1
RANDOM_INDEX=$(( RANDOM % NUM_COMMANDS ))

# Select the random command and execute it
SELECTED_CMD=${COMMANDS[$RANDOM_INDEX]}
$SELECTED_CMD
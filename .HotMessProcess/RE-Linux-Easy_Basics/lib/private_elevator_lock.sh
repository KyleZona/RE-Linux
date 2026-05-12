#!/bin/bash

source "$GAME_DIR/lib/typewriter_regular.sh"

typewriter_regular 'CLEARANCE LEVEL NEEDED FOR ELEVATOR.'
typewriter_regular 'PLEASE ENTER CLEARANCE LEVEL:'

read -sp "Password: " input

if [ "$input" = "Executive" ]; then
	sed -i 's/PRIVATE_ELEVATOR_UNLOCKED=false/PRIVATE_ELEVATOR_UNLOCKED=true/' "$GAME_DIR/.gamestate"
	exit 0
else
	echo "  CLEARANCE LEVEL INVALID!"
	exit 1
fi

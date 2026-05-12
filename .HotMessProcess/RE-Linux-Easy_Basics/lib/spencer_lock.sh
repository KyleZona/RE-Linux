#!/bin/bash

source "$GAME_DIR/.gamestate"
echo "LOCKED: Enter Owner's Last Name"
read -s input
if [ "$input" = "spencer" ]; then
	sed -i 's/SPENCER_UNLOCKED=false/SPENCER_UNLOCKED=true/' "$GAME_DIR/.gamestate"
	exit 0
else
	source "$GAME_DIR/lib/attempt_failed.sh"
	exit 1
fi

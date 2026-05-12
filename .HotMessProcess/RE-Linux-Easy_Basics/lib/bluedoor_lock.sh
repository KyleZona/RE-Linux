#!/bin/bash

source "$GAME_DIR/.gamestate"
echo "LOCKED: Enter Password"
read -s input
if [ "$input" = "itchytasty" ]; then
	sed -i 's/BLUEDOOR_UNLOCKED=false/BLUEDOOR_UNLOCKED=true/' "$GAME_DIR/.gamestate"
	exit 0
else
	echo "		INCORRECT PASSWORD!"
	sleep 0.5
	exit 1
fi

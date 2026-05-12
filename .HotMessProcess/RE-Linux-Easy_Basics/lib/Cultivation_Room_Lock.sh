#!/bin/bash

source "$GAME_DIR/lib/typewriter_regular.sh"

typewriter_regular '  PLEASE PROVIDE MEDAL NAME:'

read -sp "Password: " input

if [ "$input" = "eagle" ]; then
	exit 0
else
	echo "  INCORRECT PASSWORD!"
	exit 1
fi

#!/bin/bash

source "$GAME_DIR/lib/typewriter_dramatic.sh"

# read current attempts from .gamestate
attempts=$(grep "SPENCER_ATTEMPTS" "$GAME_DIR/.gamestate" | cut -d'=' -f2)

# increment by 1
attempts=$((attempts + 1))

# write new value back to .gamestate
sed -i "s/SPENCER_ATTEMPTS=.*/SPENCER_ATTEMPTS=$attempts/" "$GAME_DIR/.gamestate"

# if 2nd failed attempt, fire death
if [ "$attempts" -ge 2 ]; then
	source "$GAME_DIR/lib/death.sh"
else
	# first fail, play the warning scene then re-prompt
	typewriter_dramatic ''
	typewriter_dramatic '  Rabid dogs stopped a few feet away.'
	typewriter_dramatic '  Growling, readying to charge . . .'
	sleep 0.5
	typewriter_dramatic '  Jill looked back to the screen and read:'
	typewriter_dramatic ''
	typewriter_dramatic '    FAILED ATTEMPT.'
	typewriter_dramatic '      ONLY ONE MORE ALLOWED . . .'
	typewriter_dramatic ''

	# re-prompt password
	bash "$GAME_DIR/lib/spencer_lock.sh"
	exit $?
fi

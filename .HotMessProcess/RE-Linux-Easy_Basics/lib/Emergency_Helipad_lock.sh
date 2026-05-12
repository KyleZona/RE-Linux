#!/bin/bash

source "$GAME_DIR/.gamestate"

if [ "$CHRIS_RESCUED" = "true" ]; then
	bash "$GAME_DIR/lib/ThreeSurvivors.sh"
else
	bash "$GAME_DIR/lib/TwoSurvivors.sh"
fi

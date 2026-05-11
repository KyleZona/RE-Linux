source "$GAME_DIR/.gamestate"

if [ "$CHRIS_RESCUED" = "true" ]; then
	source "$GAME_DIR/.Game_Files/Scenes/ThreeSurvivors.sh"
else
	source "$GAME_DIR/.Game_Files/Scenes/TwoSurvivors.sh"
fi

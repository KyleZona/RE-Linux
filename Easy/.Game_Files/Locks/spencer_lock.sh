source "$GAME_DIR/.gamestate"
echo "LOCKED: Enter Owner's Last Name"
echo -n "Password: "
read input
if [ "$input" = "spencer" ]; then
	sed -i 's/SPENCER_UNLOCKED=false/SPENCER_UNLOCKED=true/' "$GAME_DIR/.gamestate"
	return 0
else
	source "$GAME_DIR/.Game_Files/Scenes/attempt_failed.sh"
	return $?
fi

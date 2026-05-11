source "$GAME_DIR/.gamestate"
echo "LOCKED: Enter Password"
echo -n "Password: "
read input
if [ "$input" = "LOCKPICK" ]; then
	sed -i 's/BROWNDOOR_UNLOCKED=false/BROWNDOOR_UNLOCKED=true/' "$GAME_DIR/.gamestate"
	return 0
else
	echo "		INCORRECT PASSWORD!"
	sleep 0.5
	return 1
fi

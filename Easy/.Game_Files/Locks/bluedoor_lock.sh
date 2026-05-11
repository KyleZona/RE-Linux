source "$GAME_DIR/.gamestate"
echo "LOCKED: Enter Password"
echo -n "Password: "
read input
if [ "$input" = "itchytasty" ]; then
	sed -i 's/BLUEDOOR_UNLOCKED=false/BLUEDOOR_UNLOCKED=true/' "$GAME_DIR/.gamestate"
	return 0
else
	echo "		INCORRECT PASSWORD!"
	sleep 0.5
	return 1
fi

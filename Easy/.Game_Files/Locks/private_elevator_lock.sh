source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

typewriter_regular 'CLEARANCE LEVEL NEEDED FOR ELEVATOR.'
typewriter_regular 'PLEASE ENTER CLEARANCE LEVEL:'

echo -n "Password: "
read input

if [ "$input" = "Executive" ]; then
	sed -i 's/PRIVATE_ELEVATOR_UNLOCKED=false/PRIVATE_ELEVATOR_UNLOCKED=true/' "$GAME_DIR/.gamestate"
	return 0
else
	echo "  CLEARANCE LEVEL INVALID!"
	return 1
fi

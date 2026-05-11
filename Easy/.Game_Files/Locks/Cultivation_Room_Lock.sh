source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

typewriter_regular '  PLEASE PROVIDE MEDAL NAME:'

echo -n "Password: "
read input

if [ "$input" = "eagle" ]; then
	return 0
else
	echo "  INCORRECT PASSWORD!"
	return 1
fi

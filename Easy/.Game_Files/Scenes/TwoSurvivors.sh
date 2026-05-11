source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

clear
typewriter_regular ""
typewriter_regular "    Outside, the Emergency_Helipad was boxed in, hidden among the trees with"
typewriter_regular "    the sounds of a helicopter in the distance. The sun was starting to rise,"
typewriter_regular "    and Jill estimated that Brad was running out of fuel..."
typewriter_regular ""
typewriter_regular "    In the corner, Jill spotted a red framed box with a bright orange flare"
typewriter_regular "    gun inside. Grabbing it, she fired into the sky. Hope filled them both"
typewriter_regular "    as the sound of the helicopter got louder."
typewriter_regular ""
typewriter_regular "    Then an explosion in the opposite corner."
typewriter_regular ""
typewriter_regular "    The sun, rising over the mountain, cast fresh light on the chunks of"
typewriter_regular "    rubble that went flying among the large cloud of concrete dust."
typewriter_regular ""
typewriter_regular "    Jill and Barry stared at the large black hole as the Tyrant leapt out"
typewriter_regular "    and above their heads. Landing on his feet, his eyes locked on to Jill."
typewriter_regular "    Barry raised his gun to fire -- nothing. He looked down at his Colt .45."
typewriter_regular ""
typewriter_regular "        BARRY: Shit! I'm empty! Jill!!"
typewriter_regular ""
typewriter_regular "    Jill dove away as the Tyrant dashed between them with its claw"
typewriter_regular "    jutting out. The Tyrant stood, towering, looking from one to the other."
typewriter_regular "    Deciding which one to annihilate first."
typewriter_regular ""
typewriter_regular "        BRAD: USE THIS! KILL THAT MONSTER!"
typewriter_regular ""
typewriter_regular "    Jill looked up to see Brad descending overhead. A large green box"
typewriter_regular "    fell from the open doors. She recognized the box, which had a bright"
typewriter_regular "    yellow sticker on all sides that read: TO FIRE ENTER: rocket_launcher."
typewriter_regular ""
typewriter_regular "        BARRY: Hey! Big guy!"
typewriter_regular ""
typewriter_regular "    Jill watched as Barry distracted the Tyrant, and she knew that right"
typewriter_regular "    now was her moment... She hurried to the box, opening it to pull out"
typewriter_regular "    the big weapon."
typewriter_regular ""

echo -n "Password: "
read input

if [ "$input" = "rocket_launcher" ]; then
	roll=$((RANDOM % 100))
	if [ $roll -lt 35 ]; then
		source "$GAME_DIR/.Game_Files/Scenes/End-Game/good/good_ending.sh"
	else
		source "$GAME_DIR/.Game_Files/Scenes/End-Game/bad/bad_ending.sh"
	fi
else
	typewriter_regular 'Jill pulled the trigger.'
	typewriter_regular 'But nothing fired.'
	typewriter_regular 'She looked back down and'
	typewriter_regular 'TO FIRE ENTER: rocket_launcher'
	echo -n "Password: "
	read input2
	if [ "$input2" = "rocket_launcher" ]; then
		roll=$((RANDOM % 100))
		if [ $roll -lt 35 ]; then
			source "$GAME_DIR/.Game_Files/Scenes/End-Game/good/good_ending.sh"
		else
			source "$GAME_DIR/.Game_Files/Scenes/End-Game/bad/bad_ending.sh"
		fi
	else
		typewriter_regular 'Jill was trying to enter'
		typewriter_regular 'the password, but her fingers'
		typewriter_regular 'went numb, and a large claw'
		typewriter_regular 'had burst from her chest. . .'
		source "$GAME_DIR/.Game_Files/Scenes/death.sh"
	fi
fi

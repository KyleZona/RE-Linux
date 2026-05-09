#!/bin/bash

# apply_updates.sh
# Run from inside ~/RE-Linux/Easy:
#   source apply_updates.sh
#
# Creates all .Game_Files structure and writes every corrected file in place.

GAME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Applying updates to: $GAME_DIR"

# ─── Create directory structure ───────────────────────────────────────────────

mkdir -p "$GAME_DIR/.Game_Files/Locks"
mkdir -p "$GAME_DIR/.Game_Files/Scenes/End-Game/good"
mkdir -p "$GAME_DIR/.Game_Files/Scenes/End-Game/bad"
mkdir -p "$GAME_DIR/.Game_Files/Scenes/End-Game/great"
mkdir -p "$GAME_DIR/.Game_Files/Design"

mkdir -p "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/.private_elevator/Umbrella_Laboratory/Holding_Cells/Cell_1"
mkdir -p "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/.private_elevator/Umbrella_Laboratory/Holding_Cells/Cell_2"
mkdir -p "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/.private_elevator/Umbrella_Laboratory/Holding_Cells/Cell_3"
mkdir -p "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/.private_elevator/Umbrella_Laboratory/Holding_Cells/Cell_4"
mkdir -p "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/.private_elevator/Umbrella_Laboratory/Holding_Cells/Cell_5"

echo "  directories created"

# ─── Design ───────────────────────────────────────────────────────────────────

cat > "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh" << 'ENDOFFILE'
typewriter_regular() {
    local text="$1"
    local delay="${2:-0.05}"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo
}
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Design/typewriter_dramatic.sh" << 'ENDOFFILE'
typewriter_dramatic() {
    local text="$1"
    local delay="${2:-0.09}"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo
    sleep 0.6
}
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Design/gamestate_default" << 'ENDOFFILE'
# DO NOT ADJUST, this is core to the game

SPENCER_ATTEMPTS=0
ENTER_MANSION_COMPLETE=false
SPENCER_UNLOCKED=false
SEARCH_WESKER_PLAYED=false
DOUBLEDOORS_VISITED=false
BROWNDOOR_UNLOCKED=false
BLUEDOOR_UNLOCKED=false
PRIVATE_ELEVATOR_UNLOCKED=false
UMBRELLA_LAB_VISITED=false
RESEARCH_OFFICE_VISITED=false
SUSPECT_WESKER_PLAYED=false
CHRIS_RESCUED=false
CULTIVATION_COMPLETE=false
ENDOFFILE

echo "  Design files written"

# ─── Locks ────────────────────────────────────────────────────────────────────

cat > "$GAME_DIR/.Game_Files/Locks/spencer_lock.sh" << 'ENDOFFILE'
source "$GAME_DIR/.gamestate"
echo "LOCKED: Enter Owner's Last Name"
read -p "Password: " input
if [ "$input" = "spencer" ]; then
	sed -i 's/SPENCER_UNLOCKED=false/SPENCER_UNLOCKED=true/' "$GAME_DIR/.gamestate"
	return 0
else
	source "$GAME_DIR/.Game_Files/Scenes/attempt_failed.sh"
	return 1
fi
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Locks/browndoor_lock.sh" << 'ENDOFFILE'
source "$GAME_DIR/.gamestate"
echo "LOCKED: Enter Password"
read -p "Password: " input
if [ "$input" = "LOCKPICK" ]; then
	sed -i 's/BROWNDOOR_UNLOCKED=false/BROWNDOOR_UNLOCKED=true/' "$GAME_DIR/.gamestate"
	return 0
else
	echo "		INCORRECT PASSWORD!"
	sleep 0.5
	return 1
fi
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Locks/bluedoor_lock.sh" << 'ENDOFFILE'
source "$GAME_DIR/.gamestate"
echo "LOCKED: Enter Password"
read -p "Password: " input
if [ "$input" = "itchytasty" ]; then
	sed -i 's/BLUEDOOR_UNLOCKED=false/BLUEDOOR_UNLOCKED=true/' "$GAME_DIR/.gamestate"
	return 0
else
	echo "		INCORRECT PASSWORD!"
	sleep 0.5
	return 1
fi
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Locks/private_elevator_lock.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

typewriter_regular 'CLEARANCE LEVEL NEEDED FOR ELEVATOR.'
typewriter_regular 'PLEASE ENTER CLEARANCE LEVEL:'

read -p "Password: " input

if [ "$input" = "Executive" ]; then
	sed -i 's/PRIVATE_ELEVATOR_UNLOCKED=false/PRIVATE_ELEVATOR_UNLOCKED=true/' "$GAME_DIR/.gamestate"
	return 0
else
	echo "  CLEARANCE LEVEL INVALID!"
	return 1
fi
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Locks/Cultivation_Room_Lock.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

typewriter_regular '  PLEASE PROVIDE MEDAL NAME:'

read -p "Password: " input

if [ "$input" = "eagle" ]; then
	return 0
else
	echo "  INCORRECT PASSWORD!"
	return 1
fi
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Locks/Emergency_Helipad_lock.sh" << 'ENDOFFILE'
source "$GAME_DIR/.gamestate"

if [ "$CHRIS_RESCUED" = "true" ]; then
	source "$GAME_DIR/.Game_Files/Scenes/ThreeSurvivors.sh"
else
	source "$GAME_DIR/.Game_Files/Scenes/TwoSurvivors.sh"
fi
ENDOFFILE

echo "  Lock files written"

# ─── Scenes ───────────────────────────────────────────────────────────────────

cat > "$GAME_DIR/.Game_Files/Scenes/attempt_failed.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_dramatic.sh"

# read current attempts from .gamestate
attempts=$(grep "SPENCER_ATTEMPTS" "$GAME_DIR/.gamestate" | cut -d'=' -f2)

# increment by 1
attempts=$((attempts + 1))

# write new value back to .gamestate
sed -i "s/SPENCER_ATTEMPTS=.*/SPENCER_ATTEMPTS=$attempts/" "$GAME_DIR/.gamestate"

# if 2nd failed attempt, fire death
if [ "$attempts" -ge 2 ]; then
	source "$GAME_DIR/.Game_Files/Scenes/death.sh"
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

	# re-prompt password (stay in source, no subshell)
	source "$GAME_DIR/.Game_Files/Locks/spencer_lock.sh"
	return $?
fi
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Scenes/death.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
source "$GAME_DIR/.Game_Files/Design/typewriter_dramatic.sh"

clear
typewriter_dramatic ""
typewriter_dramatic "  YOU"
typewriter_dramatic "  ARE"
typewriter_dramatic "  DEAD"
typewriter_dramatic ""
sleep 0.5
typewriter_dramatic ""
typewriter_dramatic "  Checking for memory card . . ."
typewriter_dramatic "     . . . checking . . ."
typewriter_dramatic "            . . . checking . . ."
typewriter_dramatic "  . . . No memory card inserted!"
typewriter_dramatic ""
sleep 0.5
clear

typewriter_regular ""
typewriter_regular "  G O O D"
typewriter_regular "  L U C K"
typewriter_regular "  N E X T"
typewriter_regular "  T I M E"
typewriter_regular "            :)"
typewriter_regular ""
echo ""
echo "  Reviewing the Commands"
echo ""
echo "  Command                    What It Does"
echo "  -------                    ------------"
echo "  ls                         List contents of the current directory"
echo "  ls -la                     List all contents, including hidden files"
echo "  ls -Ra                     List all contents recursively, including hidden files"
echo "  cd ./name                  Change into a directory"
echo "  cd ../                     Go back to the previous directory"
echo "  cat ./file.txt             Read a file"
echo "  pwd                        Print your current directory path"
echo "  man command                Read the manual for any command"
echo ""

# clean up and fully reset
function cd () { builtin cd "$@"; }
rm -f ~/.RE-Linux_env
cp "$GAME_DIR/.Game_Files/Design/gamestate_default" "$GAME_DIR/.gamestate"
sed -i '/RE-Linux_env/d' ~/.bashrc
echo "  Press Enter to exit . . ."
read _
builtin cd "$GAME_DIR"
return 1
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Scenes/opening.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

clear
typewriter_regular ''
typewriter_regular '                -- 1998 July -- Raccoon Forest'
sleep 0.5
typewriter_regular ''
typewriter_regular '  Chris Redfield: Alpha Team is flying around the forest'
typewriter_regular '  zone, situated in northwest Raccoon City, where we are'
typewriter_regular '  searching for the helicopter of our compatriots'
typewriter_regular '  Bravo Team, who disappeared during the middle of their'
typewriter_regular '  mission.'
sleep 0.3
typewriter_regular ''
typewriter_regular '      Captain Wesker: Anyone seeing anything?'
typewriter_regular '      Barry Burton: Nothing yet.'
sleep 0.5
typewriter_regular ''
typewriter_regular '  Chris: Bizarre murder cases have recently occurred in'
typewriter_regular '  Raccoon City. There are outlandish reports of families'
typewriter_regular '  being attacked by a group of about 10 people. Victims'
typewriter_regular '  were apparently eaten. Bravo Team went to the hideout'
typewriter_regular '  of the group, and disappeared.'
sleep 0.3
typewriter_regular ''
typewriter_regular '      Jill: Look, Chris!'
sleep 0.5
typewriter_regular ''
typewriter_regular "  Chris: It was Bravo Team's helicopter. Nobody was in it."
typewriter_regular '  But strangely, most of the equipment was still there.'
typewriter_regular '  However, we soon discovered why.'
sleep 0.3
typewriter_regular ''
typewriter_regular "  Joseph's scream tore through the clearing."
typewriter_regular '  In his hand -- a severed hand, still clutching a pistol.'
sleep 0.3
typewriter_regular ''
typewriter_regular '  Rabid beasts jumped from the tall grass, hitting Joseph'
typewriter_regular '  like a wave. The other four S.T.A.R.S. members spun'
typewriter_regular "  to see Joseph's final moments."
sleep 0.5
typewriter_regular ''
typewriter_regular '  Chris fired, snapping Jill out of pure shock. More rabid'
typewriter_regular '  beasts  appeared. The team took off running back to'
typewriter_regular '  the helicopter gaining some distance.'
sleep 0.3
typewriter_regular ''
typewriter_regular "      Chris: No! Don't go!"
sleep 0.5
typewriter_regular ''
typewriter_regular '  The helicopter flew off into the dark horizon, leaving'
typewriter_regular '  the team standing there. The rabid dogs were getting'
typewriter_regular '  closer...'
sleep 0.3
typewriter_regular ''
typewriter_regular '      Chris: Jill! Run for that house!'
typewriter_regular ''
typewriter_regular '  The four S.T.A.R.S. members sprinted through the thick'
typewriter_regular '  trees towards a soft glow. . . It was not a house,'
typewriter_regular "  it was a mansion. A perfect place to find saftey. . ."
typewriter_regular "  Except the doors didn't open. Hardly budged."
sleep 0.5
typewriter_regular ''
typewriter_regular '      cat ./Barry_Help.txt'
typewriter_regular ''
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Scenes/enter_mainhall.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
source "$GAME_DIR/.Game_Files/Design/typewriter_dramatic.sh"

clear
sleep 0.3
typewriter_dramatic ""
typewriter_dramatic "  They have escaped into the mansion, where they"
typewriter_dramatic "  thought it was safe . . ."
typewriter_dramatic ""
typewriter_dramatic "                        Yet . . ."
sleep 0.5
typewriter_regular ""
typewriter_regular "    Wesker: Wow, what a mansion!"
typewriter_regular ""
typewriter_regular "  They stood on a lush red rug that went from the large"
typewriter_regular "  front doors all the way up the grand staircase. Marble"
typewriter_regular "  floors caught bright flashes of thunder outside, booming"
typewriter_regular "  all around them in the large main hall."
typewriter_regular ""
typewriter_regular "    Jill: Captain Wesker, where's Chris?"
typewriter_regular "    Wesker: Stop it! Don't open that door!"
typewriter_regular "    Jill: But Chris is--"
typewriter_regular ""
typewriter_regular "  ...might be out there, Jill was saying but a gun went off"
typewriter_regular "  somewhere in the mansion, to the left, behind some"
typewriter_regular "  DoubleDoors."
typewriter_regular ""
typewriter_regular "    Barry: What is it?"
typewriter_regular "    Wesker: Maybe it's... Chris... Jill! Can you go?"
typewriter_regular ""
typewriter_regular "    Barry: I'm going with you."
typewriter_regular "        Chris is our old partner, ya know."
typewriter_regular ""
typewriter_regular "    Wesker: Stay alert!"
typewriter_regular ""
typewriter_regular "  Jill was relieved Barry was coming with her."
typewriter_regular "  And that he was bringing his Colt .45 with him."
typewriter_regular ""
typewriter_regular "    Barry: Remember those commands that got us in here?"
typewriter_regular "      Use them to change our directory to doubledoors"
typewriter_regular ""

sed -i 's/ENTER_MANSION_COMPLETE=false/ENTER_MANSION_COMPLETE=true/' "$GAME_DIR/.gamestate"
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Scenes/enter_doubledoors.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
source "$GAME_DIR/.gamestate"

if [ "$DOUBLEDOORS_VISITED" = "false" ]; then
clear
typewriter_regular ""
typewriter_regular "    Together Jill and Barry passed through the double doors"
typewriter_regular "    and entered a long, extravagant dining room. The storm"
typewriter_regular "    picked up outside. The air smelled.. of..."
typewriter_regular ""
typewriter_regular "        Barry: What? What is this? . . .Blood?"
typewriter_regular "          . . .Hope this is not Chris's blood..."
typewriter_regular ""
typewriter_regular "    Jill stood behind Barry who squatted down examining the"
typewriter_regular "    puddle of blood in front of him."
typewriter_regular ""
typewriter_regular "    A man crawled out from under the large dining table."
typewriter_regular "    The man stood, and raised his arms, covered in blood,"
typewriter_regular "    and groaned approaching Jill and Barry."
typewriter_regular ""
typewriter_regular "        Barry: Hey, you, stop!"
typewriter_regular ""
typewriter_regular "    The man didn't listen, only limped closer."
typewriter_regular "    His eyes completely cloudy, as if he were already dead."
typewriter_regular "    Behind him, Jill pointed to a body partially under the"
typewriter_regular "    table. . ."
typewriter_regular ""
typewriter_regular "    It was Kenneth, from S.T.A.R.S. Bravo Team. . ."
typewriter_regular "    his throat ripped out."
typewriter_regular ""
typewriter_regular "        Barry: He's insane!"
typewriter_regular ""
typewriter_regular "    Barry fired his Colt .45."
typewriter_regular "    The man . . . er, Zombie took one more step forward."
typewriter_regular "    Then their head popped like a balloon."
typewriter_regular ""
typewriter_regular "        Barry: What the hell?"
typewriter_regular ""
typewriter_regular "        Jill: Let's report this to Wesker!"
typewriter_regular "            How do we get back to that directory though?"
typewriter_regular ""
typewriter_regular "        Barry: you can always cat ./Barry_Help1.txt"
typewriter_regular ""
typewriter_regular "          HINT: some directories will have more then one"
typewriter_regular "          Help_Barry.txt, others will show up in time!"
typewriter_regular "          use command ls frequently!"
typewriter_regular ""
sed -i 's/DOUBLEDOORS_VISITED=false/DOUBLEDOORS_VISITED=true/' "$GAME_DIR/.gamestate"
fi
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Scenes/enter_browndoor.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

clear
typewriter_regular ""
typewriter_regular "			Barry: Jill, you really are the master of unlocking."
typewriter_regular ""
typewriter_regular "			Jill: Thanks, Barry."
typewriter_regular ""
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Scenes/enter_bluedoor.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

clear
typewriter_regular ""
typewriter_regular "        Barry: In that diary, they wrote about"
typewriter_regular "          there being a way out through here..."
typewriter_regular ""
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Scenes/enter_umbrella.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

clear
typewriter_regular ""
typewriter_regular "    The elevator doors opened with a pressurized hiss."
typewriter_regular ""
typewriter_regular "    Jill stepped out first. The floor was wet. Not from a leak —"
typewriter_regular "    the whole corridor was damp, like something lived down here."
typewriter_regular "    The lights above flickered and buzzed, casting everything in"
typewriter_regular "    a pale, sickly yellow. The walls had dark streaks running"
typewriter_regular "    down them that Jill chose not to think too hard about."
typewriter_regular ""
typewriter_regular "    Barry stepped out behind her, hand already on his Colt .45."
typewriter_regular ""
typewriter_regular "        Barry: Where are we?"
typewriter_regular ""
typewriter_regular "        Jill: An Umbrella Laboratory?"
typewriter_regular ""
typewriter_regular "        Barry: That huge pharmaceutical corporation?"
typewriter_regular "          What were they doing down here?"
typewriter_regular ""
typewriter_regular "        Jill: Creating those monsters..."
typewriter_regular ""
typewriter_regular "        Barry: Let's look around."
typewriter_regular ""
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Scenes/search_wesker.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
sed -i 's/SEARCH_WESKER_PLAYED=false/SEARCH_WESKER_PLAYED=true/' "$GAME_DIR/.gamestate"

clear
typewriter_regular ""
typewriter_regular "    Thunder roared again outside, heavy rain beat down on the"
typewriter_regular "    large windows that filled the. . . empty Main Hall."
typewriter_regular ""
typewriter_regular "        Barry: Wesker! Help me look for him, Jill."
typewriter_regular ""
typewriter_regular "    . . . . ."
typewriter_regular ""
typewriter_regular "        Barry: Find anything, Jill?"
typewriter_regular "        Jill: Nothing. What is this all about? I can't"
typewriter_regular "          figure it out at all."
typewriter_regular "        Barry: Beats me, too."
typewriter_regular "        Jill: Now it's Wesker's time to disappear! I don't"
typewriter_regular "          know what's going on."
typewriter_regular "        Barry: Let's search for him together."
typewriter_regular "           Maybe check doubledoors again."
typewriter_regular ""
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Scenes/suspect_wesker.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_dramatic.sh"

typewriter_dramatic ""
typewriter_dramatic "        Jill: Barry... that .orders.txt couldn't be..."
typewriter_dramatic "        Barry: We need to find Captain Albert Wesker immediately."
typewriter_dramatic ""
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Scenes/self-destruct-sequence.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

typewriter_regular ""
typewriter_regular "    [Overhead: THIS FACILITY WILL DETONATE. ALL DOORS ARE NOW UNLOCKED.]"
typewriter_regular "    [Overhead: ALL PERSONNEL MUST EVACUATE IMMEDIATELY THROUGH]"
typewriter_regular "    [Overhead: DIRECTORY: Emergency_Helipad]"
typewriter_regular ""
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Scenes/TwoSurvivors.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

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
typewriter_regular "        BARRY: Shit! I'm empty! Jill--"
typewriter_regular ""
typewriter_regular "    Jill dove away as the Tyrant dashed between them with its claw"
typewriter_regular "    jutting out. The Tyrant stood between them, looking from one to the other."
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

read -p "Password: " input

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
	read -p "Password: " input2
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
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Scenes/ThreeSurvivors.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

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
typewriter_regular "    Jill, Barry, and Chris stared at the large black hole as the Tyrant leapt out"
typewriter_regular "    and above their heads. Landing on his feet, his eyes locked on to Jill."
typewriter_regular "    Barry raised his gun to fire -- nothing. He looked down at his Colt .45."
typewriter_regular ""
typewriter_regular "    		BARRY: Shit! I'm empty! Jill--"
typewriter_regular ""
typewriter_regular "    Jill dove away as the Tyrant dashed between them with its claw"
typewriter_regular "    jutting out. The Tyrant stood between them, looking from Chris, to Barry,"
typewriter_regular "    and then to Jill."
typewriter_regular ""
typewriter_regular "    Deciding which one to annihilate first."
typewriter_regular ""
typewriter_regular "    		BRAD: USE THIS! KILL THAT MONSTER!"
typewriter_regular ""
typewriter_regular "    Jill looked up to see Brad descending overhead. A large green box"
typewriter_regular "    fell from the open doors. She recognized the box, which had a bright"
typewriter_regular "    yellow sticker on all sides that read: TO FIRE ENTER: rocket_launcher"
typewriter_regular ""
typewriter_regular "    		BARRY: Hey! Big guy!"
typewriter_regular "    		CHRIS: Over here!"
typewriter_regular ""
typewriter_regular "    Jill watched as Barry and Chris distracted the Tyrant, and she knew that"
typewriter_regular "    right now was her moment... She hurried to the box, opening it to pull out"
typewriter_regular "    the big weapon."
typewriter_regular ""

read -p "Password: " input

if [ "$input" = "rocket_launcher" ]; then
	source "$GAME_DIR/.Game_Files/Scenes/End-Game/great/great_ending.sh"
else
	typewriter_regular 'Jill pulled the trigger.'
	typewriter_regular 'But nothing fired.'
	typewriter_regular 'She looked back down and'
	typewriter_regular 'TO FIRE ENTER: rocket_launcher'
	read -p "Password: " input2
	if [ "$input2" = "rocket_launcher" ]; then
		source "$GAME_DIR/.Game_Files/Scenes/End-Game/great/great_ending.sh"
	else
		typewriter_regular 'Jill was trying to enter'
		typewriter_regular 'the password, but her fingers'
		typewriter_regular 'went numb, and a large claw'
		typewriter_regular 'had burst from her chest. . .'
		source "$GAME_DIR/.Game_Files/Scenes/death.sh"
	fi
fi
ENDOFFILE

echo "  Scene files written"

# ─── End-Game scenes ──────────────────────────────────────────────────────────

cat > "$GAME_DIR/.Game_Files/Scenes/End-Game/good/good_ending.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

typewriter_regular ""
typewriter_regular "    JILL PLANTED HER FEET, AND TOOK AIM. BRACING HERSELF AS THE ROCKET LAUNCHED. THE"
typewriter_regular "    TYRANT STARED AT THE MISSILE CURIOUSLY BEFORE EXPLODING INTO A MILLION LITTLE"
typewriter_regular "    BITS THAT RAINED DOWN OVER JILL AND BARRY."
typewriter_regular ""
typewriter_regular "    JILL PULLED BARRY TO HIS FEET AND THEY RAN FOR THE HELICOPTER AS BRAD DESCENDED."
typewriter_regular "    INSIDE THE HELICOPTER, JILL SAT NEXT TO BARRY WATCHING THE MANSION IN THE DISTANCE."
typewriter_regular ""
typewriter_regular "        BARRY: What about. . . Chris?"
typewriter_regular "        JILL: Everything happened so fast..."
typewriter_regular "            I thought I saw some Holding_Cells, but. . ."
typewriter_regular ""
typewriter_regular "    IN THE DISTANCE, SIRENS FROM THE SELF DESTRUCT SEQUENCE CUT OUT."
typewriter_regular "    THEN, THE ENTIRE MANSION EXPLODED. TAKING WITH IT ANY EVIDENCE. . ."
typewriter_regular "    AND ANY HOPE OF EVER FINDING CHRIS REDFIELD."
typewriter_regular ""

source "$GAME_DIR/.Game_Files/Scenes/End-Game/good/encourage_great.sh"
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Scenes/End-Game/good/encourage_great.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

typewriter_regular ""
typewriter_regular "    CONGRATS -- YOU GOT THE GOOD ENDING."
typewriter_regular "    BUT WAIT! WHAT ABOUT CHRIS?!"
typewriter_regular "    THERE IS A GREAT ENDING WAITING"
typewriter_regular "    FOR YOU TO DISCOVER."
typewriter_regular ""
typewriter_regular "        . . .G O O D  L U C K !"
typewriter_regular ""
echo ""
echo "  Reviewing the Commands"
echo ""
echo "  Command                    What It Does"
echo "  -------                    ------------"
echo "  ls                         List contents of the current directory"
echo "  ls -la                     List all contents, including hidden files"
echo "  ls -Ra                     List all contents recursively, including hidden files"
echo "  cd ./name                  Change into a directory"
echo "  cd ../                     Go back to the previous directory"
echo "  cat ./file.txt             Read a file"
echo "  pwd                        Print your current directory path"
echo "  man command                Read the manual for any command"
echo ""

# exit game and reset files
function cd () { builtin cd "$@"; }
rm -f ~/.RE-Linux_env
cp "$GAME_DIR/.Game_Files/Design/gamestate_default" "$GAME_DIR/.gamestate"
sed -i '/RE-Linux_env/d' ~/.bashrc
echo "  Press Enter to exit . . ."
read _
builtin cd "$GAME_DIR"
return 1
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Scenes/End-Game/bad/bad_ending.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_dramatic.sh"

typewriter_dramatic ""
typewriter_dramatic "    JILL FIRED THE ROCKET LAUNCHER, WATCHING AS THE TYRANT RAISED ITS GIANT CLAW,"
typewriter_dramatic "    DEFLECTING THE MISSILE. IT SOARED INTO THE SKY, EXPLODING AGAINST THE HELICOPTER TAIL."
typewriter_dramatic "    EVERYTHING, INCLUDING BRAD, CAME CRASHING DOWN IN A BLAZE OVER JILL AND BARRY."
typewriter_dramatic "    SHE WATCHED AS THE TYRANT LEAPT INTO THE AIR AWAY FROM THE EMERGENCY_HELIPAD."
typewriter_dramatic "    TOWARDS. . . RACCOON_CITY. . ."
typewriter_dramatic ""
typewriter_dramatic "    IN HER FINAL MOMENTS, JILL HEARD THE SELF DESTRUCTION SEQUENCE."
typewriter_dramatic ""
typewriter_dramatic "    SELF DESTRUCTION WILL DETONATE IN. . ."
typewriter_dramatic "      ... three ..."
typewriter_dramatic "        ... two ..."
typewriter_dramatic "          ... o"
typewriter_dramatic ""

source "$GAME_DIR/.Game_Files/Scenes/End-Game/bad/Encourage_try_again.sh"
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Scenes/End-Game/bad/Encourage_try_again.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

typewriter_regular ""
typewriter_regular "    OH NO! -- YOU GOT THE BAD ENDING."
typewriter_regular "    THERE'S A GOOD ENDING WAITING FOR YOU TO DISCOVER."
typewriter_regular "    OR BETTER YET, THERE'S EVEN A HIDDEN GREAT ENDING."
typewriter_regular ""
typewriter_regular "      You can do it!"
typewriter_regular ""
typewriter_regular "    . . . G O O D  L U C K !"
echo ""
echo "  Reviewing the Commands"
echo ""
echo "  Command                    What It Does"
echo "  -------                    ------------"
echo "  ls                         List contents of the current directory"
echo "  ls -la                     List all contents, including hidden files"
echo "  ls -Ra                     List all contents recursively, including hidden files"
echo "  cd ./name                  Change into a directory"
echo "  cd ../                     Go back to the previous directory"
echo "  cat ./file.txt             Read a file"
echo "  pwd                        Print your current directory path"
echo "  man command                Read the manual for any command"
echo ""

# exit game and reset files
function cd () { builtin cd "$@"; }
rm -f ~/.RE-Linux_env
cp "$GAME_DIR/.Game_Files/Design/gamestate_default" "$GAME_DIR/.gamestate"
sed -i '/RE-Linux_env/d' ~/.bashrc
echo "  Press Enter to exit . . ."
read _
builtin cd "$GAME_DIR"
return 1
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Scenes/End-Game/great/great_ending.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

typewriter_regular ""
typewriter_regular "    Jill planted her feet, and took aim. Bracing herself as the rocket launched."
typewriter_regular "    The Tyrant stared at the missile curiously before exploding into a million"
typewriter_regular "    bits that rained down over Jill, Barry, And Chris."
typewriter_regular ""
typewriter_regular "    Inside the helicopter, Jill rested her head on Chris's shoulder."
typewriter_regular "    Barry loaded his Colt .45... Just in case..."
typewriter_regular ""
typewriter_regular "    In the distance, sirens from the self destruct sequence cut off."
typewriter_regular "    Then, the entire mansion exploded. Taking with it any evidence of"
typewriter_regular "    trying to warn Raccoon_City or the world about what they had seen."
typewriter_regular ""

source "$GAME_DIR/.Game_Files/Scenes/End-Game/great/thank_you.sh"
ENDOFFILE

cat > "$GAME_DIR/.Game_Files/Scenes/End-Game/great/thank_you.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

typewriter_regular ""
typewriter_regular "  Thank you for playing. I hope you've learned some basic linux commands"
typewriter_regular "  that can help you grow as you continue learning about this incredible"
typewriter_regular "  operating system."
typewriter_regular ""
typewriter_regular "  If you have been following the blog posts, every aspect has been"
typewriter_regular "  detailed providing thanks to the various sources in the community that"
typewriter_regular "  I relied on to make this."
typewriter_regular ""
typewriter_regular "  If you enjoyed this, please try the next challenge:"
typewriter_regular "  RE-L-More_Easy_Basics--where Jill and Barry split up!"
typewriter_regular ""
typewriter_regular "  Same premise, mix of new commands, and not as many hints"
typewriter_regular "  to help you survive the mansion this time either..."
typewriter_regular ""
typewriter_regular "  			. . .G O O D  L U C K !"
echo ""
echo "  Reviewing the Commands"
echo ""
echo "  Command                    What It Does"
echo "  -------                    ------------"
echo "  ls                         List contents of the current directory"
echo "  ls -la                     List all contents, including hidden files"
echo "  ls -Ra                     List all contents recursively, including hidden files"
echo "  cd ./name                  Change into a directory"
echo "  cd ../                     Go back to the previous directory"
echo "  cat ./file.txt             Read a file"
echo "  pwd                        Print your current directory path"
echo "  man command                Read the manual for any command"
echo ""

# exit game and reset files
function cd () { builtin cd "$@"; }
rm -f ~/.RE-Linux_env
cp "$GAME_DIR/.Game_Files/Design/gamestate_default" "$GAME_DIR/.gamestate"
sed -i '/RE-Linux_env/d' ~/.bashrc
echo "  Press Enter to exit . . ."
read _
builtin cd "$GAME_DIR"
return 1
ENDOFFILE

echo "  End-Game files written"

# ─── Cell scripts ─────────────────────────────────────────────────────────────

CELLS="$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/.private_elevator/Umbrella_Laboratory/Holding_Cells"

cat > "$CELLS/Cell_1/.zombies.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

typewriter_regular ""
typewriter_regular "    The cell was filled with zombies."
typewriter_regular ""
typewriter_regular "    A dozen of them. Maybe more."
typewriter_regular "    Overpowered Jill and Barry."
typewriter_regular "    Hands grabbed her hair."
typewriter_regular "    Teeth at his throat."
typewriter_regular ""

source "$GAME_DIR/.Game_Files/Scenes/death.sh"
ENDOFFILE

cat > "$CELLS/Cell_2/spiders.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

typewriter_regular ""
typewriter_regular "    The cell was filled with silence."
typewriter_regular ""
typewriter_regular "    Jill stepped inside. Empty. Just a chair, a desk, a"
typewriter_regular "    thin layer of... webs? Something shifted above her."
typewriter_regular ""
typewriter_regular "    She looked up. Eight eyes looked back."
typewriter_regular ""
typewriter_regular "    Legs the length of her arms wrapped around"
typewriter_regular "    her shoulders, her waist, her throat. The fangs found"
typewriter_regular "    the soft place under her jaw."
typewriter_regular ""
typewriter_regular "    Her body went limp, Barry raised his gun to aim"
typewriter_regular "    but the Spider shot him with... acid? Jill could not"
typewriter_regular "    move, couldn't process, only watch in horror as Barry"
typewriter_regular "    melted where he stood."
typewriter_regular ""
typewriter_regular "    Knowing she was next."
typewriter_regular ""

source "$GAME_DIR/.Game_Files/Scenes/death.sh"
ENDOFFILE

cat > "$CELLS/Cell_4/.zombies.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

typewriter_regular ""
typewriter_regular "    The cell was filled with zombies."
typewriter_regular ""
typewriter_regular "    A dozen of them. Maybe more."
typewriter_regular "    Overpowered Jill and Barry."
typewriter_regular "    Hands grabbed her hair."
typewriter_regular "    Teeth at his throat."
typewriter_regular ""

source "$GAME_DIR/.Game_Files/Scenes/death.sh"
ENDOFFILE

cat > "$CELLS/Cell_5/hunters.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

typewriter_regular ""
typewriter_regular "    The cell was filled with something that shouldn't exist."
typewriter_regular ""
typewriter_regular "    Green scales. Yellow eyes that tracked Jill before she"
typewriter_regular "    could finish turning the handle. It leapt into the air."
typewriter_regular ""
typewriter_regular "    The claws came down in a single clean arc. Jill didn't have"
typewriter_regular "    time to react. She didn't have time to scream."
typewriter_regular ""
typewriter_regular "    Her head hit the floor before her body did."
typewriter_regular ""

source "$GAME_DIR/.Game_Files/Scenes/death.sh"
ENDOFFILE

cat > "$CELLS/Cell_3/.Chris_Redfield.sh" << 'ENDOFFILE'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

typewriter_regular ""
typewriter_regular "        Chris: Oh Jill! Barry!"
typewriter_regular "        Jill: Oh Chris! So you're okay!"
typewriter_regular "        Chris: Yeah! You too! What happened to Wesker?"
typewriter_regular ""
typewriter_regular "    [Overhead: THE SELF-DESTRUCT SYSTEM HAS BEEN ACTIVATED.]"
typewriter_regular "    [Overhead: ALL PERSONNEL MUST EVACUATE IMMEDIATELY.]"
typewriter_regular ""
typewriter_regular "        Jill: Let's talk about it later."
typewriter_regular "        Barry: Let's get out of here!"
typewriter_regular ""

sed -i 's/CHRIS_RESCUED=false/CHRIS_RESCUED=true/' "$GAME_DIR/.gamestate"
ENDOFFILE

echo "  Cell scripts written"

# ─── SourceMeToStart.sh ───────────────────────────────────────────────────────

cat > "$GAME_DIR/SourceMeToStart.sh" << 'ENDOFFILE'
#!/bin/bash

# Get the root directory of the game
GAME_DIR="$HOME/RE-Linux/Easy"

# Source the typewriter functions
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
source "$GAME_DIR/.Game_Files/Design/typewriter_dramatic.sh"

# Reset game state to default
cp "$GAME_DIR/.Game_Files/Design/gamestate_default" "$GAME_DIR/.gamestate"

# create fresh environment file
rm -f ~/.RE-Linux_env
echo "export GAME_DIR=\"$GAME_DIR\""> ~/.RE-Linux_env
cat >> ~/.RE-Linux_env << 'EOF'

function cd () {
	builtin cd "$@"
# spencer lock logic
	if [[ "$PWD" == */oswell_spencer_mansion ]]; then
		source "$GAME_DIR/.gamestate"
		if [ "$SPENCER_UNLOCKED" = "false" ]; then
			source "$GAME_DIR/.Game_Files/Locks/spencer_lock.sh"
			lock_result=$?
			if [ $lock_result -ne 0 ]; then
				builtin cd "$GAME_DIR"
			else
				builtin cd "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall"
				source "$GAME_DIR/.Game_Files/Scenes/enter_mainhall.sh"
			fi
			return
		fi
	fi
# mainhall lockdown after entering -- block cd ../ above mainhall
	if [[ "$OLDPWD" == */mainhall* ]] && [[ "$PWD" != */mainhall* ]]; then
		source "$GAME_DIR/.gamestate"
		if [ "$ENTER_MANSION_COMPLETE" = "true" ]; then
			typewriter_regular '        Jill! Do not open that door!'
			builtin cd "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall"
		fi
	fi
# doubledoors logic
	if [[ "$PWD" == */doubledoors ]]; then
		source "$GAME_DIR/.Game_Files/Scenes/enter_doubledoors.sh"
		source "$GAME_DIR/.gamestate"
		if [ "$SEARCH_WESKER_PLAYED" = "true" ]; then
			mv "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/doubledoors/.Barry_Help2.txt" \
			"$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/doubledoors/Barry_Help2.txt" 2>/dev/null
		fi
	fi
# search_wesker logic
	if [[ "$PWD" == */mainhall ]]; then
		source "$GAME_DIR/.gamestate"
		if [ "$DOUBLEDOORS_VISITED" = "true" ] && [ "$SEARCH_WESKER_PLAYED" = "false" ]; then
			source "$GAME_DIR/.Game_Files/Scenes/search_wesker.sh"
		fi
	fi
# browndoor logic
	if [[ "$PWD" == */browndoor ]]; then
		source "$GAME_DIR/.gamestate"
		if [ "$BROWNDOOR_UNLOCKED" = "false" ]; then
			source "$GAME_DIR/.Game_Files/Locks/browndoor_lock.sh"
			lock_result=$?
			if [ $lock_result -ne 0 ]; then
				builtin cd "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall"
			else
				source "$GAME_DIR/.Game_Files/Scenes/enter_browndoor.sh"
			fi
		fi
	fi
# bluedoor logic
	if [[ "$PWD" == */bluedoor ]]; then
		source "$GAME_DIR/.gamestate"
		if [ "$BLUEDOOR_UNLOCKED" = "false" ]; then
			source "$GAME_DIR/.Game_Files/Locks/bluedoor_lock.sh"
			lock_result=$?
			if [ $lock_result -ne 0 ]; then
				builtin cd "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall"
			else
				source "$GAME_DIR/.Game_Files/Scenes/enter_bluedoor.sh"
			fi
		fi
	fi
# private_elevator logic
	if [[ "$PWD" == */.private_elevator ]]; then
		source "$GAME_DIR/.gamestate"
		if [ "$PRIVATE_ELEVATOR_UNLOCKED" = "false" ]; then
			source "$GAME_DIR/.Game_Files/Locks/private_elevator_lock.sh"
			lock_result=$?
			if [ $lock_result -ne 0 ]; then
				builtin cd "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor"
			else
				builtin cd "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/.private_elevator/Umbrella_Laboratory"
				source "$GAME_DIR/.Game_Files/Scenes/enter_umbrella.sh"
			fi
		fi
	fi
# Research_Office logic
	if [[ "$PWD" == */Research_Office ]]; then
		source "$GAME_DIR/.gamestate"
		if [ "$RESEARCH_OFFICE_VISITED" = "false" ]; then
			sed -i 's/RESEARCH_OFFICE_VISITED=false/RESEARCH_OFFICE_VISITED=true/' "$GAME_DIR/.gamestate"
		fi
	fi
# suspect_wesker logic -- fires when returning to Umbrella_Laboratory after Research_Office visited
	if [[ "$PWD" == */Umbrella_Laboratory ]]; then
		source "$GAME_DIR/.gamestate"
		if [ "$RESEARCH_OFFICE_VISITED" = "true" ] && [ "$SUSPECT_WESKER_PLAYED" = "false" ]; then
			source "$GAME_DIR/.Game_Files/Scenes/suspect_wesker.sh"
			sed -i 's/SUSPECT_WESKER_PLAYED=false/SUSPECT_WESKER_PLAYED=true/' "$GAME_DIR/.gamestate"
		fi
	fi
# Cultivation_Room logic
	if [[ "$PWD" == */Cultivation_Room ]]; then
		source "$GAME_DIR/.gamestate"
		if [ "$CULTIVATION_COMPLETE" = "false" ]; then
			source "$GAME_DIR/.Game_Files/Locks/Cultivation_Room_Lock.sh"
			lock_result=$?
			if [ $lock_result -ne 0 ]; then
				builtin cd "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/.private_elevator/Umbrella_Laboratory"
			else
				source "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/.private_elevator/Umbrella_Laboratory/Cultivation_Room/Enter_Cultivation_Room.sh"
			fi
		fi
	fi
# self-destruct announcement on every cd after cultivation complete
	source "$GAME_DIR/.gamestate" 2>/dev/null
	if [ "$CULTIVATION_COMPLETE" = "true" ]; then
		source "$GAME_DIR/.Game_Files/Scenes/self-destruct-sequence.sh"
	fi
# UMBRELLA_LABS LOCKED DOWN -- block cd ../ above Umbrella_Laboratory
	if [[ "$OLDPWD" == */Umbrella_Laboratory* ]] && [[ "$PWD" != */Umbrella_Laboratory* ]]; then
		source "$GAME_DIR/.gamestate"
		if [ "$CULTIVATION_COMPLETE" = "true" ]; then
			typewriter_regular 'The facility is on lockdown. You cannot go back that way.'
			builtin cd "$OLDPWD"
		fi
	fi
# Holding_Cells logic
	if [[ "$PWD" == */Holding_Cells ]]; then
		source "$GAME_DIR/.gamestate"
		if [ "$CULTIVATION_COMPLETE" = "false" ]; then
			typewriter_regular 'ACCESS DENIED!'
			builtin cd "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/.private_elevator/Umbrella_Laboratory"
		fi
	fi
# Emergency_Helipad logic
	if [[ "$PWD" == */Emergency_Helipad ]]; then
		source "$GAME_DIR/.gamestate"
		if [ "$CULTIVATION_COMPLETE" != "true" ]; then
			typewriter_regular "The helipad door is sealed. There's nothing you can do to open it."
			builtin cd "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/.private_elevator/Umbrella_Laboratory"
		else
			source "$GAME_DIR/.Game_Files/Locks/Emergency_Helipad_lock.sh"
		fi
	fi
# Cell logic
	if [[ "$PWD" == */Holding_Cells/Cell_* ]]; then
		source "$PWD/"*.sh
	fi
}
EOF

# add to .bashrc if not already there
grep -qxF 'source ~/.RE-Linux_env' ~/.bashrc || echo 'source ~/.RE-Linux_env' >> ~/.bashrc

# unset cd function to avoid triggering lock on relaunch
unset -f cd 2>/dev/null

# Move player into raccoon_forest and begin
cd "$GAME_DIR/raccoon_forest"

# force ~/.RE-Linux_env is active after relaunch
source ~/.RE-Linux_env

# Fire the opening script
source "$GAME_DIR/.Game_Files/Scenes/opening.sh"
ENDOFFILE

echo "  SourceMeToStart.sh written"


# ─── Map directories ──────────────────────────────────────────────────────────

mkdir -p "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/doubledoors"
mkdir -p "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/browndoor"
mkdir -p "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/.private_elevator/Umbrella_Laboratory/Research_Office"
mkdir -p "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/.private_elevator/Umbrella_Laboratory/Cultivation_Room"
mkdir -p "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/.private_elevator/Umbrella_Laboratory/Emergency_Helipad"

echo "  map directories created"

# ─── Map files ────────────────────────────────────────────────────────────────

cat > "$GAME_DIR/raccoon_forest/Barry_Help.txt" << 'ENDOFFILE'

	use command 'ls' to list out what is inside the directory.

		[name@name] ~$:  ls
		#terminal returns: Barry_Help.txt oswell_spencer_mansion

	.txt = a text file (typically font color: white)

	 oswell_spencer_mansion (typically font color: blue)
		oswell_spencer_mansion is a directory.

	use command cd to change directories.
	This command uses specific SYNTAX to navigate:

	'.' means current directory
	'/' seperates directory names in a path
		long path: ~/RE-Linux/Easy/raccoon_forest/oswell_spencer_mansion
		short path: ./oswell_spencer_mansion
	'./' together -- means "starting from where I am right now..."

	'cd' means to change the directory.

	all together, the correct syntax would be:
		[name@name] ~$: cd ./oswell_spencer_mansion

	! when typing, Linux will automatically bold things that do exist and
	unbold things that it can't find. This is very helpful! Especially since
	a lot of the names are UpperCase or-Even_like-This.

		good luck!

ENDOFFILE

cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/Help_Barry.txt" << 'ENDOFFILE'
use command cd to change directory to doubledoors
remember to start your command with ./
the syntax: cd ./directory_name

cd ./doubledoors
ENDOFFILE

cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/doubledoors/Barry_Help1.txt" << 'ENDOFFILE'

  Remember how ./ means "this current directory"
  Well command ../ takes the user up one level to
  the parent directory.

  For this instance, doubledoors is within the
  mainhall directory.

  enter command: cd ../

ENDOFFILE

cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/doubledoors/.Barry_Help2.txt" << 'ENDOFFILE'
Remember the command ls ?
That will list everything in the current directory.

However, some things can be hidden by placing a '.'
in front of the file. To see those hidden items:
					use command 'ls -la' to search.
ENDOFFILE

cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/doubledoors/.Kenneth_Sullivan.txt" << 'ENDOFFILE'

  There is something in his hand, it's a LOCKPICK.
	Perhaps it could be used on one of the doors in
	the mainhall.

ENDOFFILE

cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/browndoor/Statue_with_Vase.txt" << 'ENDOFFILE'

  Is there a hidden file in the vase?
  What did Barry say about ls again?

ENDOFFILE

cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/browndoor/.something_hidden_in_vase.txt" << 'ENDOFFILE'

			Keeper's Diary

				May 12th, 1998.

			The space suit has me itching all over — I skipped feeding the
			dogs today out of spite, and felt better for it. By the 13th,
			the doctor bandaged my swollen back and said I could lose the suit.
			Then the company locked the grounds down, a researcher got shot
			trying to leave. They changed the bluedoor password, as if there
			was a way out through there. My skin started sloughing off in
			chunks when I scratched.

				May 19th —9—8

			fever gone. Killed Scott, tasted fine.
			heard them whisper that the blue door password was changed to
			itchytasty

			Itchy. Tasty. Itchy. Reminds me of Scott.
            And the others I ——
			Tasty.
			Itchy. Tasty. Itchy. Tasty.
			Itchy. Tasty. Itchy. Tasty.

ENDOFFILE

cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/ResearchersWill.txt" << 'ENDOFFILE'

				Yes, I am infected.
				I did everything I could to prevent
				this accident from reaching the public,
				but I can only delay the inevitable
				for so long. . .

				At least the private_elevator is hidden.

ENDOFFILE

cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/Newspaper_Clippings.txt" << 'ENDOFFILE'

      strange, all these newspaper articles are
			  about S.T.A.R.S.
			    . . .

ENDOFFILE

cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/Security_Protocols.txt" << 'ENDOFFILE'

            SECURITY PROTOCOLS
        Spencer Mansion is on lockdown. Unauthorized persons
				attempting to leave will be shot on site.
				Everyone with Clearance Level: Executive must exit
				through the .private_elevator located in bluedoor and
				head directly to the Emergency_Helipad for evacuation.

						BASEMENT LEVEL
				Research_Office | For use by the Special Research Division
				only. All other access to the Visual Data Room must be
				cleared with Keith Arving, Room Manager.

				Holding_Cells | controls the use of the prison. At least
				one Consultant Researcher (E. Smith, S. Ross, A. Wesker)
				must be present if viral use is authorized.

				Passage_to_Helipad | is prohibited unless accompanied by
				a Consultant Researcher or the Chief of Security.
				Unauthorized persons entering the helipad will be
				shot on site.

				Cultivation_Room | Regarding the progress of Tyrant after
				the administration of T-Virus...

				(Illegible hereafter...)

ENDOFFILE

cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/.private_elevator/Umbrella_Laboratory/Research_Office/.orders.txt" << 'ENDOFFILE'
********************
    CONFIDENTIAL
				Attn: Chief of Security
				Date: July 22, 1998 2:13

    ALBERT,

				X Day is drawing upon us. Execute the following
				procedures within one week. Prompt actions are
				demanded.

				1. Lure S.T.A.R.S. to the estate, and obtain raw combat
				data against B.O.W.s

				2. Dispose of the Tyrant in the Cultivation_Room
				password: eagle

				3. Ensure complete disposal of the Arklay Laboratory
				including all personnel and test animals. Disguise their
				deaths as an accident. When the above procedures are
				executed, report to headquarters for further instructions.

    Good luck.
			Umbrella Headquarters,
			Umbrella Inc.

ENDOFFILE

cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/.private_elevator/Umbrella_Laboratory/Holding_Cells/Barry_Help.txt" << 'ENDOFFILE'

    Barry: There are so many cells.
      We've used command ls plenty of times, and we've used ls -la too.
      Now let's learn a new command and build on that.

    Enter command ls -R
      This command will list out all the folders and files that are
      relative to this current directory.

    But we know that folders and files can be hidden.
    So let's update the syntax to show us those too.

    Enter command ls -Ra
      This command will list out all the folders and files,
      including hidden files, that are relative to the directory.

    Warning: enter the wrong cell, and you will die.
    Barry: So let's enter the one with Chris, yeah?

ENDOFFILE

echo "  map files written"

# ─── PLAYER_GUIDE ─────────────────────────────────────────────────────────────

cat > "$GAME_DIR/PLAYER_GUIDE" << 'ENDOFFILE'
# Easy — Player Guide
# A Resident Evil-themed Linux terminal adventure

---
# Before You Begin
This game is played entirely in your Linux terminal. You'll navigate a directory
structure that mirrors the Spencer Mansion, read files to uncover the story, and
enter passwords to unlock new areas — all using real Linux commands.
Who knows, maybe you'll even survive!

Difficulty: Easy

Hint system: Yes
    Look for Barry_Help.txt files throughout the game.
    When you're stuck, use cat to open one:

    cat ./Barry_Help.txt

---
# Commands You'll Use

| Command              | What It Does                                          |
|----------------------|-------------------------------------------------------|
| ls                   | List contents of the current directory                |
| ls -la               | List all contents, including hidden files             |
| ls -Ra               | List all contents recursively, including hidden files |
| cd ./name            | Change into a directory                               |
| cd ../               | Go back to the parent directory                       |
| cat ./file.txt       | Read a file                                           |
| pwd                  | Print your current directory path                     |
| man command          | Read the manual for any command                       |

Hidden files start with a dot (.) and won't show up with plain ls.
Always try ls -la when you feel stuck — something may be hidden.

---
# How Passwords Work
Some directories are locked. When prompted, type the password and press Enter.
You can see what you are typing.

If you enter an incorrect password, pay attention — you only get one more attempt
before something bad happens.

Passwords are always hidden somewhere in the game world. Read everything.

---
# The Story So Far
It's July 1998. S.T.A.R.S. Alpha Team is searching Raccoon Forest for Bravo Team,
who vanished during a mission. After a violent attack, the surviving members flee
into a nearby mansion for safety.

You play as Jill Valentine.

---
# How to Play
1. Clone the repo into your Linux environment:
   git clone https://github.com/KyleZona/RE-Linux

2. Move into the game directory:
   cd RE-Linux/Easy

3. Start the game:
   source SourceMeToStart.sh

---
# Walkthrough

---
# directory: raccoon_forest
Game begins here. Barry leaves a hint right away — read it.

    cat ./Barry_Help.txt

Then explore.

    ls
    cd ./oswell_spencer_mansion
    > Password: spencer

---
# directory: oswell_spencer_mansion -> mainhall
You're inside the mansion now.

    ls

You'll see doubledoors. Head there first.

    cd ./doubledoors

---
# directory: doubledoors
Explore, then head back.

    ls
    cat ./Barry_Help1.txt
    cd ../

(cd ../ takes you back up one level, to mainhall)

---
# directory: mainhall
Back in mainhall, Barry suggests searching more carefully.

    ls -la

Two hidden doors appear: browndoor and bluedoor. You'll need passwords for both.
Head back to doubledoors to look for clues.

    cd ./doubledoors

---
# directory: doubledoors
Something is hidden in here.

    ls -la
    cat ./.Kenneth_Sullivan.txt

You found something useful on Kenneth's body.

    cd ../

---
# directory: mainhall

    cd ./browndoor
    > Password: LOCKPICK

---
# directory: browndoor
Search everything in here — including things that look empty at first.

    ls
    cat ./Statue_with_Vase.txt
    ls -la
    cat ./.something_hidden_in_vase.txt

The Keeper's Diary reveals the password for the bluedoor.

    cd ../

---
# directory: mainhall

    cd ./bluedoor
    > Password: itchytasty

---
# directory: bluedoor
Read all three files in here. One of them is especially important.

    ls
    cat ./ResearchersWill.txt
    cat ./Newspaper_Clippings.txt
    cat ./Security_Protocols.txt

The security protocols mention a hidden elevator. Now search for what's hidden.

    ls -la
    cd ./.private_elevator
    > Password: Executive

---
# directory: .private_elevator -> Umbrella_Laboratory
The elevator takes you underground into an Umbrella facility.
A scene plays automatically when you arrive.

---
# directory: Umbrella_Laboratory
You're underground now. Look around.

    ls

You'll see several directories. Only Research_Office is accessible right now.

    cd ./Research_Office

---
# directory: Research_Office
Search carefully — something important is hidden in here.

    ls
    ls -la
    cat ./.orders.txt

The orders reveal the password for the Cultivation_Room — and something much
worse about Wesker.

    cd ../

---
# directory: Umbrella_Laboratory

    cd ./Cultivation_Room
    > Password: eagle

---
# directory: Cultivation_Room
A confrontation with Wesker. And something far worse waiting inside one of the
tubes. After the scene plays out, all remaining doors unlock.

    cd ../

---
# PLEASE BE AWARE
#### The Ending Split
After escaping the Cultivation_Room, you have a choice.

In Umbrella_Laboratory, Holding_Cells and Emergency_Helipad are now unlocked.
This is where your ending is decided.

---
#### Path A — Emergency_Helipad (Good or Bad Ending)

    cd ./Emergency_Helipad
    > Password: rocket_launcher

There is a 35% chance of the Good Ending and a 65% chance of the Bad Ending.
Whether you win or lose, Chris is never found.

---
#### Path B — Holding_Cells first (Great Ending)

    cd ./Holding_Cells

---
# directory: Holding_Cells
Barry hints that you should search carefully.

!! CAUTION: Cells 1, 2, 4, and 5 are death traps.
   Do not enter them without a reason.

    cat ./Barry_Help.txt
    ls -Ra
    cd ./Cell_3

After finding Chris, head back out and to the helipad.

    cd ../
    cd ../
    cd ./Emergency_Helipad
    > Password: rocket_launcher

With Chris rescued, you now have a 100% chance of the Great Ending.

---
# Endings Summary

| Ending       | How to Get It                                            |
|--------------|----------------------------------------------------------|
| Bad Ending   | Go straight to Emergency_Helipad — 65% chance            |
| Good Ending  | Go straight to Emergency_Helipad — 35% chance            |
| Great Ending | Find Chris in Cell_3 first, then go to Emergency_Helipad |

---
# Password Legend

| Password          | Found In                       | Unlocks                 |
|-------------------|--------------------------------|-------------------------|
| spencer           | Context / story                | oswell_spencer_mansion  |
| LOCKPICK          | .Kenneth_Sullivan.txt          | browndoor               |
| itchytasty        | .something_hidden_in_vase.txt  | bluedoor                |
| Executive         | Security_Protocols.txt         | .private_elevator       |
| eagle             | .orders.txt                    | Cultivation_Room        |
| rocket_launcher   | Shown on weapon box            | Fire weapon / endings   |

---
Part of the Learning Linux Through Resident Evil series.

Up next:
    More_Basics_w-Jill — same mansion, fewer hints.
ENDOFFILE

echo "  PLAYER_GUIDE written"

# ─── Done ─────────────────────────────────────────────────────────────────────

echo ""
echo "  All updates applied successfully."
echo "  To start the game: source SourceMeToStart.sh"
echo ""

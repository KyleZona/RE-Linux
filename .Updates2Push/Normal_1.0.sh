#!/bin/bash

# =============================================================================
# Normal_1.0.sh
# RE-Linux/Normal — Day 1: Design & Foundation
# RE-Linux/Normal - Day 2: Scenes, Files, and Guides (oh, my!)
#
# Run:   bash Normal_1.0.sh
# =============================================================================

# =============================================================================
# DAY 1
# =============================================================================

# =============================================================================
# DIRECTORIES
# =============================================================================

mkdir -p "$GAME_DIR/.Game_Files/Design"
mkdir -p "$GAME_DIR/.Game_Files/Locks"
mkdir -p "$GAME_DIR/.Game_Files/Scenes/End-Game/bad"
mkdir -p "$GAME_DIR/.Game_Files/Scenes/End-Game/good"
mkdir -p "$GAME_DIR/.Game_Files/Scenes/End-Game/great"
mkdir -p "$GAME_DIR/.Game_Files/staged/.hidden_ladder/Umbrella_Laboratory/Research_Office"
mkdir -p "$GAME_DIR/.Game_Files/staged/.hidden_ladder/Umbrella_Laboratory/Cultivation_Room"
mkdir -p "$GAME_DIR/.Game_Files/staged/.hidden_ladder/Umbrella_Laboratory/Holding_Cells/Cell_1"
mkdir -p "$GAME_DIR/.Game_Files/staged/.hidden_ladder/Umbrella_Laboratory/Holding_Cells/Cell_2"
mkdir -p "$GAME_DIR/.Game_Files/staged/.hidden_ladder/Umbrella_Laboratory/Holding_Cells/Cell_3"
mkdir -p "$GAME_DIR/.Game_Files/staged/.hidden_ladder/Umbrella_Laboratory/Holding_Cells/Cell_4"
mkdir -p "$GAME_DIR/.Game_Files/staged/.hidden_ladder/Umbrella_Laboratory/Holding_Cells/Cell_5"
mkdir -p "$GAME_DIR/.Game_Files/staged/.hidden_ladder/Umbrella_Laboratory/Holding_Cells/Cell_6"
mkdir -p "$GAME_DIR/.Game_Files/staged/.hidden_ladder/Umbrella_Laboratory/Holding_Cells/Cell_7"
mkdir -p "$GAME_DIR/.Game_Files/staged/.hidden_ladder/Umbrella_Laboratory/Emergency_Helipad"

mkdir -p "$GAME_DIR/raccoon_forest/courtyard"
mkdir -p "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/browndoor"
mkdir -p "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/courtyard/guardhouse"
mkdir -p "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/doubledoors/hallway/GreenDoor"
mkdir -p "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/doubledoors/hallway/browndoor"

# =============================================================================
# GAMESTATE DEFAULTS
# =============================================================================

cat > "$GAME_DIR/.Game_Files/Design/gamestate_defaults" << 'GAMESTATE'
# DO NOT ADJUST, this is core to the game
SPENCER_ATTEMPTS=0
ENTER_MANSION_COMPLETE=false
SPENCER_UNLOCKED=false
FOREST_VISITED=false
BARRY_FOUND=false
SEARCH_WESKER_PLAYED=false
DOUBLEDOORS_VISITED=false
HALLWAY_VISITED=false
GREENDOOR_VISITED=false
BROWNDOOR_UNLOCKED=false
BLUEDOOR_UNLOCKED=false
GREENDOOR_UNLOCKED=false
HALLWAY_BROWNDOOR_UNLOCKED=false
SNAKE_ATTEMPTS=0
SNAKE_DEFEATED=false
BARRY_POISONED=false
BARRY_WHOAMI_PLAYED=false
BARRY_REJOINED=false
COURTYARD_VISITED=false
BOOKCASES_REMOVED=false
HIDDEN_LADDER_UNLOCKED=false
UMBRELLA_LAB_VISITED=false
RESEARCH_OFFICE_VISITED=false
SUSPECT_WESKER_PLAYED=false
CHRIS_RESCUED=false
CULTIVATION_COMPLETE=false
GAMESTATE

cp "$GAME_DIR/.Game_Files/Design/gamestate_defaults" "$GAME_DIR/.gamestate"

# =============================================================================
# DESIGN — TYPEWRITER FUNCTIONS
# =============================================================================

cat > "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh" << 'EOF'
typewriter_regular() {
    local text="$1"
    local delay="${2:-0.05}"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo
}
EOF

cat > "$GAME_DIR/.Game_Files/Design/typewriter_dramatic.sh" << 'EOF'
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
EOF

# =============================================================================
# LOCKS
# =============================================================================

# --- spencer_lock.sh ---
cat > "$GAME_DIR/.Game_Files/Locks/spencer_lock.sh" << 'EOF'
source "$GAME_DIR/.gamestate"
echo "LOCKED: Enter Owner's Last Name"
read -sp "Password: " input
echo ""
if [ "$input" = "spencer" ]; then
    sed -i 's/SPENCER_UNLOCKED=false/SPENCER_UNLOCKED=true/' "$GAME_DIR/.gamestate"
    return 0
else
    source "$GAME_DIR/.Game_Files/Scenes/attempt_failed.sh"
    return $?
fi
EOF

# --- attempt_failed.sh (spencer attempts) ---
cat > "$GAME_DIR/.Game_Files/Scenes/attempt_failed.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_dramatic.sh"
attempts=$(grep "SPENCER_ATTEMPTS" "$GAME_DIR/.gamestate" | cut -d'=' -f2)
attempts=$((attempts + 1))
sed -i "s/SPENCER_ATTEMPTS=.*/SPENCER_ATTEMPTS=$attempts/" "$GAME_DIR/.gamestate"
if [ "$attempts" -ge 2 ]; then
    source "$GAME_DIR/.Game_Files/Scenes/death.sh"
else
    typewriter_dramatic ''
    typewriter_dramatic '  Rabid dogs stopped a few feet away.'
    typewriter_dramatic '  Growling, readying to charge . . .'
    sleep 0.5
    typewriter_dramatic '  Jill looked back to the screen and read:'
    typewriter_dramatic ''
    typewriter_dramatic '    FAILED ATTEMPT.'
    typewriter_dramatic '      ONLY ONE MORE ALLOWED . . .'
    typewriter_dramatic ''
    source "$GAME_DIR/.Game_Files/Locks/spencer_lock.sh"
    return $?
fi
EOF

# --- greendoor_lock.sh ---
cat > "$GAME_DIR/.Game_Files/Locks/greendoor_lock.sh" << 'EOF'
source "$GAME_DIR/.gamestate"
echo "LOCKED: Enter Password"
read -sp "Password: " input
echo ""
if [ "$input" = "STARS" ]; then
    sed -i 's/GREENDOOR_UNLOCKED=false/GREENDOOR_UNLOCKED=true/' "$GAME_DIR/.gamestate"
    return 0
else
    echo "        INCORRECT PASSWORD!"
    sleep 0.5
    return 1
fi
EOF

# --- browndoor_lock.sh (mainhall/browndoor) ---
cat > "$GAME_DIR/.Game_Files/Locks/browndoor_lock.sh" << 'EOF'
source "$GAME_DIR/.gamestate"
echo "LOCKED: Enter Password"
read -sp "Password: " input
echo ""
if [ "$input" = "serum" ]; then
    sed -i 's/BROWNDOOR_UNLOCKED=false/BROWNDOOR_UNLOCKED=true/' "$GAME_DIR/.gamestate"
    return 0
else
    echo "        INCORRECT PASSWORD!"
    sleep 0.5
    return 1
fi
EOF

# --- bluedoor_lock.sh ---
cat > "$GAME_DIR/.Game_Files/Locks/bluedoor_lock.sh" << 'EOF'
source "$GAME_DIR/.gamestate"
echo "LOCKED: Enter Password"
read -sp "Password: " input
echo ""
if [ "$input" = "keeper" ]; then
    sed -i 's/BLUEDOOR_UNLOCKED=false/BLUEDOOR_UNLOCKED=true/' "$GAME_DIR/.gamestate"
    return 0
else
    echo "        INCORRECT PASSWORD!"
    sleep 0.5
    return 1
fi
EOF

# --- hallway_browndoor_lock.sh ---
cat > "$GAME_DIR/.Game_Files/Locks/hallway_browndoor_lock.sh" << 'EOF'
source "$GAME_DIR/.gamestate"
echo "LOCKED: Enter Password"
read -sp "Password: " input
echo ""
if [ "$input" = "arklay" ]; then
    sed -i 's/HALLWAY_BROWNDOOR_UNLOCKED=false/HALLWAY_BROWNDOOR_UNLOCKED=true/' "$GAME_DIR/.gamestate"
    return 0
else
    echo "        INCORRECT PASSWORD!"
    sleep 0.5
    return 1
fi
EOF

# --- hidden_ladder_lock.sh ---
cat > "$GAME_DIR/.Game_Files/Locks/hidden_ladder_lock.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
typewriter_regular 'CLEARANCE LEVEL NEEDED.'
typewriter_regular 'PLEASE ENTER CLEARANCE LEVEL:'
read -sp "Password: " input
echo ""
if [ "$input" = "arklay" ]; then
    sed -i 's/HIDDEN_LADDER_UNLOCKED=false/HIDDEN_LADDER_UNLOCKED=true/' "$GAME_DIR/.gamestate"
    return 0
else
    echo "  CLEARANCE LEVEL INVALID!"
    return 1
fi
EOF

# --- cultivation_room_lock.sh ---
cat > "$GAME_DIR/.Game_Files/Locks/cultivation_room_lock.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
typewriter_regular '  PLEASE PROVIDE MEDAL NAME:'
read -sp "Password: " input
echo ""
if [ "$input" = "wolf" ]; then
    return 0
else
    echo "  INCORRECT PASSWORD!"
    return 1
fi
EOF

# --- emergency_helipad_lock.sh ---
cat > "$GAME_DIR/.Game_Files/Locks/emergency_helipad_lock.sh" << 'EOF'
source "$GAME_DIR/.gamestate"
if [ "$CHRIS_RESCUED" = "true" ]; then
    source "$GAME_DIR/.Game_Files/Scenes/ThreeSurvivors.sh"
else
    source "$GAME_DIR/.Game_Files/Scenes/TwoSurvivors.sh"
fi
EOF

# --- snake_boss.sh ---
cat > "$GAME_DIR/.Game_Files/Locks/snake_boss.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_dramatic.sh"
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
source "$GAME_DIR/.gamestate"

clear
typewriter_dramatic ''
typewriter_dramatic '  The hallway fell silent.'
typewriter_dramatic '  Something long and wet slid across the floor ahead.'
typewriter_dramatic '  Then a head the size of a trash can turned toward Jill.'
typewriter_dramatic ''
typewriter_dramatic '  YAWN. The giant snake. And it remembered her.'
typewriter_dramatic ''
sleep 0.5
typewriter_regular '  If Jill was going to survive this, she had to think fast.'
typewriter_regular '  Three questions. No second chances.'
typewriter_regular ''
sleep 0.3

# --- Question 1 ---
typewriter_regular '  Q1. You want to see the first 5 lines of a file called clues.txt.'
typewriter_regular '      Which command do you use?'
typewriter_regular ''
typewriter_regular '    1) cat ./clues.txt'
typewriter_regular '    2) head -5 ./clues.txt'
typewriter_regular '    3) tail -5 ./clues.txt'
typewriter_regular '    4) ls ./clues.txt'
typewriter_regular ''
read -p "  Answer (1-4): " q1
echo ""

if [ "$q1" != "2" ]; then
    typewriter_dramatic ''
    typewriter_dramatic '  Jill hesitated. The snake did not.'
    typewriter_dramatic '  Its jaws closed around her before she could correct herself.'
    typewriter_dramatic ''
    source "$GAME_DIR/.Game_Files/Scenes/death.sh"
    return 1
fi

typewriter_regular '  Correct.'
sleep 0.3

# --- Question 2 ---
typewriter_regular '  Q2. You need to find which directory you are currently in.'
typewriter_regular '      Which command do you use?'
typewriter_regular ''
typewriter_regular '    1) ls'
typewriter_regular '    2) cd ../'
typewriter_regular '    3) pwd'
typewriter_regular '    4) whoami'
typewriter_regular ''
read -p "  Answer (1-4): " q2
echo ""

if [ "$q2" != "3" ]; then
    typewriter_dramatic ''
    typewriter_dramatic '  Jill froze. The snake struck from above.'
    typewriter_dramatic '  She never saw it coming.'
    typewriter_dramatic ''
    source "$GAME_DIR/.Game_Files/Scenes/death.sh"
    return 1
fi

typewriter_regular '  Correct.'
sleep 0.3

# --- Question 3 ---
typewriter_regular '  Q3. You want to move a file called Barry.sh from'
typewriter_regular '      the current directory into a subdirectory called snake_room.'
typewriter_regular '      Which command do you use?'
typewriter_regular ''
typewriter_regular '    1) cp ./Barry.sh ./snake_room/'
typewriter_regular '    2) cd ./Barry.sh'
typewriter_regular '    3) mv ./Barry.sh ./snake_room/'
typewriter_regular '    4) cat ./Barry.sh'
typewriter_regular ''
read -p "  Answer (1-4): " q3
echo ""

if [ "$q3" != "3" ]; then
    typewriter_dramatic ''
    typewriter_dramatic '  The snake coiled. The answer was wrong.'
    typewriter_dramatic '  Jill did not get a third chance.'
    typewriter_dramatic ''
    source "$GAME_DIR/.Game_Files/Scenes/death.sh"
    return 1
fi

typewriter_regular '  Correct.'
sleep 0.3
typewriter_dramatic ''
typewriter_dramatic '  Jill kept her nerve. Three for three.'
typewriter_dramatic '  The snake recoiled. Then, from behind her --'
typewriter_dramatic ''
typewriter_dramatic '        Barry: FIRE!'
typewriter_dramatic ''
typewriter_dramatic '  Two shots from the Colt .45 tore through the ceiling of the hall.'
typewriter_dramatic '  The snake dropped. Then went still.'
typewriter_dramatic ''
typewriter_dramatic '        Barry: You alright?'
typewriter_dramatic '        Jill: I had it under control.'
typewriter_dramatic '        Barry: Sure you did.'
typewriter_dramatic ''
typewriter_regular '        Barry: I am going to stay here and examine this thing...'
typewriter_regular '          Something about it... I need to understand what they did to it.'
typewriter_regular '        Jill: Barry...'
typewriter_regular '        Barry: Go. I will catch up.'
typewriter_regular ''

sed -i 's/SNAKE_DEFEATED=false/SNAKE_DEFEATED=true/' "$GAME_DIR/.gamestate"
return 0
EOF

# --- snake_boss_barry.sh (alternate — Barry present from the start) ---
cat > "$GAME_DIR/.Game_Files/Locks/snake_boss_barry.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_dramatic.sh"
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

clear
typewriter_dramatic ''
typewriter_dramatic '  The snake filled the hallway. It had to be 15 feet.'
typewriter_dramatic '  Maybe more. Its scales had already healed from whatever'
typewriter_dramatic '  they had put it through in the lab.'
typewriter_dramatic ''
typewriter_regular '        Barry: Big one. Okay Jill. Think. Three questions.'
typewriter_regular '          Get them right and I will take the shot.'
typewriter_regular ''
sleep 0.3

# --- Question 1 ---
typewriter_regular '  Q1. You want to see the first 5 lines of a file called clues.txt.'
typewriter_regular '      Which command do you use?'
typewriter_regular ''
typewriter_regular '    1) cat ./clues.txt'
typewriter_regular '    2) head -5 ./clues.txt'
typewriter_regular '    3) tail -5 ./clues.txt'
typewriter_regular '    4) ls ./clues.txt'
typewriter_regular ''
read -p "  Answer (1-4): " q1
echo ""

if [ "$q1" != "2" ]; then
    typewriter_dramatic ''
    typewriter_dramatic '        Barry: No! That is wrong!'
    typewriter_dramatic '  The snake lunged. Barry shoved Jill clear but took the strike himself.'
    typewriter_dramatic '  He went down hard. Jill could not get to him in time.'
    typewriter_dramatic ''
    source "$GAME_DIR/.Game_Files/Scenes/death.sh"
    return 1
fi

typewriter_regular '        Barry: Good. Next.'
sleep 0.3

# --- Question 2 ---
typewriter_regular '  Q2. You need to find which directory you are currently in.'
typewriter_regular '      Which command do you use?'
typewriter_regular ''
typewriter_regular '    1) ls'
typewriter_regular '    2) cd ../'
typewriter_regular '    3) pwd'
typewriter_regular '    4) whoami'
typewriter_regular ''
read -p "  Answer (1-4): " q2
echo ""

if [ "$q2" != "3" ]; then
    typewriter_dramatic ''
    typewriter_dramatic '        Barry: Jill!'
    typewriter_dramatic '  The snake moved faster than either of them expected.'
    typewriter_dramatic ''
    source "$GAME_DIR/.Game_Files/Scenes/death.sh"
    return 1
fi

typewriter_regular '        Barry: Right. Last one.'
sleep 0.3

# --- Question 3 ---
typewriter_regular '  Q3. You want to move a file called Barry.sh from'
typewriter_regular '      the current directory into a subdirectory called snake_room.'
typewriter_regular '      Which command do you use?'
typewriter_regular ''
typewriter_regular '    1) cp ./Barry.sh ./snake_room/'
typewriter_regular '    2) cd ./Barry.sh'
typewriter_regular '    3) mv ./Barry.sh ./snake_room/'
typewriter_regular '    4) cat ./Barry.sh'
typewriter_regular ''
read -p "  Answer (1-4): " q3
echo ""

if [ "$q3" != "3" ]; then
    typewriter_dramatic ''
    typewriter_dramatic '        Barry: Come on, Jill!'
    typewriter_dramatic '  The snake did not wait for a correction.'
    typewriter_dramatic ''
    source "$GAME_DIR/.Game_Files/Scenes/death.sh"
    return 1
fi

typewriter_regular '        Barry: That is my girl. FIRE IN THE HOLE!'
sleep 0.3
typewriter_dramatic ''
typewriter_dramatic '  Barry emptied the Colt .45 into the snake from point-blank range.'
typewriter_dramatic '  The hallway shook. Then went quiet.'
typewriter_dramatic ''
typewriter_regular '        Barry: You alright?'
typewriter_regular '        Jill: Ask me again in five minutes.'
typewriter_regular '        Barry: Ha. Go on. I am going to stay and look at this thing.'
typewriter_regular '          Something about the way it healed... it is not natural.'
typewriter_regular '          Even for whatever they were doing down here.'
typewriter_regular '        Jill: I know. Be careful, Barry.'
typewriter_regular '        Barry: Always.'
typewriter_regular ''

sed -i 's/SNAKE_DEFEATED=false/SNAKE_DEFEATED=true/' "$GAME_DIR/.gamestate"
return 0
EOF

# --- tyrant_boss.sh ---
cat > "$GAME_DIR/.Game_Files/Locks/tyrant_boss.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_dramatic.sh"
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"

clear
typewriter_dramatic ''
typewriter_dramatic '  The Tyrant dropped from the ceiling of the helipad like a verdict.'
typewriter_dramatic '  Eight feet of engineered muscle and exposed bone.'
typewriter_dramatic '  It remembered Jill from the lab. Or something in it did.'
typewriter_dramatic ''
typewriter_regular '  Brad was overhead. The rocket launcher was in the box.'
typewriter_regular '  But first, she had to survive long enough to use it.'
typewriter_regular '  Three questions. One chance each.'
typewriter_regular ''
sleep 0.3

# --- Question 1 ---
typewriter_regular '  Q1. You want to search inside a file called lab_notes.txt'
typewriter_regular '      for the word "tyrant". Which command do you use?'
typewriter_regular ''
typewriter_regular '    1) cat lab_notes.txt | head'
typewriter_regular '    2) grep "tyrant" ./lab_notes.txt'
typewriter_regular '    3) find ./lab_notes.txt'
typewriter_regular '    4) tail lab_notes.txt'
typewriter_regular ''
read -p "  Answer (1-4): " q1
echo ""

if [ "$q1" != "2" ]; then
    typewriter_dramatic ''
    typewriter_dramatic '  Jill reached for the box.'
    typewriter_dramatic '  The Tyrant reached her first.'
    typewriter_dramatic ''
    source "$GAME_DIR/.Game_Files/Scenes/death.sh"
    return 1
fi

typewriter_regular '  Correct.'
sleep 0.3

# --- Question 2 ---
typewriter_regular '  Q2. You want to see the last 10 lines of a long log file.'
typewriter_regular '      Which command do you use?'
typewriter_regular ''
typewriter_regular '    1) head -10 ./log.txt'
typewriter_regular '    2) cat ./log.txt'
typewriter_regular '    3) tail -10 ./log.txt'
typewriter_regular '    4) less ./log.txt'
typewriter_regular ''
read -p "  Answer (1-4): " q3
echo ""

if [ "$q3" != "3" ]; then
    typewriter_dramatic ''
    typewriter_dramatic '  The Tyrant closed the distance in half a second.'
    typewriter_dramatic '  Jill had no answer for it.'
    typewriter_dramatic ''
    source "$GAME_DIR/.Game_Files/Scenes/death.sh"
    return 1
fi

typewriter_regular '  Correct.'
sleep 0.3

# --- Question 3 ---
typewriter_regular '  Q3. Which command tells you what your current username is?'
typewriter_regular ''
typewriter_regular '    1) pwd'
typewriter_regular '    2) ls -la'
typewriter_regular '    3) echo'
typewriter_regular '    4) whoami'
typewriter_regular ''
read -p "  Answer (1-4): " q3
echo ""

if [ "$q3" != "4" ]; then
    typewriter_dramatic ''
    typewriter_dramatic '  Jill lost focus for one second.'
    typewriter_dramatic '  The Tyrant only needed one.'
    typewriter_dramatic ''
    source "$GAME_DIR/.Game_Files/Scenes/death.sh"
    return 1
fi

typewriter_regular '  Correct.'
sleep 0.3
typewriter_dramatic ''
typewriter_dramatic '  Jill cleared her mind. Three for three.'
typewriter_dramatic '  The box was in her hands.'
typewriter_dramatic ''
return 0
EOF

# =============================================================================
# DAY 1 COMPLETE
# =============================================================================
# =============================================================================
# DAY 2
# =============================================================================
# =============================================================================
# SCENES
# =============================================================================

# --- opening.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/opening.sh" << 'EOF'
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
typewriter_regular '  Raccoon City. Bravo Team went to the hideout'
typewriter_regular '  of the group, and disappeared.'
sleep 0.3
typewriter_regular ''
typewriter_regular '      Jill: Look, Chris!'
sleep 0.5
typewriter_regular ''
typewriter_regular "  It was Bravo Team's helicopter. Nobody was in it."
typewriter_regular '  Rabid beasts jumped from the tall grass.'
typewriter_regular "  Joseph's scream tore through the clearing."
sleep 0.3
typewriter_regular ''
typewriter_regular '  The helicopter flew off into the dark horizon.'
typewriter_regular '  The rabid dogs were getting closer...'
sleep 0.3
typewriter_regular ''
typewriter_regular '      Chris: Jill! Run for that house!'
typewriter_regular ''
typewriter_regular '  Jill and Barry sprinted toward a soft glow.'
typewriter_regular '  A mansion. The doors barely budged.'
sleep 0.5
typewriter_regular ''
typewriter_regular '      cat ./Barry_Help.txt'
typewriter_regular ''
EOF

# --- enter_mainhall.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/enter_mainhall.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
source "$GAME_DIR/.Game_Files/Design/typewriter_dramatic.sh"
clear
sleep 0.3
typewriter_dramatic ''
typewriter_dramatic '  They have escaped into the mansion, where they'
typewriter_dramatic '  thought it was safe . . .'
typewriter_dramatic ''
typewriter_dramatic '                        Yet . . .'
sleep 0.5
typewriter_regular ''
typewriter_regular '    Wesker: Wow, what a mansion!'
typewriter_regular ''
typewriter_regular '  Lush red carpet ran from the front doors to the top of the'
typewriter_regular '  grand staircase. Marble floors caught flashes of lightning.'
typewriter_regular ''
typewriter_regular '    Jill: Captain Wesker, where is Chris?'
typewriter_regular '    Wesker: Stop it! Do not open that door!'
typewriter_regular '    Jill: But Chris is--'
typewriter_regular ''
typewriter_regular '  A gunshot. Somewhere behind the DoubleDoors to the left.'
typewriter_regular ''
typewriter_regular '    Barry: What is it?'
typewriter_regular '    Wesker: Maybe it is Chris. Jill, can you go?'
typewriter_regular '    Barry: I am going with you.'
typewriter_regular '        Chris is our old partner, ya know.'
typewriter_regular '    Wesker: Stay alert!'
typewriter_regular ''
typewriter_regular '  Jill was relieved Barry was coming. And that he had his Colt .45.'
typewriter_regular ''
typewriter_regular '    Barry: Use cd to change our directory to doubledoors.'
typewriter_regular ''
sed -i 's/ENTER_MANSION_COMPLETE=false/ENTER_MANSION_COMPLETE=true/' "$GAME_DIR/.gamestate"
EOF

# --- enter_forest.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/enter_forest.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
source "$GAME_DIR/.gamestate"
if [ "$FOREST_VISITED" = "false" ]; then
    clear
    typewriter_regular ''
    typewriter_regular '  The path into the courtyard ran through the outer edge of'
    typewriter_regular '  the forest. Tall pines blocked most of the moon.'
    typewriter_regular ''
    typewriter_regular '  Something on the ground ahead caught the light.'
    typewriter_regular '  A boot. Then a leg. Then the rest of Forest Speyer.'
    typewriter_regular ''
    typewriter_regular '      Barry: Forest...'
    typewriter_regular '      Jill: He is... what did this?'
    typewriter_regular ''
    typewriter_regular '  The body had been picked apart. Long tears in the jacket.'
    typewriter_regular '  Something with a wingspan had done this.'
    typewriter_regular ''
    typewriter_regular '      Barry: Look around. He might have had something on him.'
    typewriter_regular ''
    typewriter_regular '  NOTE: Use the command  file ./filename  to identify'
    typewriter_regular '  what type something is before you open it.'
    typewriter_regular '  Not everything in here is what it looks like.'
    typewriter_regular ''
    sed -i 's/FOREST_VISITED=false/FOREST_VISITED=true/' "$GAME_DIR/.gamestate"
fi
EOF

# --- barry_found_exiting_forest.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/barry_found_exiting_forest.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
clear
typewriter_regular ''
typewriter_regular '  On the far side of the courtyard, a figure stepped out of the trees.'
typewriter_regular '  Hand on his Colt .45. Scanning.'
typewriter_regular ''
typewriter_regular '      Jill: Barry!'
typewriter_regular '      Barry: Jill! You made it.'
typewriter_regular '        I thought you were going to check the other side of the mansion.'
typewriter_regular '      Jill: Change of plans. What are you doing out here?'
typewriter_regular '      Barry: Same thing you are. Looking for a way in.'
typewriter_regular '        Something is wrong in there, Jill.'
typewriter_regular '        Wesker is not telling us everything.'
typewriter_regular ''
typewriter_regular '  Barry holstered his weapon and fell in beside her.'
typewriter_regular '  Together they headed back toward the mansion.'
typewriter_regular ''
sed -i 's/BARRY_FOUND=false/BARRY_FOUND=true/' "$GAME_DIR/.gamestate"
EOF

# --- enter_doubledoors.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/enter_doubledoors.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
source "$GAME_DIR/.gamestate"
if [ "$DOUBLEDOORS_VISITED" = "false" ]; then
    clear
    typewriter_regular ''
    typewriter_regular '    Together Jill and Barry passed through the double doors'
    typewriter_regular '    and entered a long extravagant dining room.'
    typewriter_regular '    The storm picked up outside. The air smelled... of...'
    typewriter_regular ''
    typewriter_regular '        Barry: What? What is this? . . . Blood?'
    typewriter_regular '          . . . Hope this is not Chris'"'"'s blood...'
    typewriter_regular ''
    typewriter_regular '    A man crawled from under the large dining table.'
    typewriter_regular '    He stood, raised his arms, covered in blood, and groaned.'
    typewriter_regular '    His eyes were completely cloudy. Already dead.'
    typewriter_regular '    Behind him, the body of Kenneth Sullivan. Throat ripped out.'
    typewriter_regular ''
    typewriter_regular '        Barry: He is insane!'
    typewriter_regular ''
    typewriter_regular '    Barry fired. The man took one more step forward.'
    typewriter_regular '    Then his head came apart.'
    typewriter_regular ''
    typewriter_regular '        Barry: What the hell?'
    typewriter_regular '        Jill: Let'"'"'s report this to Wesker.'
    typewriter_regular '          There is a hallway through here. Let'"'"'s look around.'
    typewriter_regular ''
    sed -i 's/DOUBLEDOORS_VISITED=false/DOUBLEDOORS_VISITED=true/' "$GAME_DIR/.gamestate"
fi
EOF

# --- search_wesker.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/search_wesker.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
sed -i 's/SEARCH_WESKER_PLAYED=false/SEARCH_WESKER_PLAYED=true/' "$GAME_DIR/.gamestate"
clear
typewriter_regular ''
typewriter_regular '    Thunder roared outside. Heavy rain beat down on the'
typewriter_regular '    large windows of the empty Main Hall.'
typewriter_regular ''
typewriter_regular '        Barry: Wesker! Help me look for him, Jill.'
typewriter_regular ''
typewriter_regular '    . . . . .'
typewriter_regular ''
typewriter_regular '        Barry: Find anything?'
typewriter_regular '        Jill: Nothing. I cannot figure this out at all.'
typewriter_regular '        Barry: Beats me too.'
typewriter_regular '        Jill: Now it is Wesker'"'"'s time to disappear.'
typewriter_regular '        Barry: Let'"'"'s keep looking. Separately this time.'
typewriter_regular '          I'"'"'ll check the dining room again.'
typewriter_regular ''
typewriter_regular '  Barry headed back toward the doubledoors.'
typewriter_regular '  Jill stood alone in the main hall for the first time.'
typewriter_regular ''
EOF

# --- enter_browndoor.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/enter_browndoor.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
clear
typewriter_regular ''
typewriter_regular '        Jill unlocked the browndoor and slipped inside.'
typewriter_regular '        The room smelled of old wood and something chemical.'
typewriter_regular '        A large stone statue stood in the corner, holding a vase.'
typewriter_regular ''
EOF

# --- enter_bluedoor.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/enter_bluedoor.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
clear
typewriter_regular ''
typewriter_regular '        In the diary, they wrote about a way out through here...'
typewriter_regular '        Jill stepped inside and looked around carefully.'
typewriter_regular ''
EOF

# --- enter_hallway.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/enter_hallway.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
source "$GAME_DIR/.gamestate"
if [ "$HALLWAY_VISITED" = "false" ]; then
    clear
    typewriter_regular ''
    typewriter_regular '  Beyond the dining room, a long hallway stretched ahead.'
    typewriter_regular '  Two doors. One green. One brown.'
    typewriter_regular '  At their feet, face-down on the floor: Kenneth Sullivan.'
    typewriter_regular '  Something in his hand.'
    typewriter_regular ''
    typewriter_regular '      Barry: Kenneth...'
    typewriter_regular '      Jill: There is something in his hand.'
    typewriter_regular ''
    typewriter_regular '  NOTE: Use  ls -la  to see if anything is hidden here.'
    typewriter_regular ''
    sed -i 's/HALLWAY_VISITED=false/HALLWAY_VISITED=true/' "$GAME_DIR/.gamestate"
fi
EOF

# --- enter_greendoor.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/enter_greendoor.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
source "$GAME_DIR/.gamestate"
if [ "$GREENDOOR_VISITED" = "false" ]; then
    clear
    typewriter_regular ''
    typewriter_regular '  Richard Aiken was on the floor near the far wall.'
    typewriter_regular '  His shoulder was open to the bone. Giant bite marks.'
    typewriter_regular '  Around him: overturned medical cases, shattered vials,'
    typewriter_regular '  and a scatter of serums that had rolled across the tile.'
    typewriter_regular ''
    typewriter_regular '      Jill: Richard! Can you hear me?'
    typewriter_regular '      Richard: Jill... this house... there is a snake...'
    typewriter_regular '        Huge... and wrong... I wrote everything down...'
    typewriter_regular '        The end of my notes... the password...'
    typewriter_regular '        I hid it at the end... in case...'
    typewriter_regular ''
    typewriter_regular '  Richard stopped moving.'
    typewriter_regular ''
    typewriter_regular '      Barry: Jill... he is gone.'
    typewriter_regular '      Jill: His notes. He said the end of his notes.'
    typewriter_regular ''
    typewriter_regular '  NOTE: Use  tail  to read the end of a long file.'
    typewriter_regular '        tail -5 ./filename  shows the last 5 lines.'
    typewriter_regular ''
    typewriter_regular '  NOTE: Barry'"'"'s Help file is near Richard.'
    typewriter_regular '        When you are ready to move to the next area,'
    typewriter_regular '        move it with you using the mv command.'
    typewriter_regular '        mv ./Barry_Help.sh ../browndoor/Barry_Help.sh'
    typewriter_regular ''
    sed -i 's/GREENDOOR_VISITED=false/GREENDOOR_VISITED=true/' "$GAME_DIR/.gamestate"
fi
EOF

# --- barry_recovery.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/barry_recovery.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_dramatic.sh"
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
clear
typewriter_dramatic ''
typewriter_dramatic '  The snake'"'"'s fang caught Jill across the arm.'
typewriter_dramatic '  She felt the burn spread before she hit the floor.'
typewriter_dramatic ''
typewriter_dramatic '      Barry: JILL!'
typewriter_dramatic ''
typewriter_dramatic '  He was there. Somehow.'
typewriter_dramatic '  Pulling her back from the door before the snake could finish.'
typewriter_dramatic ''
sleep 0.5
typewriter_regular '  Jill woke in the hallway outside the browndoor.'
typewriter_regular '  Barry had propped her against the wall.'
typewriter_regular '  He was watching the door.'
typewriter_regular ''
typewriter_regular '      Barry: You are going to be okay.'
typewriter_regular '        Richard had serum on him. Lucky for you.'
typewriter_regular '      Jill: The snake...'
typewriter_regular '      Barry: Still in there. We go back together or not at all.'
typewriter_regular ''
typewriter_regular '  Barry looked at her. Then, quietly:'
typewriter_regular ''
typewriter_regular '      Barry: Before we go back in there...'
typewriter_regular '        I need to know who I am working with.'
typewriter_regular '        Run the whoami command. Humor me.'
typewriter_regular ''
EOF

# --- barry_whoami.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/barry_whoami.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
typewriter_regular ''
typewriter_regular '  Barry looked at the terminal readout. Then back at Jill.'
typewriter_regular ''
typewriter_regular '      Barry: See? Right there. That is who you are.'
typewriter_regular '        You are Jill Valentine.'
typewriter_regular '        And Jill Valentine does not get eaten by a snake.'
typewriter_regular ''
typewriter_regular '      Jill: Are you done?'
typewriter_regular '      Barry: Almost.'
typewriter_regular '        I am going to stay here and cover the door.'
typewriter_regular '        But I can go in with you if you need me.'
typewriter_regular '        Move my file into the browndoor directory first.'
typewriter_regular '        Then we go in together.'
typewriter_regular ''
typewriter_regular '        mv ./.Barry.sh ./browndoor/.Barry.sh'
typewriter_regular ''
typewriter_regular '        Or go in alone. Your call, Valentine.'
typewriter_regular ''
sed -i 's/BARRY_WHOAMI_PLAYED=false/BARRY_WHOAMI_PLAYED=true/' "$GAME_DIR/.gamestate"
# reveal .Barry.sh to hallway so player can mv it to browndoor
mv "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/doubledoors/hallway/browndoor/.Barry_hidden.sh" \
   "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/doubledoors/hallway/.Barry.sh" 2>/dev/null
EOF

# --- enter_courtyard.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/enter_courtyard.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
source "$GAME_DIR/.gamestate"
if [ "$COURTYARD_VISITED" = "false" ]; then
    clear
    typewriter_regular ''
    typewriter_regular '  The courtyard was open to the storm. Rain hammered the stone.'
    typewriter_regular '  Jill moved along the wall, keeping low.'
    typewriter_regular ''
    typewriter_regular '  Across the courtyard, a figure moved toward the Guardhouse.'
    typewriter_regular '  Tall. Deliberate. She recognized the posture.'
    typewriter_regular ''
    typewriter_regular '      Jill: Wesker...'
    typewriter_regular ''
    typewriter_regular '  He disappeared through the door.'
    typewriter_regular '  She waited. He did not come back out.'
    typewriter_regular ''
    typewriter_regular '  The Guardhouse was ahead. Something felt wrong about it.'
    typewriter_regular '  Like the air around it had weight.'
    typewriter_regular ''
    sed -i 's/COURTYARD_VISITED=false/COURTYARD_VISITED=true/' "$GAME_DIR/.gamestate"
fi
EOF

# --- enter_guardhouse.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/enter_guardhouse.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
source "$GAME_DIR/.gamestate"
clear
typewriter_regular ''
typewriter_regular '  Inside, the Guardhouse was lined floor-to-ceiling with bookcases.'
typewriter_regular '  Heavy oak. Packed with identical binders that no one had touched in years.'
typewriter_regular '  No sign of Wesker. But something hummed behind the far wall.'
typewriter_regular ''
typewriter_regular '      Jill: Wesker?'
typewriter_regular ''
typewriter_regular '  The hum again. Low. Mechanical. Behind the books.'
typewriter_regular ''
typewriter_regular '  She called out again, just to be sure.'
typewriter_regular ''
typewriter_regular '  NOTE: Type   echo "Wesker?"   to call out.'
typewriter_regular '        Something may respond.'
typewriter_regular ''
EOF

# --- wesker_echo_response.sh (triggered by echo detection in SourceMeToStart) ---
cat > "$GAME_DIR/.Game_Files/Scenes/wesker_echo_response.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
source "$GAME_DIR/.Game_Files/Design/typewriter_dramatic.sh"
source "$GAME_DIR/.gamestate"
if [ "$BOOKCASES_REMOVED" = "false" ]; then
    clear
    typewriter_regular ''
    typewriter_regular '  No answer.'
    typewriter_regular '  But the hum behind the wall got louder. Then stopped.'
    typewriter_regular '  Jill walked to the nearest bookcase and pulled.'
    typewriter_regular '  It shifted. Then the next one. And the next.'
    typewriter_regular ''
    typewriter_regular '  Behind the bookcases: a hatch in the floor.'
    typewriter_regular '  Steel. Old. A ladder bolted to the inside wall going down.'
    typewriter_regular '  A small panel beside it read:'
    typewriter_regular ''
    typewriter_regular '    ARKLAY RESEARCH DIVISION -- SUBLEVEL ACCESS'
    typewriter_regular ''
    typewriter_regular '  NOTE: Remove the bookcases to clear the way.'
    typewriter_regular '        rm ./Bookcase_1.txt ./Bookcase_2.txt ./Bookcase_3.txt'
    typewriter_regular ''
    typewriter_regular '        When they are gone, the hidden_ladder will appear.'
    typewriter_regular ''
fi
EOF

# --- enter_umbrella.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/enter_umbrella.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
clear
typewriter_regular ''
typewriter_regular '    The ladder dropped her into a corridor she was not ready for.'
typewriter_regular ''
typewriter_regular '    The floor was wet. Not from a leak --'
typewriter_regular '    the whole corridor was damp, like something lived down here.'
typewriter_regular '    Lights above flickered and buzzed, casting everything in'
typewriter_regular '    a pale, sickly yellow. Dark streaks ran down the walls'
typewriter_regular '    that Jill chose not to think too hard about.'
typewriter_regular ''
typewriter_regular '        Jill: An Umbrella Laboratory?'
typewriter_regular ''
typewriter_regular '        Jill: Creating those monsters...'
typewriter_regular ''
typewriter_regular '    She kept moving.'
typewriter_regular ''
EOF

# --- suspect_wesker.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/suspect_wesker.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_dramatic.sh"
clear
typewriter_dramatic ''
typewriter_dramatic '        Jill: That .orders.txt...'
typewriter_dramatic '          Wesker knew about all of this from the start.'
typewriter_dramatic '          He was never looking for Chris.'
typewriter_dramatic '          He was never on our side.'
typewriter_dramatic ''
EOF

# --- Enter_Cultivation_Room.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/Enter_Cultivation_Room.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
clear
typewriter_regular ''
typewriter_regular '    The blast door lifted. Jill stepped inside alone.'
typewriter_regular '    Cold air. Thin fog at her boots.'
typewriter_regular '    Large glass tubes filled the room. She saw her reflection'
typewriter_regular '    distort in every one of them.'
typewriter_regular '    Then, through the fog: someone at a keyboard.'
typewriter_regular ''
typewriter_regular '        Jill: Wesker?'
typewriter_regular ''
typewriter_regular '        Wesker: Well, well...'
typewriter_regular ''
typewriter_regular '    He did not turn around.'
typewriter_regular ''
typewriter_regular '        Jill: Why do you have to destroy S.T.A.R.S.?'
typewriter_regular ''
typewriter_regular '        Wesker: That is Umbrella'"'"'s intention. This laboratory has been'
typewriter_regular '          engaging in dangerous experiments. A virus got out.'
typewriter_regular '          This disaster cannot be made public.'
typewriter_regular ''
typewriter_regular '        Jill: So you are a slave to Umbrella, along with'
typewriter_regular '          these virus monsters.'
typewriter_regular ''
typewriter_regular '        Wesker: I think you misunderstand me, Jill.'
typewriter_regular '          I am going to burn this entire laboratory.'
typewriter_regular '          If you helped create one of the most powerful'
typewriter_regular '          biological weapons... what would you do?'
typewriter_regular ''
typewriter_regular '        Jill: You must stop this now.'
typewriter_regular ''
typewriter_regular '        Wesker: No one understands its real value.'
typewriter_regular '          Better yet. I am going to show you the Tyrant.'
typewriter_regular ''
typewriter_regular '    Wesker stopped typing. One of the large tubes began to drain.'
typewriter_regular '    Over eight feet tall. A giant mutated claw for a left hand.'
typewriter_regular '    A beating heart exposed on the chest.'
typewriter_regular '    The Tyrant opened its eyes.'
typewriter_regular ''
typewriter_regular '        Wesker: The most powerful biological weapon in the world.'
typewriter_regular '          All this power will be mine...'
typewriter_regular ''
typewriter_regular '    The Tyrant broke through the glass in one motion.'
typewriter_regular ''
typewriter_regular '        Wesker: What? Do not come this way!'
typewriter_regular ''
typewriter_regular '    The mutated claw pierced through Wesker'"'"'s chest.'
typewriter_regular '    The Tyrant threw his body across the room.'
typewriter_regular '    Then it turned. And looked at Jill.'
typewriter_regular ''
typewriter_regular '    She started shooting.'
typewriter_regular ''
typewriter_regular '          [Overhead: THIS FACILITY WILL DETONATE. ALL DOORS NOW UNLOCKED.]'
typewriter_regular '          [Overhead: ALL PERSONNEL MUST EVACUATE IMMEDIATELY...]'
typewriter_regular ''
typewriter_regular '        Jill: I have to get out of here.'
typewriter_regular ''
sed -i 's/CULTIVATION_COMPLETE=false/CULTIVATION_COMPLETE=true/' "$GAME_DIR/.gamestate"
EOF

# --- self-destruct-sequence.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/self-destruct-sequence.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
clear
typewriter_regular ''
typewriter_regular '    [Overhead: THIS FACILITY WILL DETONATE. ALL DOORS ARE NOW UNLOCKED.]'
typewriter_regular '    [Overhead: ALL PERSONNEL MUST EVACUATE IMMEDIATELY THROUGH]'
typewriter_regular '    [Overhead: DIRECTORY: Emergency_Helipad]'
typewriter_regular ''
EOF

# --- death.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/death.sh" << 'EOF'
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
echo "  ls -Ra                     List all contents recursively"
echo "  cd ./name                  Change into a directory"
echo "  cd ../                     Go back to the previous directory"
echo "  cat ./file.txt             Read a file"
echo "  pwd                        Print your current directory path"
echo "  man command                Read the manual for any command"
echo "  head -n ./file             Show first n lines of a file"
echo "  tail -n ./file             Show last n lines of a file"
echo "  grep 'word' ./file         Search for a word inside a file"
echo "  whoami                     Print your current username"
echo "  echo 'text'                Print text to the terminal"
echo "  mv ./file ./destination    Move or rename a file"
echo "  rm ./file                  Delete a file"
echo "  file ./filename            Identify what type a file is"
echo "  touch ./filename           Create an empty file"
echo ""
function cd () { builtin cd "$@"; }
rm -f ~/.RE-Linux-Normal_env
cp "$GAME_DIR/.Game_Files/Design/gamestate_defaults" "$GAME_DIR/.gamestate"
sed -i '/RE-Linux-Normal_env/d' ~/.bashrc
echo "  To play again: source SourceMeToStart.sh"
echo ""
echo "  Press Enter to exit . . ."
read _
unset -f rm mv echo 2>/dev/null
builtin cd "$GAME_DIR"
return 1
EOF

# --- ThreeSurvivors.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/ThreeSurvivors.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
clear
typewriter_regular ''
typewriter_regular '    Outside, the Emergency_Helipad was boxed in among the trees.'
typewriter_regular '    The sound of a helicopter in the distance. Sun starting to rise.'
typewriter_regular '    Brad was running out of fuel...'
typewriter_regular ''
typewriter_regular '    Jill spotted a red-framed box with an orange flare gun.'
typewriter_regular '    She fired it into the sky. The helicopter got louder.'
typewriter_regular ''
typewriter_regular '    Then an explosion in the far corner.'
typewriter_regular ''
typewriter_regular '    The Tyrant leapt from the rubble and landed between them.'
typewriter_regular '    Eyes locked on Jill. Barry raised his Colt .45 -- empty.'
typewriter_regular ''
typewriter_regular '            BARRY: Shit! I'"'"'m empty! Jill--'
typewriter_regular ''
typewriter_regular '    The Tyrant stood between all three of them, deciding.'
typewriter_regular ''
typewriter_regular '            BRAD: USE THIS! KILL THAT MONSTER!'
typewriter_regular ''
typewriter_regular '    A large green box fell from the helicopter overhead.'
typewriter_regular '    Bright yellow sticker on all sides:'
typewriter_regular '    TO FIRE ENTER: rocket_launcher'
typewriter_regular ''
typewriter_regular '            BARRY: Hey! Big guy!'
typewriter_regular '            CHRIS: Over here!'
typewriter_regular ''
typewriter_regular '    Barry and Chris drew the Tyrant away.'
typewriter_regular '    Jill ran for the box.'
typewriter_regular ''
echo -n "Password: "
read input
if [ "$input" = "rocket_launcher" ]; then
    source "$GAME_DIR/.Game_Files/Scenes/End-Game/great/great_ending.sh"
else
    typewriter_regular 'Jill pulled the trigger.'
    typewriter_regular 'But nothing fired.'
    typewriter_regular 'She looked back down:'
    typewriter_regular 'TO FIRE ENTER: rocket_launcher'
    echo -n "Password: "
    read input2
    if [ "$input2" = "rocket_launcher" ]; then
        source "$GAME_DIR/.Game_Files/Scenes/End-Game/great/great_ending.sh"
    else
        typewriter_regular 'Jill was trying to enter the password,'
        typewriter_regular 'but her fingers went numb,'
        typewriter_regular 'and a large claw had burst from her chest. . .'
        source "$GAME_DIR/.Game_Files/Scenes/death.sh"
    fi
fi
EOF

# --- TwoSurvivors.sh ---
cat > "$GAME_DIR/.Game_Files/Scenes/TwoSurvivors.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
clear
typewriter_regular ''
typewriter_regular '    Outside, the Emergency_Helipad was boxed in among the trees.'
typewriter_regular '    The sound of a helicopter in the distance. Sun starting to rise.'
typewriter_regular '    Brad was running out of fuel...'
typewriter_regular ''
typewriter_regular '    Jill spotted a red-framed box with an orange flare gun.'
typewriter_regular '    She fired into the sky. The helicopter got louder.'
typewriter_regular ''
typewriter_regular '    Then an explosion in the far corner.'
typewriter_regular ''
typewriter_regular '    Jill and Barry stared as the Tyrant leapt from the rubble.'
typewriter_regular '    Eyes locked on Jill. Barry raised his Colt .45 -- empty.'
typewriter_regular ''
typewriter_regular '        BARRY: Shit! I'"'"'m empty! Jill!!'
typewriter_regular ''
typewriter_regular '        BRAD: USE THIS! KILL THAT MONSTER!'
typewriter_regular ''
typewriter_regular '    A large green box fell from the helicopter overhead.'
typewriter_regular '    Bright yellow sticker on all sides:'
typewriter_regular '    TO FIRE ENTER: rocket_launcher'
typewriter_regular ''
typewriter_regular '        BARRY: Hey! Big guy!'
typewriter_regular ''
typewriter_regular '    Barry drew the Tyrant. Jill ran for the box.'
typewriter_regular ''
echo -n "Password: "
read input
if [ "$input" = "rocket_launcher" ]; then
    source "$GAME_DIR/.Game_Files/Scenes/End-Game/good/good_ending.sh"
else
    typewriter_regular 'Jill pulled the trigger.'
    typewriter_regular 'But nothing fired.'
    typewriter_regular 'She looked back down:'
    typewriter_regular 'TO FIRE ENTER: rocket_launcher'
    echo -n "Password: "
    read input2
    if [ "$input2" = "rocket_launcher" ]; then
        source "$GAME_DIR/.Game_Files/Scenes/End-Game/good/good_ending.sh"
    else
        source "$GAME_DIR/.Game_Files/Scenes/End-Game/bad/bad_ending.sh"
    fi
fi
EOF

# =============================================================================
# END-GAME SCENES
# =============================================================================

cat > "$GAME_DIR/.Game_Files/Scenes/End-Game/great/great_ending.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
clear
typewriter_regular ''
typewriter_regular '    Jill planted her feet and took aim.'
typewriter_regular '    The Tyrant stared at the rocket curiously.'
typewriter_regular '    Then it exploded into a million pieces that rained down'
typewriter_regular '    over Jill, Barry, and Chris.'
typewriter_regular ''
typewriter_regular '    Inside the helicopter, Jill rested her head on Chris'"'"'s shoulder.'
typewriter_regular '    Barry loaded his Colt .45. Just in case...'
typewriter_regular ''
typewriter_regular '    In the distance, the self-destruct sirens cut off.'
typewriter_regular '    Then, the entire mansion exploded.'
typewriter_regular '    Taking with it every last piece of evidence.'
typewriter_regular ''
source "$GAME_DIR/.Game_Files/Scenes/End-Game/great/thank_you.sh"
EOF

cat > "$GAME_DIR/.Game_Files/Scenes/End-Game/great/thank_you.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
typewriter_regular ''
typewriter_regular '  Thank you for playing RE-Linux / Normal.'
typewriter_regular ''
typewriter_regular '  You have now used:'
typewriter_regular '  ls, ls -la, ls -Ra, cd, cat, pwd, man'
typewriter_regular '  head, tail, grep, whoami, echo, mv, rm, file, touch'
typewriter_regular ''
typewriter_regular '  If you enjoyed this, try the next challenge:'
typewriter_regular '  cd ./Hard  !where the mansion has no mercy!'
typewriter_regular ''
typewriter_regular '        . . . G O O D  L U C K !'
echo ""
echo "  Command                    What It Does"
echo "  -------                    ------------"
echo "  ls                         List contents of the current directory"
echo "  ls -la                     List all contents, including hidden files"
echo "  ls -Ra                     List all contents recursively"
echo "  cd ./name                  Change into a directory"
echo "  cd ../                     Go back to the previous directory"
echo "  cat ./file.txt             Read a file"
echo "  pwd                        Print your current directory path"
echo "  man command                Read the manual for any command"
echo "  head -n ./file             Show first n lines of a file"
echo "  tail -n ./file             Show last n lines of a file"
echo "  grep 'word' ./file         Search for a word inside a file"
echo "  whoami                     Print your current username"
echo "  echo 'text'                Print text to the terminal"
echo "  mv ./file ./destination    Move or rename a file"
echo "  rm ./file                  Delete a file"
echo "  file ./filename            Identify what type a file is"
echo "  touch ./filename           Create an empty file"
echo ""
function cd () { builtin cd "$@"; }
rm -f ~/.RE-Linux-Normal_env
cp "$GAME_DIR/.Game_Files/Design/gamestate_defaults" "$GAME_DIR/.gamestate"
sed -i '/RE-Linux-Normal_env/d' ~/.bashrc
echo "  Press Enter to exit . . ."
read _
unset -f rm mv echo 2>/dev/null
builtin cd "$GAME_DIR"
return 1
EOF

cat > "$GAME_DIR/.Game_Files/Scenes/End-Game/good/good_ending.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
clear
typewriter_regular ''
typewriter_regular '    JILL PLANTED HER FEET, AND TOOK AIM. THE ROCKET LAUNCHED.'
typewriter_regular '    THE TYRANT STARED AT THE MISSILE CURIOUSLY BEFORE EXPLODING'
typewriter_regular '    INTO A MILLION BITS THAT RAINED DOWN OVER JILL AND BARRY.'
typewriter_regular ''
typewriter_regular '    JILL PULLED BARRY TO HIS FEET AND THEY RAN FOR THE HELICOPTER.'
typewriter_regular '    INSIDE, JILL SAT NEXT TO BARRY WATCHING THE MANSION.'
typewriter_regular ''
typewriter_regular '        BARRY: What about... Chris?'
typewriter_regular '        JILL: Everything happened so fast...'
typewriter_regular '            I thought I saw some Holding_Cells, but...'
typewriter_regular ''
typewriter_regular '    IN THE DISTANCE, THE MANSION EXPLODED.'
typewriter_regular '    TAKING WITH IT ANY HOPE OF EVER FINDING CHRIS REDFIELD.'
typewriter_regular ''
source "$GAME_DIR/.Game_Files/Scenes/End-Game/good/encourage_great.sh"
EOF

cat > "$GAME_DIR/.Game_Files/Scenes/End-Game/good/encourage_great.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
typewriter_regular ''
typewriter_regular '    OH NO -- YOU GOT THE GOOD ENDING.'
typewriter_regular '    BUT WHAT ABOUT CHRIS?!'
typewriter_regular '    THERE IS A GREAT ENDING WAITING FOR YOU TO DISCOVER.'
typewriter_regular ''
typewriter_regular '        . . . G O O D  L U C K !'
typewriter_regular ''
echo ""
echo "  Command                    What It Does"
echo "  -------                    ------------"
echo "  ls                         List contents of the current directory"
echo "  ls -la                     List all contents, including hidden files"
echo "  ls -Ra                     List all contents recursively"
echo "  cd ./name                  Change into a directory"
echo "  cd ../                     Go back to the previous directory"
echo "  cat ./file.txt             Read a file"
echo "  pwd                        Print your current directory path"
echo "  man command                Read the manual for any command"
echo "  head -n ./file             Show first n lines of a file"
echo "  tail -n ./file             Show last n lines of a file"
echo "  grep 'word' ./file         Search for a word inside a file"
echo "  whoami                     Print your current username"
echo "  echo 'text'                Print text to the terminal"
echo "  mv ./file ./destination    Move or rename a file"
echo "  rm ./file                  Delete a file"
echo ""
function cd () { builtin cd "$@"; }
rm -f ~/.RE-Linux-Normal_env
cp "$GAME_DIR/.Game_Files/Design/gamestate_defaults" "$GAME_DIR/.gamestate"
sed -i '/RE-Linux-Normal_env/d' ~/.bashrc
echo "  Press Enter to exit . . ."
read _
unset -f rm mv echo 2>/dev/null
builtin cd "$GAME_DIR"
return 1
EOF

cat > "$GAME_DIR/.Game_Files/Scenes/End-Game/bad/bad_ending.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_dramatic.sh"
clear
typewriter_dramatic "    THE TYRANT SLASHED ITS GIANT CLAW DOWN,"
typewriter_dramatic "    KNOCKING THE rocket_launcher FROM JILL'S HANDS."
typewriter_dramatic "    SHE STUMBLED BACK, FALLING TO THE GROUND."
typewriter_dramatic ""
typewriter_dramatic "    BARRY DIVED FOR THE rocket_launcher AND WENT TO FIRE"
typewriter_dramatic "    BUT THE TYRANT WAS TOO FAST, SMACKING IT FROM HIS HANDS,"
typewriter_dramatic "    AND INTO THE WHIRLING BLADES OF THE HELICOPTER."
typewriter_dramatic ""
typewriter_dramatic "    EVERYTHING, INCLUDING BRAD, CAME CRASHING DOWN."
typewriter_dramatic "    THE TYRANT LEAPT INTO THE AIR AWAY FROM THE HELIPAD."
typewriter_dramatic "    TOWARDS... RACCOON_CITY..."
typewriter_dramatic ""
typewriter_dramatic "    SELF DESTRUCTION WILL DETONATE IN..."
typewriter_dramatic "      ... three ..."
typewriter_dramatic "        ... two ..."
typewriter_dramatic "          ... o"
typewriter_dramatic ""
source "$GAME_DIR/.Game_Files/Scenes/End-Game/bad/Encourage_try_again.sh"
EOF

cat > "$GAME_DIR/.Game_Files/Scenes/End-Game/bad/Encourage_try_again.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
typewriter_regular ''
typewriter_regular '    OH NO! -- YOU GOT THE BAD ENDING.'
typewriter_regular '    THERE IS A GOOD ENDING WAITING FOR YOU TO DISCOVER.'
typewriter_regular '    OR BETTER YET, THERE IS EVEN A GREAT ENDING.'
typewriter_regular ''
typewriter_regular '        . . . G O O D  L U C K !'
echo ""
echo "  Command                    What It Does"
echo "  -------                    ------------"
echo "  ls                         List contents of the current directory"
echo "  ls -la                     List all contents, including hidden files"
echo "  ls -Ra                     List all contents recursively"
echo "  cd ./name                  Change into a directory"
echo "  cd ../                     Go back to the previous directory"
echo "  cat ./file.txt             Read a file"
echo "  pwd                        Print your current directory path"
echo "  man command                Read the manual for any command"
echo "  head -n ./file             Show first n lines of a file"
echo "  tail -n ./file             Show last n lines of a file"
echo "  grep 'word' ./file         Search for a word inside a file"
echo "  whoami                     Print your current username"
echo "  echo 'text'                Print text to the terminal"
echo "  mv ./file ./destination    Move or rename a file"
echo "  rm ./file                  Delete a file"
echo ""
function cd () { builtin cd "$@"; }
rm -f ~/.RE-Linux-Normal_env
cp "$GAME_DIR/.Game_Files/Design/gamestate_defaults" "$GAME_DIR/.gamestate"
sed -i '/RE-Linux-Normal_env/d' ~/.bashrc
echo "  Press Enter to exit . . ."
read _
unset -f rm mv echo 2>/dev/null
builtin cd "$GAME_DIR"
return 1
EOF

# =============================================================================
# HOLDING CELLS — STAGED
# =============================================================================

LAB="$GAME_DIR/.Game_Files/staged/.hidden_ladder/Umbrella_Laboratory"

cat > "$LAB/Holding_Cells/Cell_1/.zombies.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
typewriter_regular ''
typewriter_regular '    The cell was filled with zombies.'
typewriter_regular '    A dozen of them. Maybe more.'
typewriter_regular '    Overpowered Jill before she could get the door shut.'
typewriter_regular '    Hands grabbed her hair. Teeth at her throat.'
typewriter_regular ''
source "$GAME_DIR/.Game_Files/Scenes/death.sh"
EOF

cat > "$LAB/Holding_Cells/Cell_2/spiders.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
typewriter_regular ''
typewriter_regular '    The cell was filled with silence.'
typewriter_regular ''
typewriter_regular '    Jill stepped inside. Empty. A chair, a desk, a thin layer of...'
typewriter_regular '    webs? Something shifted above her.'
typewriter_regular ''
typewriter_regular '    She looked up. Eight eyes looked back.'
typewriter_regular '    Legs the length of her arms wrapped around her shoulders.'
typewriter_regular '    The fangs found the soft place under her jaw.'
typewriter_regular ''
source "$GAME_DIR/.Game_Files/Scenes/death.sh"
EOF

cat > "$LAB/Holding_Cells/Cell_3/.Chris_Redfield.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
typewriter_regular ''
typewriter_regular '        Chris: Jill!'
typewriter_regular '        Jill: Chris! You are okay!'
typewriter_regular '        Chris: You found me. How did you know which cell?'
typewriter_regular '        Jill: grep.'
typewriter_regular '        Chris: What?'
typewriter_regular '        Jill: I will explain on the helicopter.'
typewriter_regular '        Chris: What happened to Wesker?'
typewriter_regular ''
typewriter_regular '    [Overhead: THE SELF-DESTRUCT SYSTEM HAS BEEN ACTIVATED.]'
typewriter_regular '    [Overhead: ALL PERSONNEL MUST EVACUATE IMMEDIATELY.]'
typewriter_regular ''
typewriter_regular '        Jill: Later. Let'"'"'s go.'
typewriter_regular '        Chris: Right behind you.'
typewriter_regular ''
sed -i 's/CHRIS_RESCUED=false/CHRIS_RESCUED=true/' "$GAME_DIR/.gamestate"
EOF

cat > "$LAB/Holding_Cells/Cell_4/.zombies.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
typewriter_regular ''
typewriter_regular '    The cell was filled with zombies.'
typewriter_regular '    A dozen of them. Maybe more.'
typewriter_regular '    Overpowered Jill before she could get the door shut.'
typewriter_regular ''
source "$GAME_DIR/.Game_Files/Scenes/death.sh"
EOF

cat > "$LAB/Holding_Cells/Cell_5/hunters.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
typewriter_regular ''
typewriter_regular '    Green scales. Yellow eyes that tracked Jill before she'
typewriter_regular '    could finish turning the handle. It leapt.'
typewriter_regular ''
typewriter_regular '    The claws came down in a single clean arc.'
typewriter_regular '    Jill did not have time to react.'
typewriter_regular '    She did not have time to scream.'
typewriter_regular ''
source "$GAME_DIR/.Game_Files/Scenes/death.sh"
EOF

cat > "$LAB/Holding_Cells/Cell_6/.chimeras.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
typewriter_regular ''
typewriter_regular '    Something that had once been human unfolded from the corner.'
typewriter_regular '    It had too many joints. Moved wrong.'
typewriter_regular '    Jill fired twice. It barely slowed down.'
typewriter_regular '    Then it was on her.'
typewriter_regular ''
source "$GAME_DIR/.Game_Files/Scenes/death.sh"
EOF

cat > "$LAB/Holding_Cells/Cell_7/neptune.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
typewriter_regular ''
typewriter_regular '    The cell was flooded. Knee deep.'
typewriter_regular '    Something long moved just under the surface.'
typewriter_regular '    Jill stepped back but the door had already locked behind her.'
typewriter_regular '    A fin broke the surface. Then teeth.'
typewriter_regular ''
source "$GAME_DIR/.Game_Files/Scenes/death.sh"
EOF

# --- Holding_Cells Barry_Help.txt ---
cat > "$LAB/Holding_Cells/Barry_Help.txt" << 'EOF'
    There are so many cells down here.
    And ls -Ra is going to return a lot of noise.
    Try something more focused.

    Use grep to search through all of it at once:

        grep -r "Chris" ./

    This will search every file and directory below where you are
    for the word "Chris" and tell you exactly where it found it.

    Warning: the wrong cell will kill you.
    So let grep tell you which one to enter.
EOF

# --- Research_Office .orders.txt ---
cat > "$LAB/Research_Office/.orders.txt" << 'EOF'
  ********************
  CONFIDENTIAL
  Attn: Chief of Security
  Date: July 22, 1998 2:13

  ALBERT,

  X Day is drawing upon us. Execute the following procedures within one
  week. Prompt actions are demanded.

  1. Lure S.T.A.R.S. to the estate, and obtain raw combat data against
     B.O.W.s

  2. Dispose of the Tyrant in the Cultivation_Room
     password: wolf

  3. Ensure complete disposal of the Arklay Laboratory including all
     personnel and test animals. Disguise their deaths as an accident.
     When the above procedures are executed, report to headquarters for
     further instructions.

  Good luck.

  Umbrella Headquarters,
  Umbrella Inc.
EOF

# =============================================================================
# GAME WORLD TEXT FILES
# =============================================================================

# --- raccoon_forest/Barry_Help.txt ---
cat > "$GAME_DIR/raccoon_forest/Barry_Help.txt" << 'EOF'
    use command 'ls' to list out what is inside the directory.

        ls
        #returns: Barry_Help.txt  courtyard  oswell_spencer_mansion

    oswell_spencer_mansion is a directory (shown in blue).
    courtyard is also a directory.

    use command 'cd' to change into a directory:
        cd ./oswell_spencer_mansion

    '.' means current directory
    './' together means "starting from where I am right now"

    Passwords are hidden somewhere in the game world. Read everything.
    Use  cat ./filename  to read files.

    Good luck.
EOF

# --- raccoon_forest/courtyard/Forest_Speyer.txt ---
cat > "$GAME_DIR/raccoon_forest/courtyard/Forest_Speyer.txt" << 'EOF'
  Forest Speyer. S.T.A.R.S. Bravo Team.

  Something with a wingspan did this.
  The jacket is shredded from above -- not from the front.
  He never saw it coming.

  He is still holding something in his left hand.

  NOTE: Use the  file  command to identify unknown files before opening them.
        file ./filename
        Not everything in here is safe to open.
EOF

# --- raccoon_forest/courtyard/.crow_remains --- (hidden, use file command)
cat > "$GAME_DIR/raccoon_forest/courtyard/.STARS_badge.txt" << 'EOF'
  S.T.A.R.S. ALPHA TEAM
  FIELD IDENTIFICATION BADGE

  This badge was carried by all S.T.A.R.S. members
  on active assignment in Raccoon Forest.

  If found, return to:
  Raccoon City Police Department

  ACCESS CODE: STARS
EOF

# --- doubledoors/.Kenneth_Sullivan.txt ---
cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/doubledoors/.Kenneth_Sullivan.txt" << 'EOF'
  There is something in his hand. A keycard.
  On the back, handwritten:

    GreenDoor access -- STARS field operatives only.

  Perhaps it could be used on the GreenDoor in the hallway.
EOF

# --- doubledoors/hallway/GreenDoor/Barry_Help.sh ---
# This is the mv target — player moves it to browndoor
cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/doubledoors/hallway/GreenDoor/Barry_Help.sh" << 'EOF'
source "$GAME_DIR/.Game_Files/Design/typewriter_regular.sh"
typewriter_regular ''
typewriter_regular '    Barry: Richard said the password was at the end of his notes.'
typewriter_regular '      Use the tail command to read the last few lines of a file:'
typewriter_regular ''
typewriter_regular '          tail -5 ./Richard_Aiken_Notes.txt'
typewriter_regular ''
typewriter_regular '    When you are ready to move on to the browndoor area,'
typewriter_regular '    bring this help file with you:'
typewriter_regular ''
typewriter_regular '        mv ./Barry_Help.sh ../browndoor/Barry_Help.sh'
typewriter_regular ''
typewriter_regular '    You will need it over there.'
typewriter_regular ''
EOF

# --- Richard_Aiken_Notes.txt (tail teaches) ---
cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/doubledoors/hallway/GreenDoor/Richard_Aiken_Notes.txt" << 'EOF'
  Field Notes -- Richard Aiken, S.T.A.R.S. Bravo Team
  Raccoon Forest Assignment, July 1998

  Day 1: Bravo helicopter went down in the forest. Rebecca and I
  were separated from the others. Made it to the mansion on foot.
  Something wrong with this place from the start.

  Day 2: Found Kenneth near the dining hall. He was gone by the time
  I reached him. Throat. Did not look like any animal attack I have
  ever seen.

  Day 3: Tried the green door in the hallway. The access code got us
  in. Took shelter here. Rebecca went to find medical supplies.

  Day 4: The snake came out of the upper floor. I made it out but
  barely. The venom is moving fast. Rebecca gave me what she had.

  I am writing this in case I do not make it to morning.
  If someone finds this: trust no one in this mansion.
  Wesker knew. He knew before we arrived.

  The browndoor in the mainhall connects to something.
  I found a vase near a statue. Hidden inside:
  the password is  serum
EOF

# --- mainhall/browndoor/ ---
cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/browndoor/Statue_with_Vase.txt" << 'EOF'
  A large stone statue stands in the corner.
  It is holding a vase.

  Is there something hidden inside?
  Remember what Barry said about ls...
EOF

cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/browndoor/.something_hidden_in_vase.txt" << 'EOF'
            Keeper's Diary

                May 12th, 1998.

            The space suit has me itching all over. I skipped feeding the
            dogs today out of spite. By the 13th, the doctor bandaged my
            swollen back. Then the company locked the grounds down.
            A researcher got shot trying to leave. They changed the
            bluedoor password, as if there was a way out through there.
            My skin started sloughing off in chunks when I scratched.

                May 19th --
            fever gone. Killed Scott, tasted fine.
            heard them change the blue door password to
            keeper
            Itchy. Tasty. Itchy. Reminds me of Scott.

            Itchy. Tasty. Itchy. Tasty.
            Itchy. Tasty. Itchy. Tasty.
EOF

# --- mainhall/bluedoor/ ---
cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/ResearchersWill.txt" << 'EOF'
            Yes, I am infected.
            I did everything I could to prevent
            this accident from reaching the public,
            but I can only delay the inevitable
            for so long. . .
            At least the hidden_ladder is buried.
            They will never find it.
EOF

cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/Newspaper_Clippings.txt" << 'EOF'
  Strange. . . .
  All of these newspaper articles are about S.T.A.R.S.
EOF

cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/Security_Protocols.txt" << 'EOF'
  SECURITY PROTOCOLS
  Spencer Mansion is on lockdown. Unauthorized persons attempting to leave
  will be shot on sight. All personnel with Clearance Level: ARKLAY must
  exit through the .hidden_ladder located in the Guardhouse courtyard
  and proceed directly to the Emergency_Helipad for evacuation.

  BASEMENT LEVEL

  Research_Office | For use by the Special Research Division only.

  Holding_Cells | At least one Consultant Researcher must be present
  if viral use is authorized.

  Cultivation_Room | Regarding the progress of Tyrant after the
  administration of T-Virus...
  (Illegible hereafter...)
EOF

# --- guardhouse bookcases ---
cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/courtyard/guardhouse/Bookcase_1.txt" << 'EOF'
  A heavy oak bookcase. Packed with identical Umbrella binders.
  No one has touched these in years.
  It is blocking the far wall.
EOF

cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/courtyard/guardhouse/Bookcase_2.txt" << 'EOF'
  Another bookcase. Same as the first.
  Same binders. Same dust.
  The hum is louder behind this one.
EOF

cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/courtyard/guardhouse/Bookcase_3.txt" << 'EOF'
  The last bookcase. Behind it, the hum is unmistakable.
  Mechanical. Deep. Something below the floor.
  Use  rm  to clear the way:
      rm ./Bookcase_1.txt ./Bookcase_2.txt ./Bookcase_3.txt
EOF

# --- mainhall/Help_Barry.txt ---
cat > "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/Help_Barry.txt" << 'EOF'
    use cd to change directory to doubledoors
    remember to start your command with ./
    the syntax: cd ./directory_name

    cd ./doubledoors
EOF

# =============================================================================
# PLAYER_GUIDE
# =============================================================================

cat > "$GAME_DIR/PLAYER_GUIDE" << 'EOF'
# Normal
# Player Guide
# A Resident Evil-themed Linux terminal adventure

# Before You Begin
This game is played entirely in your Linux terminal. You will navigate a
directory structure that mirrors the Spencer Mansion, read files to uncover
the story, and enter passwords to unlock new areas -- using real Linux commands.

Barry is not holding your hand this time.

Difficulty: Normal
Hint system: Limited
    Barry_Help files exist but you will have to find and move them yourself.

# Commands You Will Use

| Command                  | What It Does                                    |
|--------------------------|--------------------------------------------------|
| ls                       | List contents of the current directory           |
| ls -la                   | List all contents, including hidden files        |
| ls -Ra                   | List all contents recursively, inc. hidden       |
| cd ./name                | Change into a directory                          |
| cd ../                   | Go back to the parent directory                  |
| cat ./file.txt           | Read a file                                      |
| pwd                      | Print your current directory path                |
| man command              | Read the manual for any command                  |
| head -n ./file           | Show first n lines of a file                     |
| tail -n ./file           | Show last n lines of a file                      |
| grep 'word' ./file       | Search for a word inside a file                  |
| grep -r 'word' ./        | Search recursively through all files below here  |
| whoami                   | Print your current username                      |
| echo 'text'              | Print text to the terminal                       |
| mv ./file ./destination  | Move or rename a file                            |
| rm ./file                | Delete a file                                    |
| file ./filename          | Identify what type a file is                     |
| touch ./filename         | Create an empty file                             |

Hidden files start with a dot (.) and will not show up with plain ls.
Always try ls -la when you feel stuck -- something may be hidden.

# How Passwords Work
Some directories are locked. When prompted, type the password and press Enter.
Your input is hidden -- you will not see what you are typing.
This is intentional. The -s flag on read silences input for security.
If you enter an incorrect password, pay attention.
Some locks give you one more attempt. Others do not.
Passwords are always hidden somewhere in the game world. Read everything.

# Boss Fights
Two boss encounters exist in Normal difficulty.
Each presents three multiple choice questions about Linux commands.
One wrong answer ends the run. There is no second chance in a boss fight.
Unless Barry is with you. More on that below.

# Barry Burton
Barry is present at the start of the game.
After search_wesker plays, he and Jill separate.
You will find him again. Pay attention to the courtyard.
His role changes depending on how the snake encounter goes.

# The Snake
The first boss is Yawn, the giant snake, in the hallway browndoor.
You get two total failed attempts across the game before Barry intervenes.
If the snake defeats Jill twice, Barry will pull her back and the
recovery arc begins. After that, you can bring Barry into the snake room
with you by using mv to move his file there first.

# How to Play
1. Clone or pull the repo into your Linux environment
2. Move into the game directory:
       cd ~/RE-Linux/Normal
3. Start the game:
       source SourceMeToStart.sh

# Password Legend
| Password        | Found In                            | Unlocks                   |
|-----------------|--------------------------------------|---------------------------|
| spencer         | Context / story                      | oswell_spencer_mansion    |
| STARS           | .STARS_badge.txt in courtyard        | hallway/GreenDoor         |
| serum           | Richard_Aiken_Notes.txt (tail -5)    | mainhall/browndoor        |
| keeper          | .something_hidden_in_vase.txt        | mainhall/bluedoor         |
| arklay          | Security_Protocols.txt               | .hidden_ladder            |
| wolf            | .orders.txt in Research_Office       | Cultivation_Room          |
| rocket_launcher | Shown on weapon box                  | Fire weapon / endings     |

# Endings Summary
| Ending       | How to Get It                                              |
|--------------|------------------------------------------------------------|
| Bad Ending   | Go to Emergency_Helipad, enter password wrong twice        |
| Good Ending  | Go to Emergency_Helipad, enter password correctly          |
| Great Ending | Find Chris in Holding_Cells first, then Emergency_Helipad  |

Part of the Learning Linux Through Resident Evil series.
EOF

# =============================================================================
# DAY 2 COMPLETE
# =============================================================================

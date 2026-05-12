#!/bin/bash
# =============================================================================
# Normal_1.0.sh
# RE-Linux/Normal — Day 1: Foundation
# Directories, gamestate, typewriter functions, all locks, boss fights
#
# Run:   bash Normal_1.0.sh
# =============================================================================

GAME_DIR="$HOME/RE-Linux/Normal"

echo ""
echo "  Day 1 — Building foundation, locks, and boss fights..."
echo ""
GAME_DIR="$HOME/RE-Linux/Normal"

echo ""
echo "  Building RE-Linux/Normal..."
echo ""

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

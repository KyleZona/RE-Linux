#!/bin/bash

# Get the root directory of the game
GAME_DIR="$HOME/RE-Linux-Easy_Basics"

# Source the typewriter functions
source "$GAME_DIR/lib/typewriter_regular.sh"
source "$GAME_DIR/lib/typewriter_dramatic.sh"

# Reset game state to default
cp "$GAME_DIR/lib/gamestate_default" "$GAME_DIR/.gamestate"

# create fresh environment file
rm -f ~/.RE-Linux-Easy_Basics_env
echo "export GAME_DIR=\"$GAME_DIR\""> ~/.RE-Linux-Easy_Basics_env
cat >> ~/.RE-Linux-Easy_Basics_env << 'EOF'

function cd () {
	builtin cd "$@"
# spencer lock logic
	if [[ "$PWD" == */oswell_spencer_mansion ]]; then
		source "$GAME_DIR/.gamestate"
		if [ "$SPENCER_UNLOCKED" = "false" ]; then
			bash "$GAME_DIR/lib/spencer_lock.sh"
			lock_result=$?
			if [ $lock_result -ne 0 ]; then
				builtin cd "$GAME_DIR"
			else
				builtin cd "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall"
				source "$GAME_DIR/lib/enter_mainhall.sh"
			fi
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
		source "$GAME_DIR/lib/enter_doubledoors.sh"
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
			source "$GAME_DIR/lib/search_wesker.sh"
		fi
	fi
# browndoor logic
	if [[ "$PWD" == */browndoor ]]; then
		source "$GAME_DIR/.gamestate"
		if [ "$BROWNDOOR_UNLOCKED" = "false" ]; then
			bash "$GAME_DIR/lib/browndoor_lock.sh"
			lock_result=$?
			if [ $lock_result -ne 0 ]; then
				builtin cd "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall"
			else
				source "$GAME_DIR/lib/enter_browndoor.sh"
			fi
		fi
	fi
# bluedoor logic
	if [[ "$PWD" == */bluedoor ]]; then
		source "$GAME_DIR/.gamestate"
		if [ "$BLUEDOOR_UNLOCKED" = "false" ]; then
			bash "$GAME_DIR/lib/bluedoor_lock.sh"
			lock_result=$?
			if [ $lock_result -ne 0 ]; then
				builtin cd "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall"
			else
				source "$GAME_DIR/lib/enter_bluedoor.sh"
			fi
		fi
	fi
# private_elevator logic
	if [[ "$PWD" == */.private_elevator ]]; then
		source "$GAME_DIR/.gamestate"
		if [ "$PRIVATE_ELEVATOR_UNLOCKED" = "false" ]; then
			bash "$GAME_DIR/lib/private_elevator_lock.sh"
			lock_result=$?
			if [ $lock_result -ne 0 ]; then
				builtin cd "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor"
			else
				builtin cd "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/.private_elevator/Umbrella_Laboratory"
				source "$GAME_DIR/lib/enter_umbrella.sh"
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
			source "$GAME_DIR/lib/suspect_wesker.sh"
			sed -i 's/SUSPECT_WESKER_PLAYED=false/SUSPECT_WESKER_PLAYED=true/' "$GAME_DIR/.gamestate"
		fi
	fi
# Cultivation_Room logic
	if [[ "$PWD" == */Cultivation_Room ]]; then
		source "$GAME_DIR/.gamestate"
		if [ "$CULTIVATION_COMPLETE" = "false" ]; then
			bash "$GAME_DIR/lib/Cultivation_Room_Lock.sh"
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
		bash "$GAME_DIR/lib/self-destruct-sequence.sh"
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
			bash "$GAME_DIR/lib/Emergency_Helipad_lock.sh"
		fi
	fi
# Cell logic
	if [[ "$PWD" == */Holding_Cells/Cell_* ]]; then
		bash "$PWD/"*.sh
	fi
}
EOF

# add to .bashrc if not already there
grep -qxF 'source ~/.RE-Linux-Easy_Basics_env' ~/.bashrc || echo 'source ~/.RE-Linux-Easy_Basics_env' >> ~/.bashrc

# unset cd function to avoid triggering lock on relaunch
unset -f cd 2>/dev/null

# Move player into raccoon_forest and begin
cd "$GAME_DIR/raccoon_forest"

# force ~/.RE-Linux-Easy_Basics_env is active after relaunch
source ~/.RE-Linux-Easy_Basics_env

# Fire the opening script
bash "$GAME_DIR/lib/opening.sh"

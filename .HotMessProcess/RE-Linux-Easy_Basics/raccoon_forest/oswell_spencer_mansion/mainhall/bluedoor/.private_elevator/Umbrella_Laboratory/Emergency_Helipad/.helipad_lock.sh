source "$GAME_DIR/.gamestate"

if [ "$CHRIS_RESCUED" = "true" ]; then
    bash "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/private_elevator/Umbrella_Laboratory/Emergency_Helipad/.ThreeSurvivors.sh"
else
    bash "$GAME_DIR/raccoon_forest/oswell_spencer_mansion/mainhall/bluedoor/private_elevator/Umbrella_Laboratory/Emergency_Helipad/.TwoSurvivors.sh"
fi

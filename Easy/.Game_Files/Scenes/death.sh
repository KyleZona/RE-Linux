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

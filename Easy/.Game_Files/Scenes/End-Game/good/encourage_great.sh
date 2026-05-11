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

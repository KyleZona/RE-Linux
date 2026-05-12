source "$GAME_DIR/lib/typewriter_regular.sh"

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
echo "  cd ./name                  Change into a directory"
echo "  cd ../                     Go back to the previous directory"
echo "  cat ./file.txt             Read a file"
echo "  pwd                        Print your current directory path"
echo "  man command                Read the manual for any command"
echo "  grep -r \"term\" .           Search all files recursively for a term"
echo ""

#exit game and reset files
function cd () { builtin cd "$@"; }
rm -f ~/.RE-Linux-Easy_Basics_env
cp "$GAME_DIR/lib/gamestate_default" "$GAME_DIR/.gamestate"
sed -i '/RE-Linux-Easy_Basics_env/d' ~/.bashrc
echo "  Press Enter to exit . . ."
read _
cd "$GAME_DIR"
return 1

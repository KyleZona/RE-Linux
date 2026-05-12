source "$GAME_DIR/lib/typewriter_regular.sh"

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

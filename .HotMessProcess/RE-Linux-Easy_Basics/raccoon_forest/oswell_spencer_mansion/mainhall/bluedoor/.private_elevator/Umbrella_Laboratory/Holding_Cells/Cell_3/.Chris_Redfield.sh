#!/bin/bash

GAME_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$GAME_DIR/lib/typewriter-regular.sh"

typewriter ""
typewriter "        Chris: Oh Jill! Barry!"
typewriter "        Jill: Oh Chris! So you're okay!"
typewriter "        Chris: Yeah! You too! What happened to Wesker?"
typewriter ""
typewriter "    [Overhead: THE SELF-DESTRUCT SYSTEM HAS BEEN ACTIVATED.]"
typewriter "    [Overhead: ALL PERSONNEL MUST EVACUATE IMMEDIATELY.]"
typewriter ""
typewriter "        Jill: Let's talk about it later."
typewriter "        Barry: Let's get out of here!"
typewriter ""

# Chris_Redfield.sh writes chris_rescued=true to .gamestate

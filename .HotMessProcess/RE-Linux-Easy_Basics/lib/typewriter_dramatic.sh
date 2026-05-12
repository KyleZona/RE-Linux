#!/bin/bash

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

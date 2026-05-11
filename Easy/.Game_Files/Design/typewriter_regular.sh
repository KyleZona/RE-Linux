typewriter_regular() {
    local text="$1"
    local delay="${2:-0.05}"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo
}

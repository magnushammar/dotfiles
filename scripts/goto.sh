#!/bin/bash

goto() {
    local search_term="$1"
    local matches=($(find ~/data ~/projects -type d -iname "*$search_term*" 2>/dev/null | head -n 10))
    local num_matches=${#matches[@]}

    if [ $num_matches -eq 0 ]; then
        echo "No matching directories found."
        return 1
    elif [ $num_matches -eq 1 ]; then
        cd "${matches[0]}"
        echo "Changed to directory: ${matches[0]}"
        return 0
    fi

    echo "Multiple matches found. Use arrow keys to select, Enter to confirm:"
    local selected=0
    local key=""

    tput civis  # Hide cursor

    while true; do
        # Clear previous output
        for ((i=0; i<$num_matches; i++)); do
            tput cuu1
            tput el
        done

        # Display options
        for ((i=0; i<$num_matches; i++)); do
            if [ $i -eq $selected ]; then
                echo "> ${matches[$i]}"
            else
                echo "  ${matches[$i]}"
            fi
        done

        # Read a single character
        read -s -n 1 key

        case "$key" in
            A)  # Up arrow
                ((selected--))
                [ $selected -lt 0 ] && selected=$((num_matches - 1))
                ;;
            B)  # Down arrow
                ((selected++))
                [ $selected -eq $num_matches ] && selected=0
                ;;
            "")  # Enter key
                cd "${matches[$selected]}"
                echo
                echo "Changed to directory: ${matches[$selected]}"
                break
                ;;
            q)  # Quit
                echo
                echo "Operation cancelled."
                break
                ;;
        esac
    done

    tput cnorm  # Show cursor
}
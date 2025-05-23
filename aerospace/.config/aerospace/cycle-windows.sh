#!/usr/bin/env bash

# Get direction from argument (default to "next")
direction="${1:-next}"

# Get the currently focused window ID
current_window=$(aerospace list-windows --focused --format "%{window-id}")

# Get all window IDs in the current workspace
readarray -t windows < <(aerospace list-windows --workspace focused --format "%{window-id}")

# Only proceed if there's more than one window
if [ ${#windows[@]} -gt 1 ]; then
    # Find the current window index
    for i in "${!windows[@]}"; do
        if [ "${windows[$i]}" = "$current_window" ]; then
            # Calculate index based on direction
            if [ "$direction" = "prev" ]; then
                next_index=$(( (i - 1 + ${#windows[@]}) % ${#windows[@]} ))
            else
                next_index=$(( (i + 1) % ${#windows[@]} ))
            fi
            next_window="${windows[$next_index]}"

            # Focus the next window
            aerospace focus --window-id "$next_window"
            break
        fi
    done
fi

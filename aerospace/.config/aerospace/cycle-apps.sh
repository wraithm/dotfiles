#!/usr/bin/env bash

# Get direction from argument (default to "next")
direction="${1:-next}"

# Get current window's app bundle ID
current_app=$(aerospace list-windows --focused --format "%{app-bundle-id}")

# Get all unique app bundle IDs in the current workspace, maintaining order
readarray -t apps < <(aerospace list-windows --workspace focused --format "%{app-bundle-id}|%{window-id}" | awk -F'|' '!seen[$1]++ {print $1}')

# Only proceed if there's more than one app
if [ ${#apps[@]} -gt 1 ]; then
    # Find the current app index and calculate the next one
    for i in "${!apps[@]}"; do
        if [ "${apps[$i]}" = "$current_app" ]; then
            # Calculate index based on direction
            if [ "$direction" = "prev" ]; then
                next_index=$(((i - 1 + ${#apps[@]}) % ${#apps[@]}))
            else
                next_index=$(((i + 1) % ${#apps[@]}))
            fi
            next_app="${apps[$next_index]}"

            # Get the first window of the next app and focus it
            first_window=$(aerospace list-windows --workspace focused --app-bundle-id "$next_app" --format "%{window-id}" | head -n1)
            aerospace focus --window-id "$first_window"
            break
        fi
    done
fi

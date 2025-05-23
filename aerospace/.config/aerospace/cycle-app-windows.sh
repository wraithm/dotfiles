#!/usr/bin/env bash

# Get current window's app bundle ID and window ID in one call
current_info=$(aerospace list-windows --focused --format "%{app-bundle-id}|%{window-id}")
IFS='|' read -r current_app current_window <<<"$current_info"

# Get all window IDs of the current app in the current workspace
readarray -t windows < <(aerospace list-windows --workspace focused --app-bundle-id "$current_app" --format "%{window-id}" | sort -n)

# Only proceed if there's more than one window
if [ ${#windows[@]} -gt 1 ]; then
    # Find the current window index and calculate the next one
    for i in "${!windows[@]}"; do
        if [ "${windows[$i]}" = "$current_window" ]; then
            # Get next index, wrapping around if needed
            next_index=$(((i + 1) % ${#windows[@]}))
            next_window="${windows[$next_index]}"

            # Focus the next window
            aerospace focus --window-id "$next_window"
            break
        fi
    done
fi

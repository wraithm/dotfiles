#!/usr/bin/env bash

# Get the target workspace from the first argument
TARGET_WORKSPACE="$1"

if [ -z "$TARGET_WORKSPACE" ]; then
    echo "Usage: $0 <target-workspace>"
    exit 1
fi

# Get all window IDs in the focused workspace into an array
readarray -t windows < <(aerospace list-windows --workspace focused --format "%{window-id}")

# Move each window to the target workspace
for window_id in "${windows[@]}"; do
    if [ -n "$window_id" ]; then
        aerospace move-node-to-workspace --window-id "$window_id" "$TARGET_WORKSPACE"
    fi
done

# Navigate to the target workspace
aerospace workspace "$TARGET_WORKSPACE"

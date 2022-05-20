#!/usr/bin/env python3

# Cycle focus between outputs (aka monitors)

import sys
import json
import subprocess

# Get the outputs
swaymsg = subprocess.run(['swaymsg', '-t', 'get_outputs'], stdout=subprocess.PIPE)
outputs = json.loads(swaymsg.stdout)

# Find active outputs
active_outputs = [output for output in outputs if output['active']]

# Find the focused output
focused_output = next((output for output in active_outputs if output['focused']), None)

# If no focused monitor, quit
if focused_output == None:
    sys.exit(1)

# Find the next output in the enabled list
focused_output_idx = active_outputs.index(focused_output)
next_output_idx = (focused_output_idx + 1) % len(active_outputs)
next_output_name = active_outputs[next_output_idx]['name']

# Switch focus to it
sway = subprocess.run(['swaymsg', 'focus', 'output', next_output_name])
sys.exit(sway.returncode)

#!/usr/bin/env python3

# Cycle focus between outputs (aka monitors)

import sys
import json
import subprocess

# Get the outputs
i3outputs = subprocess.run(['i3-msg', '-t', 'get_outputs'], stdout=subprocess.PIPE)
outputs = json.loads(i3outputs.stdout)

# Get the workspaces
i3workspaces = subprocess.run(['i3-msg', '-t', 'get_workspaces'], stdout=subprocess.PIPE)
workspaces = json.loads(i3workspaces.stdout)

# Find active outputs
active_outputs = [output for output in outputs if output['active']]

# Find the focused workspace
focused_workspace = next((workspace for workspace in workspaces if workspace['focused']), None)

# If no focused monitor, quit
if focused_workspace == None:
    sys.exit(1)

# Find the focused output from workspace
focused_output = focused_workspace["output"]

# # Find the next output in the enabled list
output_names = list(map(lambda output: output["name"], active_outputs))
focused_output_idx = output_names.index(focused_output)
next_output_idx = (focused_output_idx + 1) % len(output_names)
next_output_name = output_names[next_output_idx]

# # Switch focus to it
focusoutput = subprocess.run(['i3-msg', 'focus', 'output', next_output_name])
sys.exit(focusoutput.returncode)

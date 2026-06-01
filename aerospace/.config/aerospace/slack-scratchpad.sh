#!/usr/bin/env bash

# Toggle Slack like i3's scratchpad, with deterministic "main monitor" targeting.
# Usage in aerospace.toml:
#   alt-minus = 'exec-and-forget ~/.config/aerospace/slack-scratchpad.sh'

set -euo pipefail

APP_ID="com.tinyspeck.slackmacgap"
APP_NAME="Slack"
SCRATCH_WS="S"

# Preference order for the "main monitor"
PREFERRED_MONITORS=("Studio Display" "27GL850" "Built-in Retina Display")

focused_monitor_id() {
    aerospace list-monitors --focused | cut -d'|' -f1 | tr -d '[:space:]'
}

monitor_id_by_name() {
    local name="$1"
    aerospace list-monitors |
        awk -F ' \\| ' -v target="$name" '$2==target {gsub(/^[ \t]+|[ \t]+$/,"",$1); print $1; exit}'
}

# TODO update to use `list-monitors --format '%{monitor-is-main}'`
# https://github.com/nikitabobko/AeroSpace/issues/1656
pick_main_monitor_id() {
    local id
    for m in "${PREFERRED_MONITORS[@]}"; do
        id="$(monitor_id_by_name "$m" || true)"
        [[ -n "${id:-}" ]] && {
            echo "$id"
            return
        }
    done
    # Fallback: current focused monitor
    focused_monitor_id
}

slack_is_running() {
    aerospace list-windows --all --format "%{app-bundle-id}" | grep -qx "$APP_ID"
}

# Is this title a "chat" window (not a Huddle/Call)?
is_chat_title() {
    # Reject common non-chat types first
    local t="$1"
    if [[ "$t" =~ ^Huddle: ]] || [[ "$t" =~ Huddle ]] || [[ "$t" =~ Call ]]; then
        return 1 # not chat
    fi
    return 0 # chat
}

# Prefer a *visible* Slack chat window; then any chat window; then any Slack window.
get_slack_window_id() {
    aerospace list-windows --monitor all \
        --app-bundle-id "$APP_ID" \
        --format "%{window-id}%{right-padding} | %{window-title}%{right-padding} | %{workspace-is-visible}" |
        awk -F ' \\| ' '
      function trim(s){ gsub(/^[ \t]+|[ \t]+$/,"",s); return s }
      {
        id    = trim($1);
        title = trim($2);
        vis   = tolower(trim($3));  # "true"/"false" in most builds (treat "yes"/"no" too)

        if (first_any == "") first_any = id;

        # Skip huddles/calls completely
        if (title ~ /^Huddle:/ || title ~ /Huddle/ || title ~ /Call/) next;

        if (first_chat == "") first_chat = id;

        if ((vis == "true" || vis == "yes") && first_visible_chat == "") {
          first_visible_chat = id;
        }
      }
      END {
        if (first_visible_chat != "") { print first_visible_chat; exit }
        if (first_chat         != "") { print first_chat;         exit }
        if (first_any          != "") { print first_any;          exit }
      }
    '
}

# Is the currently focused window the Slack *chat* window?
focused_is_main_slack() {
    # Note: this inspects *both* bundle id and title.
    local focused_bid focused_title
    focused_bid="$(aerospace list-windows --focused --format "%{app-bundle-id}" 2>/dev/null || true)"
    [[ "$focused_bid" != "$APP_ID" ]] && return 1 # different app

    focused_title="$(aerospace list-windows --focused --format "%{window-title}" 2>/dev/null || true)"
    if is_chat_title "$focused_title"; then
        return 0 # yes, main chat is focused
    else
        return 1 # Slack focused, but not the chat window (e.g., Huddle)
    fi
}

wait_for_slack_window() {
    # wait up to ~5s for a Slack window to appear
    local id=""
    for _ in {1..50}; do
        id="$(get_slack_window_id || true)"
        [[ -n "${id:-}" ]] && {
            echo "$id"
            return 0
        }
        sleep 0.1
    done
    return 1
}

send_to_scratchpad() {
    local win_id="$1"
    # Move away without following focus.
    aerospace move-node-to-workspace "$SCRATCH_WS" --window-id "$win_id"
}

bring_to_main_and_focus() {
    local win_id="$1"
    local main_id
    main_id="$(pick_main_monitor_id)"
    if [[ -z "${main_id:-}" ]]; then
        # very unlikely, but keep behavior sane
        aerospace focus --window-id "$win_id"
        return
    fi
    # Put Slack on the active workspace of the main monitor and focus it.
    aerospace move-node-to-monitor "$main_id" --window-id "$win_id" --focus-follows-window
    aerospace focus --window-id "$win_id"
}

focused_workspace_name() {
    aerospace list-workspaces --focused
}

main() {
    # If Slack isn't running, launch and place it on main monitor.
    if ! slack_is_running; then
        open -b "$APP_ID" || open -a "$APP_NAME"
        if slack_id="$(wait_for_slack_window)"; then
            bring_to_main_and_focus "$slack_id"
        fi
        exit 0
    fi

    # Slack is running: get a window id (could be in scratchpad or side monitor).
    slack_id="$(get_slack_window_id || true)"
    [[ -z "${slack_id:-}" ]] && exit 0

    # Focus rule:
    # - If Slack is currently focused and not on S workspace: hide it to S.
    # - If Slack is currently focused and on S: workspace-back-and-forth
    # - Otherwise: bring to main monitor and focus it.
    if focused_is_main_slack; then
        # Slack's *chat* window is focused → hide it
        slack_ws="$(aerospace list-windows --all \
                        --format "%{window-id}%{right-padding} | %{workspace}" \
                  | awk -F ' \\| ' -v wid="$slack_id" '$1==wid {gsub(/^[ \t]+|[ \t]+$/,"",$2); print $2; exit}')"

        if [[ "$slack_ws" == "$SCRATCH_WS" ]]; then
            # Already in S → hiding would do nothing, so just leave S
            aerospace workspace-back-and-forth
        else
            send_to_scratchpad "$slack_id"
        fi
    else
        # Not focused on main Slack (maybe Huddle, maybe behind, maybe other app)
        # If we're sitting in S by accident, hop away first
        if [[ "$(focused_workspace_name)" == "$SCRATCH_WS" ]]; then
            aerospace workspace-back-and-forth
        fi

        bring_to_main_and_focus "$slack_id"
    fi
}
main

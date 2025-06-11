#!/bin/bash

# Script to open a display settings application
# Tries to launch nwg-displays, then wdisplays.
# Notifies if neither is found.

# Preferred GUI tools (add more if you like, in order of preference)
PREFERRED_TOOLS=("nwg-displays" "wdisplays")

TOOL_FOUND=false

for tool_cmd in "${PREFERRED_TOOLS[@]}"; do
    if command -v "$tool_cmd" &> /dev/null; then
        # Launch the tool in the background so it doesn't block Waybar
        "$tool_cmd" &
        TOOL_FOUND=true
        break # Exit loop once a tool is found and launched
    fi
done

if [ "$TOOL_FOUND" = false ]; then
    # Ensure you have a notification daemon running (e.g., dunst, mako)
    # and libnotify installed for notify-send to work.
    if command -v notify-send &> /dev/null; then
        notify-send -u critical "Display Settings Tool Not Found" \
        "Please install 'nwg-displays' or 'wdisplays' (or another tool listed in manage_displays.sh) to configure your displays."
    else
        # Fallback if notify-send is not available (e.g., print to stderr, which Waybar might log)
        echo "Error: Display settings tool not found. Install nwg-displays or wdisplays." >&2
        # You could also try to open a terminal with a message or a CLI tool here
        # For example, if you have a terminal like kitty:
        # kitty sh -c "echo 'Display tool not found. Install nwg-displays or wdisplays. Press Enter to close.'; read" &
    fi
    exit 1
fi

exit 0

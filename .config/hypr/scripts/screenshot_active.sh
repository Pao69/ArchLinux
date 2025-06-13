#!/bin/bash

# Screenshot directory
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Generate filename with timestamp
FILENAME="$SCREENSHOT_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

    # Get active window geometry
    GEOMETRY=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')

if [ -z "$GEOMETRY" ] || [ "$GEOMETRY" = "0,0 0x0" ]; then
    notify-send -u critical "Screenshot Failed" "No active window found"
        exit 1
    fi

# Take the screenshot
if grim -g "$GEOMETRY" "$FILENAME"; then
    # Copy to clipboard
    wl-copy < "$FILENAME"
    
    # Send notification
    notify-send "Screenshot Captured" "Saved as $(basename "$FILENAME")\nCopied to clipboard" -i "$FILENAME"
else
    notify-send -u critical "Screenshot Failed" "Could not capture active window"
fi

exit 0

#!/bin/bash

# Screenshot directory
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

# Create the screenshot directory if it doesn't exist
mkdir -p "$SCREENSHOT_DIR"

# Generate filename with timestamp
FILENAME="$SCREENSHOT_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

case "$1" in
    "full")
        # Full screen screenshot
        grim "$FILENAME"
        ;;
    "area")
        # Area selection screenshot
        grim -g "$(slurp)" "$FILENAME"
        ;;
    "window")
        # Active window screenshot
        ACTIVE_WINDOW=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        grim -g "$ACTIVE_WINDOW" "$FILENAME"
        ;;
    *)
        echo "Usage: $0 [full|area|window]"
        exit 1
        ;;
esac

# Copy to clipboard
wl-copy < "$FILENAME"

# Send notification
notify-send "Screenshot" "Saved as $(basename "$FILENAME")\nCopied to clipboard" -i "$FILENAME" 
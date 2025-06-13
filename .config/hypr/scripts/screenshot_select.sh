#!/bin/bash

# Screenshot directory
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Generate filename with timestamp
FILENAME="$SCREENSHOT_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

# Take the screenshot with area selection
if grim -g "$(slurp)" "$FILENAME"; then
    # Copy to clipboard
    wl-copy < "$FILENAME"
    
    # Send notification
    notify-send "Screenshot Captured" "Saved as $(basename "$FILENAME")\nCopied to clipboard" -i "$FILENAME"
else
    notify-send -u critical "Screenshot Failed" "Selection cancelled or could not capture screenshot"
fi

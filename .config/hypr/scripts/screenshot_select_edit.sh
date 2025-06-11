#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
# We'll save the initial capture to a temporary file for swappy
TEMP_FILENAME="/tmp/swappy_$(date +%s).png"

# Use slurp to select a region -- MINIMAL OPTIONS
GEOMETRY=$(slurp -d) # <<< MODIFIED THIS LINE

if [ -z "$GEOMETRY" ]; then
    notify-send -u low "Screenshot" "Selection cancelled."
    exit 1
fi

# This sleep is still important for the quality of the image grim captures AFTER selection
sleep 0.5 # Or whatever value worked best for you previously

grim -g "$GEOMETRY" "$TEMP_FILENAME"

if [ -f "$TEMP_FILENAME" ]; then
    # Open with swappy. Swappy handles saving to desired location & copying.
    swappy -f "$TEMP_FILENAME"
    # You can choose to notify here or rely on swappy's implicit actions
    # notify-send "Screenshot" "Opened selection in Swappy."
else
    notify-send -u critical "Screenshot Failed" "Could not capture selection for Swappy."
    exit 1
fi

# Optional: remove the temp file after swappy is done if you want
# rm "$TEMP_FILENAME"

exit 0

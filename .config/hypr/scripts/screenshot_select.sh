#!/bin/bash

# Directory to save screenshots
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR" # Create directory if it doesn't exist

# Generate filename with timestamp
FILENAME="$SCREENSHOT_DIR/$(date +'%Y-%m-%d_%Hh%Mm%Ss_select.png')"

 Use slurp to select a region -- MINIMAL OPTIONS
GEOMETRY=$(slurp -d) # <<< MODIFIED THIS LINE

# If slurp was cancelled (e.g., Esc key), GEOMETRY will be empty
if [ -z "$GEOMETRY" ]; then

    notify-send -u low "Screenshot" "Selection cancelled."
    exit 1
fi

# --- CRITICAL PART ---
# Give a delay for slurp's overlay to disappear and screen to settle.
# Start with a slightly larger value and decrease if it works.
sleep 0.5 # Try 0.5 seconds first. If still blank, try 0.7 or even 1.0.
          # If 0.5 works, you can try to reduce it to 0.4, 0.3 to find the minimum.

# Take the screenshot of the selected geometry
grim -g "$GEOMETRY" "$FILENAME"

# Check if grim was successful
if [ -f "$FILENAME" ]; then
    # Copy the image to clipboard
    wl-copy < "$FILENAME"
    notify-send "Screenshot Captured" "Selected area saved to\n$FILENAME\nand copied to clipboard."
else
    notify-send -u critical "Screenshot Failed" "Could not capture selected area."
    exit 1
fi

exit 0

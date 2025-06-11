#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
FILENAME="$SCREENSHOT_DIR/$(date +'%Y-%m-%d_%Hh%Mm%Ss_fullscreen.png')"

# Take screenshot of the entire output (all screens)
grim "$FILENAME"

if [ -f "$FILENAME" ]; then
    wl-copy < "$FILENAME"
    notify-send "Screenshot Captured" "Fullscreen saved to\n$FILENAME\nand copied to clipboard."
else
    notify-send -u critical "Screenshot Failed" "Could not capture fullscreen."
    exit 1
fi

exit 0

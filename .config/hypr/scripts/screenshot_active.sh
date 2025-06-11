#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
FILENAME="$SCREENSHOT_DIR/$(date +'%Y-%m-%d_%Hh%Mm%Ss_active.png')"


    # Get active window geometry
    GEOMETRY=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')

    if [ -z "$GEOMETRY" ]; then
        notify-send -u critical "Screenshot Error" "Could not get active window geometry."
        exit 1
    fi

    # Give a tiny delay
    sleep 0.5 # <--- ADJUST THIS AS WELL

    grim -g "$GEOMETRY" "$FILENAME"

if [ -f "$FILENAME" ]; then
    wl-copy < "$FILENAME"
    notify-send "Screenshot Captured" "Active window saved to\n$FILENAME\nand copied to clipboard."
else
    notify-send -u critical "Screenshot Failed" "Could not capture active window."
    exit 1
fi

exit 0

#!/bin/bash

# Script to set wallpaper with hyprpaper and update pywal theme

# 1. Select a wallpaper using Nautilus (or your preferred file manager)
# We use zenity for a graphical file selection dialog. Install it if you don't have it.
# sudo pacman -S zenity
SELECTED_WALLPAPER=$(zenity --file-selection --title="Select Your Wallpaper")

# Exit if no file was selected (zenity returns non-zero on cancel)
if [ $? -ne 0 ] || [ -z "$SELECTED_WALLPAPER" ]; then
    echo "No wallpaper selected. Exiting."
    exit 1
fi

# Check if the selected file exists
if [ ! -f "$SELECTED_WALLPAPER" ]; then
    echo "Error: File '$SELECTED_WALLPAPER' not found."
    notify-send "Wallpaper Error" "File '$SELECTED_WALLPAPER' not found."
    exit 1
fi

echo "Setting wallpaper to: $SELECTED_WALLPAPER"

# 2. Set the wallpaper using hyprpaperctl (for all monitors)
# This changes the live wallpaper.
hyprpaperctl wallpaper ",$SELECTED_WALLPAPER"

# 3. Update hyprpaper.conf for persistence
# This ensures hyprpaper loads this wallpaper on next startup.
# This is a bit basic; a more robust script might use sed or awk to replace
# only the specific wallpaper line if other settings exist.
# For simplicity, this replaces the whole file, assuming a simple config.
# Make sure your hyprpaper.conf typically only contains preload and wallpaper lines.
# IMPORTANT: Backup your hyprpaper.conf before running this extensively if it's complex.
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"
echo "preload = $SELECTED_WALLPAPER" > "$HYPRPAPER_CONF"
echo "wallpaper = ,$SELECTED_WALLPAPER" >> "$HYPRPAPER_CONF"
echo "ipc = on" >> "$HYPRPAPER_CONF" # Ensure IPC is on

# 4. Update pywal theme based on the new wallpaper
# The -n flag prevents wal from trying to set the wallpaper itself.
# The -q flag makes it quiet (less output).
wal -i "$SELECTED_WALLPAPER" -n -q [2]

# 5. Reload Kitty's colors
# This command tells all running Kitty instances to reload colors from the pywal generated file.
if type kitty > /dev/null 2>&1; then # Check if kitty command exists
    if [ -f "$HOME/.cache/wal/colors-kitty.conf" ]; then
        echo "Reloading Kitty colors..."
        kitty @ set-colors --all --configured "$HOME/.cache/wal/colors-kitty.conf" &
    else
        echo "Pywal Kitty color file not found, skipping Kitty reload."
    fi
else
    echo "Kitty command not found, skipping Kitty reload."
fi

echo "Wallpaper and theme updated."
notify-send "Theme Updated" "Wallpaper set to $(basename "$SELECTED_WALLPAPER") and theme updated. Kitty reloaded." [2]
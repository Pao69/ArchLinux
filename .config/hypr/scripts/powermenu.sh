#!/bin/bash

# Options for the power menu
# You can use Nerd Font icons if your wofi and font support them
# e.g., " Power Off", " Restart", " Hibernate", " Logout", " Lock Screen"
options="Power Off\nRestart\nHibernate\nLogout\nLock Screen"

# Show the menu using wofi
# -dmenu: Run in dmenu mode (reads from stdin, prints selection to stdout)
# -p "Power Menu:": Set the prompt text
selected=$(echo -e "$options" | wofi --dmenu -p "Power Menu:")

# Perform action based on user's choice
case "$selected" in
    "Power Off")
        systemctl poweroff
        ;;
    "Restart")
        systemctl reboot
        ;;
    "Hibernate")
        # Ensure hibernate is configured on your system first!
        systemctl hibernate
        ;;
    "Logout")
        hyprctl dispatch exit # Exits Hyprland session
        ;;
    "Lock Screen")
        # Prioritize hyprlock, then try swaylock, then notify if none found
        if command -v hyprlock &> /dev/null; then
            hyprlock
        elif command -v swaylock &> /dev/null; then
            swaylock -f -c 000000 # Example: swaylock with black background
        else
            notify-send "Screen Locker" "No screen locker found."
        fi
        ;;
    *)
        # If ESC is pressed or no selection, do nothing
        exit 0
        ;;
esac

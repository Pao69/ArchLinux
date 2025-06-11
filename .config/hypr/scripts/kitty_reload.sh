#!/bin/bash

# Script to automatically reload Kitty's theme after Pywal updates.

# Define the path to the Kitty socket
# Ensure this matches the 'listen_on' directive in your kitty.conf
KITTY_SOCKET_PATH="unix:/tmp/kitty.sock"
PYWAL_KITTY_COLORS_PATH="$HOME/.cache/wal/colors-kitty.conf"

# Check if the Pywal Kitty color file exists
if [ ! -f "$PYWAL_KITTY_COLORS_PATH" ]; then
    echo "Pywal Kitty color file not found at $PYWAL_KITTY_COLORS_PATH. Skipping Kitty reload."
    exit 0
fi

# Check if any Kitty instance is listening on the socket
# The 'kitty @ ls' command with a timeout is a good way to check.
if kitty @ --to "$KITTY_SOCKET_PATH" ls > /dev/null 2>&1; then
    echo "Attempting to reload Kitty theme via socket: $KITTY_SOCKET_PATH"
    # Tell all kitty OS windows to reload the colors from the pywal generated file
    kitty @ --to "$KITTY_SOCKET_PATH" set-colors --all --configured "$PYWAL_KITTY_COLORS_PATH"
    echo "Kitty theme reloaded using set-colors."
else
    echo "No Kitty instance found listening on socket $KITTY_SOCKET_PATH."
    echo "You might need to start Kitty or ensure 'allow_remote_control' and 'listen_on' are set correctly in kitty.conf."
    # As a fallback, you could try SIGUSR1, but set-colors is generally better for themes.
    # if pgrep -x kitty > /dev/null; then
    #    pkill -USR1 kitty
    #    echo "Sent SIGUSR1 to running Kitty instances as a fallback."
    # fi
fi

exit 0
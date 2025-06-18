#!/bin/bash

# Get colors from pywal
source "$HOME/.cache/wal/colors.sh"

# Convert hex to rgb function
hex_to_rgb() {
    hex=$1
    hex="${hex#\#}"
    printf "%d, %d, %d" \
        $((16#${hex:0:2})) \
        $((16#${hex:2:2})) \
        $((16#${hex:4:2}))
}

# Get RGB values
background_rgb=$(hex_to_rgb "$background")
color4_rgb=$(hex_to_rgb "$color4")

# Update Waybar style
sed -e "s/BACKGROUND_RGB/$background_rgb/g" \
    -e "s/COLOR4_RGB/$color4_rgb/g" \
    -e "s/BACKGROUND/$background/g" \
    -e "s/FOREGROUND/$foreground/g" \
    -e "s/COLOR1/$color1/g" \
    -e "s/COLOR2/$color2/g" \
    -e "s/COLOR3/$color3/g" \
    -e "s/COLOR4/$color4/g" \
    -e "s/COLOR5/$color5/g" \
    -e "s/COLOR6/$color6/g" \
    -e "s/COLOR7/$color7/g" \
    -e "s/COLOR8/$color8/g" \
    "$HOME/.config/waybar/style.css.template" > "$HOME/.config/waybar/style.css"

# Update Wofi style
sed -e "s/BACKGROUND_RGB/$background_rgb/g" \
    -e "s/COLOR4_RGB/$color4_rgb/g" \
    -e "s/BACKGROUND/$background/g" \
    -e "s/FOREGROUND/$foreground/g" \
    -e "s/COLOR1/$color1/g" \
    -e "s/COLOR2/$color2/g" \
    -e "s/COLOR3/$color3/g" \
    -e "s/COLOR4/$color4/g" \
    -e "s/COLOR5/$color5/g" \
    -e "s/COLOR6/$color6/g" \
    -e "s/COLOR7/$color7/g" \
    -e "s/COLOR8/$color8/g" \
    "$HOME/.config/wofi/style.css.template" > "$HOME/.config/wofi/style.css"

# Restart Waybar
killall waybar
waybar > /dev/null 2>&1 & 
#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type  mode
# name  swww_single.sh
# desc  changes the background depending on the desktop_mode
# vars  bg_dark, bg_light

if ! command -v swww &> /dev/null; then
    echo "swww is not installed. Please install it and try again."
    exit 1
fi

reve_folder="$HOME/.config/reve"
reve_desktop_mode="$reve_folder/desktop_mode"
bg_dark="$reve_folder/chore/bg_dark"
bg_light="$reve_folder/chore/bg_light"

util_readf () {
    local filename=$1

    if [[ -f "$filename" ]]; then
        cat "$filename"
    else
        echo "util_readf: File not found: $filename" >&2
        return 1
    fi
}

current_mode=$( util_readf "$reve_desktop_mode" )
types=("left" "right" "top" "bottom" "wipe" "wave" "grow" "outer")
ltypes=${#types[@]}
rindex=$((RANDOM % ltypes))
rtype=${types[rindex]}

if [[ $current_mode == "dark" ]]; then
    swww img --transition-type "$rtype" --transition-pos 1,1 --transition-step 90 "$bg_dark"
    notify-send --urgency=low --expire-time=1450 --icon="$bg_dark" --app-name="reve: swww_single" "Wallpaper changed" "Wallpaper changed and saved on dark mode."
else
    swww img --transition-type "$rtype" --transition-pos 1,1 --transition-step 90 "$bg_light"
    notify-send --urgency=low --expire-time=1450 --icon="$bg_light" --app-name="reve: swww_single" "Wallpaper changed" "Wallpaper changed and saved on light mode."
fi

#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type  mode
# name  kitty_theme.sh
# desc  changes kitty's theme depending on desktop_mode
# vars  kitty_dark_theme, kitty_light_theme

if ! command -v kitty &> /dev/null; then
    echo "kitty is not installed. Please install it and try again."
    exit 1
fi

reve_folder="$HOME/.config/reve"
reve_desktop_mode="$reve_folder/desktop_mode"
kitty_dark_theme="$reve_folder/chore/kitty/dark"
kitty_light_theme="$reve_folder/chore/kitty/light"

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
if [[ $current_mode == "dark" ]]; then
    kitten themes --reload-in=all "$( util_readf "$kitty_dark_theme" )"
else
    kitten themes --reload-in=all "$( util_readf "$kitty_light_theme" )"
fi

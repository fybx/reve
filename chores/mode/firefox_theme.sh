#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type  mode
# name  firefox_theme.sh
# desc  changes the Firefox theme CSS depending on the desktop_mode
# vars  fcss_dark, fcss_light

if ! command -v firefox &> /dev/null; then
    echo "Mozilla Firefox is not installed. Please install it and try again."
    exit 1
fi

reve_folder="$HOME/.config/reve"
reve_desktop_mode="$reve_folder/desktop_mode"
target="$reve_folder/chore/firefox/target"
css_dark="$reve_folder/chore/firefox/css_dark"
css_light="$reve_folder/chore/firefox/css_light"

util_readf () {
    local filename=$1

    if [[ -f "$filename" ]]; then
        cat "$filename"
    else
        echo "util_readf: File not found: $filename" >&2
        return 1
    fi
}

rt_target=$( util_readf "$target" )
current_mode=$( util_readf "$reve_desktop_mode" )
if [[ $current_mode == "dark" ]]; then
    cp $( util_readf "$css_dark" ) "$rt_target"
else
    cp $( util_readf "$css_light" ) "$rt_target"
fi

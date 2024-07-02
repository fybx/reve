#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type  mode
# name  chore_script.sh
# desc  ...
# vars  ...

reve_folder="$HOME/.config/reve"
reve_desktop_mode="$reve_folder/desktop_mode"
gtk_dark_theme="$reve_folder/chore/gtk_dark_theme"
gtk_light_theme="$reve_folder/chore/gtk_light_theme"

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
echo "Hello, world! Current mode is $current_mode."

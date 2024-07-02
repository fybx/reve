#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type  mode
# name  gtk_theme.sh
# desc  changes the GTK theme and color-scheme according to desktop_mode
# vars  gtk_dark_theme, gtk_light_theme

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
if [[ "$current_mode" == "dark" ]]; then
    gsettings set org.gnome.desktop.interface gtk-theme $( util_readf "$gtk_dark_theme" )
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
else
    gsettings set org.gnome.desktop.interface gtk-theme $( util_readf "$gtk_light_theme" )
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
fi

#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type  mode
# name  spicetify.sh
# desc  changes spicetify theme depending on desktop_mode
# vars  spicetify_dark_theme, spicetify_light_theme

reve_folder="$HOME/.config/reve"
reve_desktop_mode="$reve_folder/desktop_mode"

source "$( reve -w )/_reve"

current_mode=$( util_readf "$reve_desktop_mode" )
spicetify_dark_theme=$( util_readf "$reve_folder/chore/spicetify/dark")
spicetify_light_theme=$( util_readf "$reve_folder/chore/spicetify/light")

if [[ "$current_mode" == "dark" ]]; then
    spicetify -q config color_scheme "$spicetify_dark_theme"
else
    spicetify -q config color_scheme "$spicetify_light_theme"
fi
spicetify -q apply

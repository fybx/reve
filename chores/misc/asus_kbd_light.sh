#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type      misc
# name      asus_kbd_light.sh
# desc      ...
# vars      ...
# reload    ...

reve_folder="$HOME/.config/reve"
reve_desktop_mode="$reve_folder/desktop_mode"

source "$( reve -w )/_reve"

current_mode=$( util_readf "$reve_desktop_mode" )

if [ "$current_mode" == "light" ]; then
    exit 0
fi

hex_dominant_color=$( magick "$reve_folder/chore/bg_dark" -resize 1x1\! -format "%[hex:p{0,0}]" info: )

asusctl led-mode static -c "$hex_dominant_color"
asusctl --kbd-bright med

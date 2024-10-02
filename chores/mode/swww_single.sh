#!/bin/bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type      mode
# name      swww_single.sh
# desc      changes the background depending on the desktop_mode
# vars      bg_dark, bg_light
# reload    asus_kbd_light.sh

if ! command -v swww &>/dev/null; then
  echo "swww is not installed. Please install it and try again."
  exit 1
fi

bg_dark="$REVE_FOLDER/chore/bg_dark"
bg_light="$REVE_FOLDER/chore/bg_light"

source "$(reve where)/_reve"

types=("left" "right" "top" "bottom" "wipe" "wave" "grow" "outer")
ltypes=${#types[@]}
rindex=$((RANDOM % ltypes))
rtype=${types[rindex]}

if [[ $RV_CURRENT_MODE == "dark" ]]; then
  swww img --transition-type "$rtype" --transition-pos 1,1 --transition-step 90 "$bg_dark"
  notify-send --urgency=low --expire-time=1450 --icon="$bg_dark" --app-name="reve: swww_single" "Wallpaper changed" "Wallpaper changed and saved on dark mode."
else
  swww img --transition-type "$rtype" --transition-pos 1,1 --transition-step 90 "$bg_light"
  notify-send --urgency=low --expire-time=1450 --icon="$bg_light" --app-name="reve: swww_single" "Wallpaper changed" "Wallpaper changed and saved on light mode."
fi

reload misc/asus_kbd_light.sh

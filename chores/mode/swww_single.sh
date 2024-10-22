#!/usr/bin/env bash

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

# shellcheck source=../../_reve.sh
source "$(reve where)/_reve"

types=("left" "right" "top" "bottom" "wipe" "wave" "grow" "outer")
ltypes=${#types[@]}
rindex=$((RANDOM % ltypes))
rtype=${types[rindex]}

bg="$(util_read_config chore."bg_$RV_CURRENT_MODE")"
swww img --transition-type "$rtype" --transition-pos 1,1 --transition-step 90 "$bg"
notify-send --urgency=low --expire-time=1450 --icon="$bg" --app-name="reve: swww_single" "Wallpaper changed" "Wallpaper changed and saved on $RV_CURRENT_MODE mode."
cp "$bg" "$(util_where_config chore.current_bg)"
reload misc/asus_kbd_light.sh

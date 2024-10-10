#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# cp utility/nemo/set_wallpaper.sh ~/.local/share/nemo/scripts
# chmod +x ~/.local/share/nemo/scripts/set_wallpaper.sh

source "$(reve where)/_reve"
reve_folder="$HOME/.config/reve"
reve_desktop_mode="$reve_folder/desktop_mode"

mode=$(util_readf "$reve_desktop_mode")
bgl="$reve_folder/chore/bg_light"
bgd="$reve_folder/chore/bg_dark"

if [ "$NEMO_SCRIPT_SELECTED_FILE_PATHS" = "" ]; then
  first=$1
else
  first=$(echo "$NEMO_SCRIPT_SELECTED_FILE_PATHS" | head -n 1)
fi

if [ "$mode" = "dark" ]; then
  cp -T "$first" "$bgd"
else
  cp -T "$first" "$bgl"
fi

reload mode/swww_single $mode

#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# ln -s utility/nemo/set_wallpaper.sh ~/.local/share/nemo/scripts

reve_folder="$HOME/.config/reve"
reve_desktop_mode="$reve_folder/desktop_mode"

mode=$(cat "$reve_folder/desktop_mode")
first=$(echo "$NEMO_SCRIPT_SELECTED_FILE_PATHS" | head -n 1)
bgl="$reve_folder/chores/bg_light"
bgd="$reve_folder/chores/bg_dark"

if [ "$mode" = "light" ]; then
  cp "$first" "$bgl"
else
  cp "$first" "$bgd"
fi

bash "$HOME/scripts/utility/deskenv.sh" nobright "$mode"
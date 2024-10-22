#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# cp utility/nemo/set_wallpaper.sh ~/.local/share/nemo/scripts
# chmod +x ~/.local/share/nemo/scripts/set_wallpaper.sh

# shellcheck source=../../_reve.sh
source "$(reve where)/_reve"

mode=$(util_read_config base.desktop_mode)

if [ "$NEMO_SCRIPT_SELECTED_FILE_PATHS" = "" ]; then
  first=$1
else
  first=$(echo "$NEMO_SCRIPT_SELECTED_FILE_PATHS" | head -n 1)
fi

util_write_config "chore.bg_$mode" "$first"
reload mode/swww_single "$mode"

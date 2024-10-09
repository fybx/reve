#!/bin/bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type      mode
# name      swww-based wallpaper slideshow
# desc      reruns utility/swww_slideshow when mode changes
# vars      swwwss.dark, swwwss.light, swwwss.folder
# reload    no

# shellcheck source=../../_reve.sh
source "$(reve where)/_reve"

desktop_mode=$(util_read_config base.desktop_mode)

if [ "$desktop_mode" == "dark" ]; then
  util_write_config swwwss.folder "$(util_read_config swwwss.dark)"
else
  util_write_config swwwss.folder "$(util_read_config swwwss.light)"
fi

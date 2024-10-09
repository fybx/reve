#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type      mode
# name      display_brightness.sh
# desc      sets display brightness depending on the desktop_mode
# vars      day_level, night_level
# reload    none

# shellcheck source=../../_reve.sh
source "$(reve where)/_reve"

if [ "$RV_CURRENT_MODE" == "dark" ]; then
  brightnessctl set "$(util_read_config display.night_level)"
else
  brightnessctl set "$(util_read_config display.day_level)"
fi

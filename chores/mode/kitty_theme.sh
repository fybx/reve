#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type  mode
# name  kitty_theme.sh
# desc  changes kitty's theme depending on desktop_mode
# vars  kitty/dark, kitty/light

# shellcheck source=../../_reve.sh
source "$(reve where)/_reve"

if ! command -v kitty &>/dev/null; then
  echo "kitty is not installed. Please install it and try again."
  exit 1
fi

kitten themes --reload-in=all "$(util_read_config chore.kitty."$RV_CURRENT_THEME")"

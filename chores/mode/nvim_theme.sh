#!/bin/bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type      mode
# name      nvim_theme.sh
# desc      sends a signal to nvim to fetch desktop_mode
# vars      none
# reload    none

if pids=$(pgrep -fx 'nvim'); then
  echo "$pids" | xargs kill -USR1
fi

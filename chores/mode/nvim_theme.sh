#!/bin/bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type      mode
# name      nvim_theme.sh
# desc      sends a signal to nvim to fetch desktop_mode
# vars      none
# reload    none

handle_usr1() {
  return
}
trap handle_usr1 USR1

if pids=$(pgrep -f 'nvim'); then
  echo "$pids" | xargs kill -USR1
fi

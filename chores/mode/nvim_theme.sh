#!/bin/bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type      mode
# name      nvim_theme.sh
# desc      sends a signal to nvim to fetch desktop_mode
# vars      none
# reload    none

kill -USR1 $(pgrep -f 'nvim')

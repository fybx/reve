#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type  mode
# name  chore_script.sh
# desc  ...
# vars  ...

reve_folder="$HOME/.config/reve"
reve_desktop_mode="$reve_folder/desktop_mode"

source "$( reve -w )/_reve"

current_mode=$( util_readf "$reve_desktop_mode" )
echo "Hello, world! Current mode is $current_mode."

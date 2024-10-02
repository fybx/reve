#!/bin/bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type      mode
# name      chore_script.sh
# desc      ...
# vars      ...
# reload    ...

# shellcheck source=../_reve.sh
source "$(reve where)/_reve"

echo "Hello, world! Current mode is $RV_CURRENT_MODE."

reload mode/gtk_theme

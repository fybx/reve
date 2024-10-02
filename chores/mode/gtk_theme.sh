#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type  mode
# name  gtk_theme.sh
# desc  changes the GTK theme and color-scheme according to desktop_mode
# vars  gtk_dark_theme, gtk_light_theme

# shellcheck source=../../_reve.sh
source "$(reve where)/_reve"

gsettings set org.gnome.desktop.interface gtk-theme "$(util_read_config chore.gtk_"$RV_CURRENT_MODE"_theme)"
gsettings set org.gnome.desktop.interface color-scheme prefer-"$RV_CURRENT_MODE"

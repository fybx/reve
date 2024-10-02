#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type  mode
# name  spicetify.sh
# desc  changes spicetify theme depending on desktop_mode
# vars  spicetify/dark, spicetify/light

# shellcheck source=../../_reve.sh
source "$(reve where)/_reve"

spicetify -q config color_scheme "$(util_read_config chore.spicetify."$RV_CURRENT_MODE")"
spicetify -q apply

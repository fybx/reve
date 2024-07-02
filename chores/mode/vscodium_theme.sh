#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# chore script
# type  mode
# name  vscodium_theme.sh
# desc  changes the VSCodium theme according to the desktop_mode and preferences set in VSCodium config
# vars  internal VSCodium preferences

if ! command -v vscodium &> /dev/null; then
    echo "vscodium is not installed. Please install it and try again."
    exit 1
fi

reve_folder="$HOME/.config/reve"
reve_desktop_mode="$reve_folder/desktop_mode"
path_settings="$HOME/.config/VSCodium/User/settings.json"
preferred_dark=$(grep -o '"workbench.preferredDarkColorTheme": *"[^"]*"' < "$path_settings" | cut -d '"' -f4)
preferred_light=$(grep -o '"workbench.preferredLightColorTheme": *"[^"]*"' < "$path_settings" | cut -d '"' -f4)

util_readf () {
    local filename=$1

    if [[ -f "$filename" ]]; then
        cat "$filename"
    else
        echo "util_readf: File not found: $filename" >&2
        return 1
    fi
}

case $( util_readf $reve_desktop_mode ) in
    'light' | l)
        sed -i "s/\"workbench.colorTheme\": \"[^\"]*\"/\"workbench.colorTheme\": \"$preferred_light\"/" "$path_settings";;
    'dark' | d)
        sed -i "s/\"workbench.colorTheme\": \"[^\"]*\"/\"workbench.colorTheme\": \"$preferred_dark\"/" "$path_settings";;
    *)
        echo "[vscodium_theme] [W] Provided argument: $reve_desktop_mode"
        echo "[vscodium_theme] [E] Invalid argument. Please provide either 'light' or 'dark'."
        exit 1;;
esac

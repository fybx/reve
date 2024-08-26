#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# VERY CRITICAL: change this if install.sh is updated
reve_installation="$HOME/.local/bin/reve"
reve_config="$HOME/.config/reve"

util_readf () {
    local filename=$1

    if [[ -f "$filename" ]]; then
        cat "$filename"
    else
        echo "[reve] [E] util_readf: File not found: $filename" >&2
        return 1
    fi
}

util_read_config () {
    local config_key=$1
    pre_removed_key=${config_key/#base./}
    config_path=$( echo "$pre_removed_key" | sed 's/\./\//g' )
    util_readf "$reve_config/$config_path"
    return $?
}

util_write_config () {
    local config_key=$1 new_value=$2
    pre_removed_key=${config_key/#base./}
    config_path=$( echo "$pre_removed_key" | sed 's/\./\//g' )
    mkdir -p "$( dirname "$reve_config/$config_path" )"
    echo "$new_value" > "$reve_config/$config_path"
}

util_delete_config () {
    local config_key=$1
    pre_removed_key=${config_key/#base./}
    config_path=$( echo "$pre_removed_key" | sed 's/\./\//g' )
    rm "$reve_config/$config_path"
    dir=$( dirname "$reve_config/$config_path")
    [ -z "$( ls -A "$dir")" ] && rm -r "$dir"
}

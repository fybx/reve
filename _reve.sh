#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

util_readf () {
    local filename=$1

    if [[ -f "$filename" ]]; then
        cat "$filename"
    else
        echo "[reve] [E] util_readf: File not found: $filename" >&2
        return 1
    fi
}

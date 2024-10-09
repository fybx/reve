#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# reve internal: _reve_utils
# defines utility functions

# VERY CRITICAL: change this if install.sh is updated
reve_installation="$HOME/.local/bin/reve"

util_readf() {
  local filename=$1

  if [[ -f "$filename" ]]; then
    cat "$filename"
  else
    error E "util_readf" "File not found: $filename"
    return 1
  fi
}

error() {
  local level=$1 location=$2 cause=$3
  message="[reve] [$level] [$location] $cause"
  echo "$message"
  now=$(date -Iminutes)
  echo "${now::-6} $message" >>"$reve_installation/reve.log"
}

#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# VERY CRITICAL: change this if install.sh is updated
reve_installation="$HOME/.local/bin/reve"
reve_config="$HOME/.config/reve"

util_readf() {
  local filename=$1

  if [[ -f "$filename" ]]; then
    cat "$filename"
  else
    error E "util_readf" "File not found: $filename"
    return 1
  fi
}

util_where_config() {
  local config_key=$1
  pre_removed_key=${config_key/#base./}
  config_path=$(echo "$pre_removed_key" | sed 's/\./\//g')
  echo "$reve_config/$config_path"
}

util_read_config() {
  local fp_config
  fp_config=$(util_where_config "$1")
  util_readf "$fp_config"
  return $?
}

util_write_config() {
  local fp_config new_value=$2
  fp_config=$(util_where_config "$1")
  mkdir -p "$(dirname "$fp_config")"
  echo "$new_value" >"$fp_config"
}

util_delete_config() {
  local config_key=$1
  pre_removed_key=${config_key/#base./}
  config_path=$(echo "$pre_removed_key" | sed 's/\./\//g')
  rm "$reve_config/$config_path"
  dir=$(dirname "$reve_config/$config_path")
  [ -z "$(ls -A "$dir")" ] && rm -r "$dir"
}

util_run_chore() {
  local chore_path="$reve_installation/chores/$1"
  if [ -x "$chore_path.sh" ]; then
    error I "util_run_chore" "Running single chore: $(basename "$1")"
    bash "$chore_path.sh"
  else
    error E "util_run_chore" "$chore_path is not executable"
  fi
}

util_run_utility() {
  local utility_path="$reve_installation/utility/$1"
  if [ -x "$utility_path.sh" ]; then
    error I "util_run_utility" "Running utility script: $(basename "$1")"
    bash "$utility_path.sh"
  else
    error E "util_run_utility" "$utility_path is not executable"
  fi
}

reload() {
  util_run_chore "$1"
}

reload_util() {
  util_run_utility "$1"
}

util_toggle_dm() {
  if [[ $(util_read_config base.desktop_mode) == "dark" ]]; then
    util_write_config base.desktop_mode light
  else
    util_write_config base.desktop_mode dark
  fi
}

error() {
  local level=$1 location=$2 cause=$3
  message="[reve] [$level] [$location] $cause"
  echo "$message"
  now=$(date -Iminutes)
  echo "${now::-6} $message" >>"$reve_installation/reve.log"
}

#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# reve internal: _reve_states
# defines state management API

_current_dir=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
# shellcheck source=_reve_utils.sh
source "$_current_dir/_reve_utils" >&/dev/null
(($? == 1)) && source "$_current_dir/_reve_utils.sh"

REVE_STATE_REPO="$HOME/.local/bin/reve/states"

__util_pathto_state() {
  # args: $1 -- state key
  # args: $2 -- state type
  local key=$1 type=$2

  pre_removed_key=${key/#base./}
  state_path="$(echo "$pre_removed_key" | sed 's/\./\//g')$type"
  echo "$state_path"
}

__util_find_state() {
  # args: $1 -- state key
  # returns: 1 if state key not in map
  #          2 if map is corrupted
  local key=$1

  type=$(awk -F'=' -v key="$key" '$1 == key {print $2}' "$REVE_STATE_REPO/map")
  case "$type" in
  prs | persistent) type="" ;;
  tmp | temporary) type=".tmp" ;;
  "")
    error E states "state referenced by key '$key' doesn't exist"
    return 1
    ;;
  *)
    error E states "state map '$REVE_STATE_REPO/map' is corrupted"
    return 2
    ;;
  esac

  __util_pathto_state "$1" "$type"
}

util_create_state() {
  local type=$1 key=$2 value=$3

  if [ "$type" != "tmp" ] && [ "$type" != "prs" ]; then
    error E util_create_state "can't create state with type '$type'"
    return
  fi

  if ! __util_find_state "$key"; then
    echo "$value" >"$(__util_pathto_state "$key" "$type")"
    echo "$key=$value" >"$REVE_STATE_REPO/map"
  fi
}

util_write_state() {
  local key=$1 value=$2

  _path=$(__util_find_state "$key")
  if $? -eq 0; then
    echo "$value" >"$_path"
  fi
}

util_read_state() {
  local key=$1

  _path=$(__util_find_state "$key")
  if $? -eq 0; then
    cat "$_path"
  fi
}

util_delete_state() {
  local key=$1

  _path=$(__util_find_state "$key")
  if $? -eq 0; then
    rm "$_path"
    awk -F '=' -v key="$key" '$1 != key' "$REVE_STATE_REPO/map" >"$REVE_STATE_REPO/map.tmp"
    mv "$REVE_STATE_REPO/map.tmp" "$REVE_STATE_REPO/map"

    _dir=$(dirname "$_path")
    [ -z "$(ls -A "$_dir")" ] && rm -r "$_dir"
  fi
}

util_deleteall_temp() {
  awk -F'=' '$2 == "tmp" { print $1 }' data.txt | while read -r key; do
    util_delete_state "$key"
  done
}

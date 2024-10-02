#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

# shellcheck disable=SC2086
# SC2086 is disabled here, but all user inputs must be quoted

in_desktop_mode=""
in_reason=""
in_chore_name=""

rt_script_dir=$(realpath "$(dirname "$0")")
rt_has_mode_changed=0
rt_current_mode="unset"

reve_folder="$HOME/.config/reve"
reve_desktop_mode="$reve_folder/desktop_mode"

reve_chores_mode="$rt_script_dir/chores/mode"

# bring reve utility functions to the context
# shellcheck source=_reve.sh
source "$rt_script_dir/_reve" >&/dev/null
(($? == 1)) && source "$rt_script_dir/_reve.sh" # looks like we're in dev environment

util_help() {
  local command="$1"

  case $command in
  reve | '')
    echo "=> Usage: reve [command] OR reve [subcommand] [command]"
    echo "== Commands =="
    echo "mode      {desktop_mode}    sets desktop mode, accepts 'dark' or 'light'"
    echo "reason    {reason}          run reve with reason, accepts 'network' or 'time'"
    echo "chore     {chore_name}      run a single chore, accepts chore name"
    echo "where                       returns where reve's installed"
    echo "poll                        runs reve to update desktop_mode & power_mode, and do chores"
    echo "help      [subcommand]      shows help message"
    echo "== Subcommands =="
    echo "1. config                   gets/sets configuration values"
    echo "2. update                   updates chores"
    ;;
  config)
    echo "=> Usage"
    echo "1. reve config get {config_key}            get the value stored in file"
    echo "2. reve config set {config_key} {value}    set the value of file"
    echo "3. reve config rm  {config_key}            delete the config file"
    ;;
  update)
    echo "=> Usage: reve update [chore names...]       updates chores from upstream"
    echo "== Details =="
    echo "Updates all chores present on your configuration if nothing is given. The"
    echo "chore names must be space delimited."
    ;;
  esac
}

f_shell_completion() {
  if [ "$in_shell_comp" == "fish" ]; then
    cp "$rt_script_dir/completions/reve.fish" "$HOME/.config/fish/completions/reve.fish"
  elif [ "$in_shell_comp" == "bash" ]; then
    _reve_completions=$(util_readf "$rt_script_dir/completions/reve.bash")

    if [ ! -f "$HOME/.bash_completion" ]; then
      touch "$HOME/.bash_completion"
    fi

    if ! grep -q "_reve_completions" "$HOME/.bash_completion"; then
      echo "$_reve_completions" >>"$HOME/.bash_completion"
    fi
  fi
}

set_desktop_mode() {
  if [[ -n "$in_desktop_mode" ]]; then
    echo "$in_desktop_mode" >"$reve_desktop_mode"
    return 1 # since mode has changed
  fi

  local previous_mode num_day num_night current_time
  previous_mode=$(util_read_config base.desktop_mode)
  num_day=$(awk -F: '{print $1 * 60 + $2}' <<<"$(util_read_config base.time_day)")
  num_night=$(awk -F: '{print $1 * 60 + $2}' <<<"$(util_read_config base.time_night)")
  current_time=$(awk -F: '{print $1 * 60 + $2}' <<<"$(date +%H:%M)")

  if ((num_night > current_time && current_time >= num_day)); then
    rt_current_mode="light"
  else
    rt_current_mode="dark"
  fi

  echo "[reve] [I] Setting the mode: $rt_current_mode"
  echo "$rt_current_mode" >"$reve_desktop_mode"

  if [ "$rt_current_mode" == "$previous_mode" ]; then
    return 0 # since mode did not change
  else
    return 1
  fi
}

# Called when the mode (the default state, is either dark or light) changes
chores_mode() {
  for file in "$reve_chores_mode"/*; do
    if [ -x "$file" ]; then
      echo "[reve] [I] Running chore: $(basename "$file")"
      util_run_chore "$file" $rt_current_mode
    else
      echo "[reve] [E] chores_mode: $file is not executable"
    fi
  done
}

util_handle_pos() {
  # args: $@ -- handles positionals
  # returns: 'light' or 'dark' depending on positionals or $rt_current_mode
  local forced_mode=$rt_current_mode
  for arg in "$@"; do
    if [[ "$arg" == "-d" || "$arg" == "--dark" ]]; then
      forced_mode="dark"
    elif [[ "$arg" == "-l" || "$arg" == "--light" ]]; then
      forced_mode="light"
    fi
  done
  echo $forced_mode
}

sub_config() {
  case "$1" in
  get)
    util_read_config "$2"
    ;;
  set)
    util_write_config "$2" "$3"
    ;;
  rm | delete)
    util_delete_config "$2"
    ;;
  "")
    util_help config
    ;;
  *)
    echo "reve: in subcommand config: '$1' is not a valid command"
    ;;
  esac
}

main() {
  mkdir -p "$reve_folder"

  if [[ "$in_chore_name" != "" ]]; then
    forced_mode=$(util_handle_pos "$@")
    util_run_chore "$in_chore_name" $forced_mode
    return
  fi

  set_desktop_mode
  rt_has_mode_changed="$?"
  if ((rt_has_mode_changed == 1)) || [[ "$in_reason" == "chores_mode" ]]; then
    chores_mode
  fi
}

case "$1" in
config)
  sub_config "$2" "$3" "$4"
  exit 0
  ;;
update)
  sub_update
  exit 0
  ;;
help)
  util_help "$2"
  exit 0
  ;;
where)
  dirname "$(which reve)"
  exit 0
  ;;
shell-completion)
  in_shell_comp="$2"
  f_shell_completion
  exit 0
  ;;
mode)
  in_desktop_mode="$2"
  ;;
reason)
  in_reason="$2"
  ;;
chore)
  in_chore_name="$2"
  ;;
poll) ;;
"")
  util_help "$2"
  exit 0
  ;;
*)
  echo "reve: invalid command or subcommand: $1"
  exit 1
  ;;
esac

main "$@"

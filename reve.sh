#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

in_desktop_mode=""
in_reason=""
in_chore_name=""

rt_script_dir=$(realpath "$(dirname "$0")")
rt_has_mode_changed=0

reve_folder="$HOME/.config/reve"
reve_desktop_mode="$reve_folder/desktop_mode"
reve_time_day="$reve_folder/time_day"
reve_time_night="$reve_folder/time_night"

reve_chores_mode="$rt_script_dir/chores/mode"

# bring reve utility functions to the context
# shellcheck source=_reve.sh
source "$rt_script_dir/_reve" >&/dev/null
(( $? == 1 )) && source "$rt_script_dir/_reve.sh" # looks like we're in dev environment

util_help () {
    local command="$1"

    case $command in
        reve|'')
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

util_mkdirs () {
    mkdir -p "$reve_folder"
}

f_shell_completion () {
    if [ "$in_shell_comp" == "fish" ]; then
        cp "$rt_script_dir/completions/reve.fish" "$HOME/.config/fish/completions/reve.fish"
    elif [ "$in_shell_comp" == "bash" ]; then
        _reve_completions=$( util_readf "$rt_script_dir/completions/reve.bash" )

        if [ ! -f "$HOME/.bash_completion" ]; then
            touch "$HOME/.bash_completion"
        fi

        if ! grep -q "_reve_completions" "$HOME/.bash_completion"; then
            echo "$_reve_completions" >> "$HOME/.bash_completion"
        fi

        if [ -n "$BASH_SOURCE" ]; then
            source "$HOME/.bash_completion"
        fi
    fi
}

set_desktop_mode () {
    if [[ -n "$in_desktop_mode" ]]; then
        echo "$in_desktop_mode" > "$reve_desktop_mode"
        return 1 # since mode has changed
    fi

    local current_mode="unset"
    local previous_mode day_start night_start num_day num_night current_time
    previous_mode=$( util_readf "$reve_desktop_mode" )
    day_start=$( util_readf "$reve_time_day" )
    night_start=$( util_readf "$reve_time_night" )
    num_day=$( awk -F: '{print $1 * 60 + $2}' <<< "$day_start" )
    num_night=$( awk -F: '{print $1 * 60 + $2}' <<< "$night_start" )
    current_time=$( awk -F: '{print $1 * 60 + $2}' <<< "$(date +%H:%M)" )

    if ((num_night > current_time && current_time >= num_day)); then
        current_mode="light"
    else
        current_mode="dark"
    fi

    echo "[reve] [I] Setting the mode: $current_mode"
    echo "$current_mode" > "$reve_desktop_mode"

    if [ "$current_mode" == "$previous_mode" ]; then
        return 0 # since mode did not change
    else
        return 1
    fi
}

prepare () {
    util_mkdirs
    set_desktop_mode
    rt_has_mode_changed="$?"
    echo $rt_has_mode_changed
}

# Called when the mode (the default state, is either dark or light) changes
chores_mode () {
    for file in "$reve_chores_mode"/*; do
        if [ -x "$file" ]; then
            echo "[reve] [I] Running chore: $( basename "$file" )"
            bash "$file"
        else
            echo "[reve] [E] chores_mode: $file is not executable"
        fi
    done
}

util_handle_pos () {
    local forced_mode
    for arg in "$@"; do
        if [[ "$arg" == "-d" || "$arg" == "--dark" ]]; then
            forced_mode="dark"
        elif [[ "$arg" == "-l" || "$arg" == "--light" ]]; then
            forced_mode="light"
        fi
    done

    if [[ $( util_read_config base.desktop_mode ) != "$forced_mode" ]]; then
        util_write_config "$forced_mode"
    fi
}

sub_config () {
    case "$1" in
        get)
            util_read_config "$2"
            ;;
        set)
            util_write_config "$2" "$3"
            ;;
        rm|delete)
            util_delete_config "$2"
            ;;
        "")
            util_help config
            ;;
        *)
            echo "[reve] [E] in subcommand config: '$1' is not a valid command"
            ;;
    esac
}

main () {
    if (( rt_has_mode_changed == 1 )) || [[ "$in_reason" == "chores_mode" ]]; then
        chores_mode
    fi

    if [[ "$in_chore_name" != "" ]]; then
        util_run_chore "$in_chore_name"
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
        dirname "$( which reve )"
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
        util_handle_pos "$@"   
        util_run_chore "$2"
        util_toggle_dm
        exit 0
        ;;
    poll)
        ;;
    "")
        util_help "$2"
        exit 0
        ;;
    *)
        echo "Invalid command or subcommand: $1"
        exit 1
        ;;
esac

prepare "$@"
main

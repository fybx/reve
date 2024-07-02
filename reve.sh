#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

in_desktop_mode=""
in_reason=""
in_chore_name=""

SHORTOPTS="h,m:r:c:"
LONGOPTS="help,mode:,reason:,chore:"

PARSED_OPTS=$(getopt --options $SHORTOPTS --longoptions $LONGOPTS --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    echo "Failed to parse options."
    exit 1
fi

eval set -- "$PARSED_OPTS"

rt_script_dir=$(realpath "$(dirname $0)")
rt_has_mode_changed=0

reve_folder="$HOME/.config/reve"
reve_desktop_mode="$reve_folder/desktop_mode"
reve_time_day="$reve_folder/time_day"
reve_time_night="$reve_folder/time_night"

reve_chores_mode="$rt_script_dir/chores/mode"

util_help () {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "desktop_mode  (-m, --mode):   dark, light"
    echo "reason        (-r, --reason): time, network"
    echo "chore         (-c, --chore):  chore_name"
}

util_readf () {
    local filename=$1

    if [[ -f "$filename" ]]; then
        cat "$filename"
    else
        echo "[reve] [E] util_readf: File not found: $filename" >&2
        return 1
    fi
}

util_mkdirs () {
    mkdir -p $reve_folder
}

util_run_single_chore () {
    local chore_fullname="$reve_chores_mode/$1"
    if [ -x "$chore_fullname.sh" ]; then
        echo "[reve] [I] Running single chore: $chore_fullname"
        bash "$chore_fullname.sh"
    else
        echo "[reve] [E] util_run_single_chore: $chore_fullname is not executable"
    fi
}

set_desktop_mode () {
    if [[ -n "$forced_mode" ]]; then
        echo $forced_mode > $reve_desktop_mode
        return 1 # since mode has changed
    fi

    local current_mode="unset"
    local previous_mode=$( util_readf $reve_desktop_mode )
    local day_start=$( util_readf $reve_time_day )
    local night_start=$( util_readf $reve_time_night )

    local num_day=$( awk -F: '{print $1 * 60 + $2}' <<< "$day_start" )
    local num_night=$( awk -F: '{print $1 * 60 + $2}' <<< "$night_start" )
    local current_time=$( awk -F: '{print $1 * 60 + $2}' <<< "$(date +%H:%M)" )

    if ((num_night > current_time && current_time >= num_day)); then
        current_mode="light"
    else
        current_mode="dark"
    fi

    echo "[reve] [I] Setting the mode: $current_mode"
    echo "$current_mode" > $reve_desktop_mode

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
}

# Called when the mode (the default state, is either dark or light) changes
chores_mode () {
    for file in "$reve_chores_mode"/*; do
        if [ "$item" != "$reve_chores_mode/." ] && [ "$item" != "$reve_chores_mode/.." ]; then
            if [ -x "$file" ]; then
                echo "[reve] [I] Running chore: $( basename $file )"
                bash "$file"
            else
                echo "[reve] [E] chores_mode: $file is not executable"
            fi
        fi
    done
}

main () {
    if (( $rt_has_mode_changed == 1 )) || [[ "$reason" == "chores_mode" ]]; then
        chores_mode
    fi

    if [[ "$in_chore_name" != "" ]]; then
        util_run_single_chore "$in_chore_name"
    fi
}

while true; do
    case "$1" in
        -h|--help)
            util_help
            exit 0
            shift
            ;;
        -m|--mode)
            in_desktop_mode="$2"
            shift 2
            ;;
        -r|--reason)
            in_reason="$2"
            shift 2
            ;;
        -c|--chore)
            in_chore_name="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Invalid option: $1"
            exit 1
            ;;
    esac
done

forced_mode=$in_desktop_mode
reason=$in_reason
prepare
main

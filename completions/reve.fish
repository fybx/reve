#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

function __reve_complete_modes
    echo "dark"
    echo "light"
end

function __reve_complete_reasons
    echo "time"
    echo "network"
end

function __reve_complete_chores
    ls ~/.config/reve/chores/mode | sed 's/\.sh$//'
end

complete -c reve -s m -l mode -a '(__reve_complete_modes)' -d 'Specify desktop mode (dark or light)'
complete -c reve -s r -l reason -a '(__reve_complete_reasons)' -d 'Specify the reason (time or network)'
complete -c reve -s c -l chore -a '(__reve_complete_chores)' -d 'Specify a chore to run'
complete -c reve -s w -l where -d 'Display the installation path of reve'
complete -c reve -s h -l help -d 'Show help message'
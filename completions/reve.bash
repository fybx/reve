#!/bin/bash

_reve_completions() {
    local cur prev opts modes reasons chores
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    opts="-h --help -m --mode -r --reason -c --chore -w --where --shell-completion"
    modes="dark light"
    reasons="time network"
    chores=$(ls ~/.config/reve/chores/mode | sed 's/\.sh$//')
    
    case "${prev}" in
        -m|--mode)
            COMPREPLY=( $(compgen -W "${modes}" -- ${cur}) )
            return 0
            ;;
        -r|--reason)
            COMPREPLY=( $(compgen -W "${reasons}" -- ${cur}) )
            return 0
            ;;
        -c|--chore)
            COMPREPLY=( $(compgen -W "${chores}" -- ${cur}) )
            return 0
            ;;
        *)
            ;;
    esac
    
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

complete -F _reve_completions reve

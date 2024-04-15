#!/bin/bash

if [ -z "$1" ]; then
    printf "Usage: \$1 = 1 to change string or 2 to reverse change string\n"
    exit 1
fi
SCRIPT_FULL_PATH="$(pwd)/$(basename "$0")"
DIR="${DIR:-"$(pwd)"}"
PYTHON_IN_VENV=$(which python)
STRING_1="#!/usr/bin/python3" #string_to_change
STRING_2="#!$PYTHON_IN_VENV"

printf "%s\n%s\n" "$SCRIPT_FULL_PATH" "$DIR"

if [[ "$1" -eq 1 ]]; then
    {
    STRING_TO_CHANGE="$STRING_1"
    CHANGED_STRING="$STRING_2"
    }
elif [[ "$1" -eq 2 ]]; then 
    {
    STRING_TO_CHANGE="$STRING_2"
    CHANGED_STRING="$STRING_1"
    }
fi

for file in $(grep -rl "$CHANGED_STRING" "$DIR"); do
    if [ "$file" != "$SCRIPT_FULL_PATH" ]; then
        printf "REPLACING IN: %s:\n" "$file"
        grep "$CHANGED_STRING" "$file"
        sed -i "s|$CHANGED_STRING|$STRING_TO_CHANGE|g" "$file"
        grep "$STRING_TO_CHANGE" "$file"
        printf "============================================================\n"
    fi
done
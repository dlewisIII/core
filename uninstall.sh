#!/bin/bash

SUDO="$(which sudo)"
PROJECT_DIR=~/.docker-blueprint
EXEC_PATH=$(which docker-blueprint)

if [[ -n $EXEC_PATH ]]; then
    printf "Removing link..."
    $SUDO rm -f $EXEC_PATH
    printf " done\n"
fi

EXEC_PATH=$(which dob)

if [[ -n $EXEC_PATH ]]; then
    printf "Removing link..."
    $SUDO rm -f $EXEC_PATH
    printf " done\n"
fi

if [[ -d "$PROJECT_DIR" ]]; then
    printf "Removing project directory..."
    rm -rf $PROJECT_DIR
    printf " done\n"
fi

echo "Successfuly removed docker-blueprint."

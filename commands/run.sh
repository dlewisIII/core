#!/bin/bash

shift

#
# Read arguments
#

case $1 in
    -h|--help)
        printf "${CMD_COL}run${RESET} ${ARG_COL}<command>${RESET}"
        printf "\t\t\tRun a command in a predefined environment\n"

        exit

        ;;
    *)
        COMMAND=$1
esac

yq_read_keys POSSIBLE_COMMANDS "commands" "docker-blueprint.yml"

if [[ -z "$COMMAND" ]]; then
    bash $ENTRYPOINT run --help

    if [[ ${#POSSIBLE_COMMANDS[@]} > 0 ]]; then
        printf "${GREEN}Possible commands${RESET}:"
        for key in "${POSSIBLE_COMMANDS[@]}"; do
            printf " $key"
        done
        printf "\n"
    else
        printf "${YELLOW}This project has no commands\n"
    fi

    exit 1
fi

yq_read_keys ENVIRONMENT_KEYS "commands.$COMMAND.environment" "docker-blueprint.yml"

echo "Setting environment..."

for key in "${ENVIRONMENT_KEYS[@]}"; do
    yq_read_value value "commands.$COMMAND.environment.$key" "docker-blueprint.yml"
    if [[ -n ${value+x} ]]; then
        export $key=$value
    fi

    echo "$key=${!key}"
done

yq_read_value command_string "commands.$COMMAND.command" "docker-blueprint.yml"

bash $ENTRYPOINT up
bash $ENTRYPOINT "$command_string"

for key in "${ENVIRONMENT_KEYS[@]}"; do
    unset $key
done

bash $ENTRYPOINT up

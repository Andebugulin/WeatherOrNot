#!/bin/bash

# Add color codes for easier readability
GREEN="\033[32m"
RED="\033[31m"
CYAN="\033[36m"
NO_COLOR="\033[0m"

# Function to start docker-compose services
start_docker_compose() {
    echo -e "${GREEN}Starting docker-compose services...${NO_COLOR}"
    cd server/ || exit
    docker-compose up -d
    cd - || exit
}

# Function to run the node server
run_node_server() {
    echo -e "${GREEN}Running node server...${NO_COLOR}"
    cd web-app/ || exit
    node src/server.js
    cd - || exit
}

# Function to run Vite app
run_vite_app() {
    echo -e "${GREEN}Starting Vite app...${NO_COLOR}"
    cd web-app/ || exit
    npm run dev
    cd - || exit
}

# Function to run fake Arduino script
run_fake_arduino() {
    echo -e "${GREEN}Running fake Arduino script...${NO_COLOR}"
    ./scripts/fake_arduino.sh
}

# Function to stop docker-compose services
stop_docker_compose() {
    echo -e "${GREEN}Stopping docker-compose services...${NO_COLOR}"
    cd server/ || exit
    docker-compose down
    cd - || exit
}

# Update the show_help function with the new command
show_help() {
    echo -e "${CYAN}Usage: $(basename "$0") [option]"
    echo "Options:"
    echo "  help                 Show this help message"
    echo "  start-docker-compose Start Docker Compose services"
    echo "  stop-docker-compose  Stop Docker Compose services"
    echo "  run-node-server      Run Node server"
    echo "  run-vite-app         Start Vite app"
    echo "  run-fake-arduino     Run fake Arduino script"
    echo "  shell                Enter shell mode (interactive commands)${NO_COLOR}"
}

# Shell mode enhanced with suggestions feature
shell_mode() {
    while true; do
        # Print the prompt with colors
        printf "${CYAN}project-manager> ${NO_COLOR}"
        # Now, use read without the -p option
        read -r cmd
        case $cmd in
            help) show_help ;;
            start-docker-compose) start_docker_compose ;;
            stop-docker-compose) stop_docker_compose ;;
            run-node-server) run_node_server ;;
            run-vite-app) run_vite_app ;;
            run-fake-arduino) run_fake_arduino ;;
            exit) break ;;
            *) 
                echo -e "${RED}Unknown command: $cmd. Suggestions:${NO_COLOR}"
                local commands=("help" "start-docker-compose" "stop-docker-compose" "run-node-server" "run-vite-app" "run-fake-arduino" "exit")
                for i in "${commands[@]}"; do
                    if [[ "$i" == "$cmd"* ]]; then
                        echo "  $i"
                    fi
                done
                echo "Type 'help' for a list of commands."
                ;;
        esac
    done
}


# Main script logic enhanced for color and shell mode
if [ $# -eq 0 ]; then
    shell_mode
else
    case $1 in
        help) show_help ;;
        start-docker-compose) start_docker_compose ;;
        stop-docker-compose) stop_docker_compose ;;
        run-node-server) run_node_server ;;
        run-vite-app) run_vite_app ;;
        run-fake-arduino) run_fake_arduino ;;
        shell) shell_mode ;;
        *) echo -e "${RED}Invalid option: $1. Type '$0 help' for a list of commands.${NO_COLOR}" ;;
    esac
fi

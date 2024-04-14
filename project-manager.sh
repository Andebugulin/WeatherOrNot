#!/bin/bash

# Add color codes for easier readability
GREEN="\033[32m"
RED="\033[31m"
CYAN="\033[36m"
NO_COLOR="\033[0m"  # Define NO_COLOR to reset to default terminal color

# Function to start docker-compose services
start_docker_compose() {
    echo -e "${GREEN}Starting docker-compose services...${NO_COLOR}"
    cd server/ || exit
    docker-compose up -d
    cd - || exit
}

# Function to stop docker-compose services
stop_docker_compose() {
    echo -e "${GREEN}Stopping docker-compose services...${NO_COLOR}"
    cd server/ || exit
    docker-compose down
    cd - || exit
}

# Function to run the node server in the background
run_node_server() {
    echo -e "${GREEN}Running node server...${NO_COLOR}"
    cd web-app/ || exit
    nohup node src/server.js > server.log 2>&1 &
    echo $! > node_server.pid
    echo "Node server started. Logs are being written to 'server.log'"
    cd - || exit
}

# Function to stop the node server
stop_node_server() {
    echo -e "${GREEN}Stopping node server...${NO_COLOR}"
    if [ -f web-app/node_server.pid ]; then
        kill -9 $(cat web-app/node_server.pid)
        rm web-app/node_server.pid
        echo "Node server stopped."
    else
        echo "Node server PID file not found. Is the server running?"
    fi
}

# Function to run Vite app in the background
run_vite_app() {
    echo -e "${GREEN}Starting Vite app...${NO_COLOR}"
    cd web-app/ || exit
    nohup npm run dev > vite.log 2>&1 &
    echo $! > vite_app.pid
    echo "Vite app started. Logs are being written to 'vite.log'"
    cd - || exit
}

# Function to stop the Vite app
stop_vite_app() {
    echo -e "${GREEN}Stopping Vite app...${NO_COLOR}"
    if [ -f web-app/vite_app.pid ]; then
        PID=$(cat web-app/vite_app.pid)
        if kill -0 $PID > /dev/null 2>&1; then
            kill -SIGTERM $PID
            rm web-app/vite_app.pid
            echo "Vite app stopped."
        else
            echo "Vite app does not seem to be running."
            rm web-app/vite_app.pid
        fi
    else
        echo "Vite app PID file not found. Is the app running?"
    fi
}


# Function to run fake Arduino script
run_fake_arduino() {
    echo -e "${GREEN}Running fake Arduino script...${NO_COLOR}"
    ./scripts/fake_arduino.sh
}

# Function to install packages using package-manager.sh
install_packages() {
    echo -e "${GREEN}Installing packages using package-manager.sh...${NO_COLOR}"
    ./package-manager.sh
}

# Update the show_help function with the new command
show_help() {
    echo -e "${CYAN}Usage: $(basename "$0") [option]"
    echo "Options:"
    echo "  help                 Show this help message"
    echo "  start-docker-compose Start Docker Compose services"
    echo "  stop-docker-compose  Stop Docker Compose services"
    echo "  run-node-server      Run Node server"
    echo "  stop-node-server     Stop Node server"
    echo "  run-vite-app         Start Vite app"
    echo "  stop-vite-app        Stop Vite app"
    echo "  run-fake-arduino     Run fake Arduino script"
    echo "  install-packages     Execute package-manager.sh to install packages"
    echo "  shell                Enter shell mode (interactive commands)${NO_COLOR}"
}

shell_mode() {
    stty -icrnl
    local input=""
    local suggestions=()
    local commands=("help" "start-docker-compose" "stop-docker-compose" "run-node-server" "stop-node-server" "run-vite-app" "stop-vite-app" "run-fake-arduino" "install-packages" "exit")

    cleanup() {
        stty icrnl
    }
    trap cleanup EXIT
    update_suggestions() {
        suggestions=()
        for i in "${commands[@]}"; do
            if [[ "$i" == "$input"* ]]; then
                suggestions+=("$i")
            fi
        done
    }
    display_state() {
        clear
        printf "${CYAN}project-manager> ${NO_COLOR}${input}\n"
        for suggestion in "${suggestions[@]}"; do
            printf "   --- $suggestion\n"
        done
    }
    while true; do
        display_state
        IFS= read -r -n1 -s char
        case $char in
            $'\x0a'|$'\x0d'|$'\x00')
                if [[ " ${commands[@]} " =~ " ${input} " ]]; then
                    case $input in
                        help) show_help ;;
                        start-docker-compose) start_docker_compose ;;
                        stop-docker-compose) stop_docker_compose ;;
                        run-node-server) run_node_server ;;
                        stop-node-server) stop_node_server ;;
                        run-vite-app) run_vite_app ;;
                        stop-vite-app) stop_vite_app ;;
                        run-fake-arduino) run_fake_arduino ;;
                        install-packages) install_packages ;;
                        exit) break ;;
                        *) printf "${RED}Unknown command: $input.${NO_COLOR}\n" ;;
                    esac
                fi
                input=""
                ;;
            $'\x7f')
                input="${input%?}"
                ;;
            $'\x09')
                [[ ${#suggestions[@]} -gt 0 ]] && input="${suggestions[0]}"
                ;;
            $'\x20')
                input+=" "
                ;;
            *)
                input+="$char"
                ;;
        esac
        update_suggestions
    done
}

# Main script logic enhanced for color and shell mode
if [ $# -eq 0 ]; then
    show_help
    shell_mode
else
    case $1 in
        help) show_help ;;
        start-docker-compose) start_docker_compose ;;
        stop-docker-compose) stop_docker_compose ;;
        run-node-server) run_node_server ;;
        stop-node-server) stop_node_server ;;
        run-vite-app) run_vite_app ;;
        stop-vite-app) stop_vite_app ;;
        run-fake-arduino) run_fake_arduino ;;
        install-packages) install_packages ;;
        shell) shell_mode ;;
        *) echo -e "${RED}Invalid option: $1. Type '$0 help' for a list of commands.${NO_COLOR}" ;;
    esac
fi

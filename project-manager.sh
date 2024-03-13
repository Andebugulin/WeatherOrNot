#!/bin/bash

# Function to start docker-compose services
start_docker_compose() {
    echo "Starting docker-compose services..."
    cd server/ || exit
    docker-compose up -d
    cd - || exit
}

# Function to run the node server
run_node_server() {
    echo "Running node server..."
    cd web-app/ || exit
    node src/server.js
    cd - || exit
}

# Function to run Vite app
run_vite_app() {
    echo "Starting Vite app..."
    cd web-app/ || exit
    npm run dev
    cd - || exit
}

# Function to run fake Arduino script
run_fake_arduino() {
    echo "Running fake Arduino script..."
    ./scripts/fake_arduino.sh
}

# Display help
show_help() {
    echo "Usage: $(basename "$0") [option]"
    echo "Options:"
    echo "  help                 Show this help message"
    echo "  start-docker-compose Start Docker Compose services"
    echo "  run-node-server      Run Node server"
    echo "  run-vite-app         Start Vite app"
    echo "  run-fake-arduino     Run fake Arduino script"
    echo "  shell                Enter shell mode (interactive commands)"
}

# Interactive shell mode
shell_mode() {
    echo "Entering shell mode. Type 'exit' to quit."
    while true; do
        read -rp "project-manager> " cmd
        case $cmd in
            help) show_help ;;
            start-docker-compose) start_docker_compose ;;
            run-node-server) run_node_server ;;
            run-vite-app) run_vite_app ;;
            run-fake-arduino) run_fake_arduino ;;
            exit) break ;;
            *) echo "Unknown command: $cmd. Type 'help' for a list of commands." ;;
        esac
    done
}

# Main script logic
if [ $# -eq 0 ]; then
    shell_mode
else
    case $1 in
        help) show_help ;;
        start-docker-compose) start_docker_compose ;;
        run-node-server) run_node_server ;;
        run-vite-app) run_vite_app ;;
        run-fake-arduino) run_fake_arduino ;;
        shell) shell_mode ;;
        *) echo "Invalid option: $1. Type '$0 help' for a list of commands." ;;
    esac
fi

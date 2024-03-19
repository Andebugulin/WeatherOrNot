#!/bin/bash

# Add color codes for easier readability
GREEN="\033[32m"
RED="\033[31m"
CYAN="\033[36m"

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

shell_mode() {
    # Disable input carriage return to newline translation
    stty -icrnl

    local input=""
    local suggestions=()
    local commands=("help" "start-docker-compose" "stop-docker-compose" "run-node-server" "run-vite-app" "run-fake-arduino" "exit")

    # Cleanup function to re-enable icrnl on script exit
    cleanup() {
        # Re-enable input carriage return to newline translation
        stty icrnl
    }

    # Register cleanup to run on script exit
    trap cleanup EXIT
    # Function to update suggestions based on current input
    update_suggestions() {
        suggestions=()
        for i in "${commands[@]}"; do
            if [[ "$i" == "$input"* ]]; then
                suggestions+=("$i")
            fi
        done
        
    }

    # Function to clear the screen and display the current state
    display_state() {
        clear
          # Clears the terminal screen
        printf "${CYAN}project-manager> ${NO_COLOR}${input}\n"
        for suggestion in "${suggestions[@]}"; do
            printf "   --- $suggestion\n"
        done
        
    }

    # Main loop to process input
    while true; do
        display_state  # Display initial state

        # Read user input (one character at a time)
        IFS= read -r -n1 -s char
        
        printf "Char: '%s', ASCII: %x\n" "$char" "'$char"
        case $char in
               $'\x0a'|$'\x0d'|$'\x00')  # Enter key
                
                if [[ " ${commands[@]} " =~ " ${input} " ]]; then
                    
                    # Execute the command if it's exactly one of the options
                    case $input in
                        help) show_help ;;
                        start-docker-compose) start_docker_compose ;;
                        stop-docker-compose) stop_docker_compose ;;
                        run-node-server) run_node_server ;;
                        run-vite-app) run_vite_app ;;
                        run-fake-arduino) run_fake_arduino ;;
                        exit)
                            
                            break  # Exit the loop
                            ;;
                        *)
                            printf "${RED}Unknown command: $input.${NO_COLOR}\n"
                            ;;
                    esac
                fi
                    
                
                input=""  # Reset input after executing a command
                ;;
            $'\x7f')  # Backspace
                
                input="${input%?}"  # Remove the last character from input
                ;;
            $'\x09')  # Tab key
                
                [[ ${#suggestions[@]} -gt 0 ]] && input="${suggestions[0]}"  # Autocomplete the first suggestion
                ;;
            $'\x20')  # Space
                
                input+=" "  # Append space to input
                ;;
            *)
                
                input+="$char"  # Append character to input
                ;;
        esac

        update_suggestions  # Update suggestions based on new input
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


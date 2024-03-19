# WeatherOrNot
---

## Structure
```          
your-project-name/
│
├── firmware/                 # All microcontroller-related code
│   ├── src/                  
│   │   ├── <something.ino>   # main firmware
│   │  
│   ├── lib/                  # External libraries
│
├── server/                  
│   ├── Dockerfile            # Dockerfile for server environment
│   ├── docker-compose.yml    # Docker compose file to manage services
│   └── app/                  
│       ├── mqtt/             # MQTT broker setup
│       └── database/         # Database scripts
│           ├── models/       
│           └── migrations/   
│
├── web-app/                  # web for end-users
│   ├── src/                  
│   │   ├── components/       
│   │   ├── services/        
│   │   └── hooks/            
│   ├── index.html            
│   ├── vite.config.js        # Vite configuration file
│   └── package.json          # NPM package file
│
└── scripts/                  # Utility scripts (testing scripts or deployment)
```

# Project Overview

This project sets up a real-time temperature monitoring system using an ESP32 microcontroller and a DHT11 sensor. It publishes temperature data to an MQTT broker, which can then be consumed by a web application for real-time visualization. Designed for hobbyists and developers interested in IoT applications, this project includes a comprehensive script to manage the entire setup process, making it extremely user-friendly.

## Prerequisites

### Hardware (optional for testing):
- ESP32 microcontroller
- DHT11 temperature and humidity sensor

### Software:
- Arduino IDE or PlatformIO for ESP32 firmware development
- Docker for running the MQTT broker
- Node.js and npm for the web application
- An MQTT Broker (Eclipse Mosquitto or any MQTT broker)

## Installation

### Setting Up the MQTT Broker
1. Navigate to the `server` directory.
2. Run `docker-compose up -d` to start the Mosquitto MQTT broker.

### Configuring the ESP32 (optional for testing)
1. Open the Arduino IDE or PlatformIO.
2. Load the provided firmware code for reading temperature data.
3. Adjust the WiFi and MQTT server settings in the code to match your environment.
4. Upload the firmware to the ESP32.
5. Alternatively, you can simulate ESP32 measurements for testing with the command `./scripts/fake_arduino.sh`.

### Running the Web Application
1. Navigate to the `web-app` directory.
2. Run `npm install` to install dependencies.
3. Start the server that subscribes to MQTT with `npm run start-server`.
4. Start the application with `npm run dev`.
5. For convenience, after installing npm, you can run the server and start the app concurrently using `npm start`.

## Script Usage

This project includes a bash script `project-manager.sh` to easily manage all the components:

- **Start Docker Compose Services:** `./project-manager.sh start-docker-compose`
- **Stop Docker Compose Services:** `./project-manager.sh stop-docker-compose`
- **Run Node Server:** `./project-manager.sh run-node-server`
- **Start Vite App:** `./project-manager.sh run-vite-app`
- **Run Fake Arduino Script:** `./project-manager.sh run-fake-arduino`
- **Enter Shell Mode:** `./project-manager.sh shell` for interactive commands.

### Shell Mode
Shell mode offers an interactive way to execute commands. Type part of a command and press TAB to auto-complete based on available suggestions.

## Troubleshooting

- **MQTT Broker Connection Issues:** Ensure the MQTT broker is running and accessible. Check the IP address and port configurations in both the ESP32 firmware and the web application.
- **Temperature Data Not Updating:** Verify that the ESP32 is correctly connected to the WiFi and that the MQTT topic matches between the publisher (ESP32) and subscriber (web app).

## Contributing

We welcome contributions! If you'd like to help improve the project, please fork the repository and submit a pull request with your changes.


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

This project sets up a real-time temperature monitoring system using an ESP32 microcontroller and a DHT11 sensor. The system publishes temperature data to an MQTT broker, which then can be consumed by a web application for real-time visualization. Designed for hobbyists and developers interested in IoT applications.

# Prerequisites

- Hardware(for testing can be omitted):
  - ESP32 microcontroller
  - DHT11 temperature and humidity sensor
- Software:
  - Arduino IDE or PlatformIO for ESP32 firmware development
  - Docker for running the MQTT broker
  - Node.js and npm for the web application
- MQTT Broker:
  - Eclipse Mosquitto or any MQTT broker


# Installation

## Setting Up the MQTT Broker

1. Navigate to the `server` directory.
2. Run `docker-compose up -d` to start the Mosquitto MQTT broker.

   - If you want to verify MQTT broker setup see: [Verify MQTT broker Guide](server/)

## Configuring the ESP32 (for testing it is possible to fake it)

1. Open the Arduino IDE or PlatformIO.
2. Load the provided firmware code for reading temperature data.
3. Adjust the WiFi and MQTT server settings in the code to match your environment.
4. Upload the firmware to the ESP32.

---

## fake esp32 measurements for testing by command

run generating temperature script:
```bash
./scripts/fake_arduino.sh
```

This simulates publishing temperature data to `esp32/temperature` on your MQTT broker.

To observe the data:
```bash
mosquitto_sub -h 127.0.0.1 -t esp32/temperature
```

---

## Running the Web Application

1. Navigate to the `web-app` directory.
2. Run `npm install` to install dependencies.
3. Run server that is subscribed to MQTT with `npm run start-server`
4. Start the application with `npm run dev`.

   * If you are lazy, after installing npm, you can run server and start app it concurrently using `npm start`


# Usage

1. The ESP32 reads temperature data every X seconds and publishes it to the MQTT broker under the topic `esp32/temperature`.
2. The web application subscribes to the `esp32/temperature` topic and updates the temperature visualization in real-time.


# Troubleshooting

- **MQTT Broker Connection Issues**: Ensure the MQTT broker is running and accessible. Check the IP address and port configurations in both the ESP32 firmware and the web application.
- **Temperature Data Not Updating**: Verify that the ESP32 is correctly connected to the WiFi and that the MQTT topic matches between the publisher (ESP32) and subscriber (web app).


--- 

# Contributing

We welcome contributions! If you'd like to help improve the project, please fork the repository and submit a pull request with your changes.




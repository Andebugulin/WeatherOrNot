
# ESP32 Temperature and Humidity Sensor

This Arduino project enables an ESP32 to measure temperature and humidity using a DHT11 sensor and publish the data to an MQTT server. It's perfect for home automation projects, weather stations, or any scenario where monitoring environmental conditions is crucial.

## Features

- **WiFi Connectivity:** Connects your ESP32 to the internet via WiFi.
- **MQTT Publishing:** Sends temperature and humidity data to an MQTT server.
- **Sliding Average Calculation:** Calculates the average temperature and humidity from the last five measurements to smooth out the data.
- **Dynamic Memory Allocation:** Uses linked lists for flexible data management.

## Prerequisites

Before you start, make sure you have the following:
- An ESP32 module.
- A DHT11 temperature and humidity sensor.
- An MQTT broker/server setup (like Mosquitto).
- The Arduino IDE with the ESP32 board definitions installed.

## Required Libraries

- `WiFi.h` - for connecting the ESP32 to the internet.
- `PubSubClient.h` - for MQTT communication.
- `DHT.h` - for interfacing with the DHT sensor.

## Wiring Instructions

1. Connect the DHT11 sensor's VCC to the ESP32's 5V.
2. Connect the DHT11 sensor's GND to the ESP32's GND.
3. Connect the DHT11 sensor's DATA to the ESP32's GPIO 4.

## Configuration

1. Open the Arduino code in your IDE.
2. Replace `"YOUR SSID"`, `"YOUR PASSWORD"`, and `"YOUR IP"` with your WiFi SSID, password, and MQTT server IP address, respectively.
3. Adjust the `amountOfMeasurements` variable if you want to change how many measurements are considered for the sliding average calculation.

## Uploading the Code

1. Connect your ESP32 to your computer.
2. Select the appropriate board and port in the Arduino IDE.
3. Click on the upload button to transfer the code to your ESP32.

## Monitoring the Output

Open the Arduino IDE's Serial Monitor to view the live temperature and humidity readings, along with their averages. You should also see the data being published to the MQTT topics `esp32/temperature` and `esp32/humidity`.

## Customizing the Project

Feel free to tweak the code to fit your specific needs. This could include changing the measurement interval, modifying the MQTT topics, or integrating with other sensors and services.


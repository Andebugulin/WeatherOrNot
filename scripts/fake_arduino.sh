#!/bin/bash

# MQTT broker settings
mqtt_server="127.0.0.1"  # localhost if the script is run on the same machine
mqtt_port="1883"  # Default MQTT port
mqtt_topic="esp32/temperature"  # MQTT topic to publish to
mqtt_client_id="fake_arduino"  # Client ID for MQTT connection


echo "WiFi connected"
echo "Connected to MQTT"

# Initialize dummy measurements array and counter
amountOfMeasurements=5
measurements=(0 0 0 0 0)
measurementCounter=0

# Add a simulated measurement
function addMeasurement {
  local temperature=$1
  measurements[$measurementCounter]=$temperature
  measurementCounter=$(( (measurementCounter + 1) % amountOfMeasurements ))
}

# Calculate average of measurements
function calculateAverage {
  local total=0
  for temp in "${measurements[@]}"; do
    total=$(awk -v total="$total" -v temp="$temp" 'BEGIN { print total + temp }')
  done
  echo $(awk -v total="$total" -v count="$amountOfMeasurements" 'BEGIN { print total / count }')
}

# Main simulation loop
while true; do
  # Generate a simulated temperature reading (let's say between 20 and 30 degrees)
  measuredTemp=$(awk -v min=20 -v max=30 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
  echo ""
  echo "Simulated Temperature: $measuredTemp°C"
  
  # Add measurement and calculate average
  addMeasurement $measuredTemp
  averageTemp=$(calculateAverage)
  
  # Prepare the average temperature as a string with two decimal places
  printf -v tempString "%.2f" $averageTemp
  echo "Publishing Average Temp (simulated): $tempString°C to MQTT topic '$mqtt_topic'"
  
  # Publish the simulated average temperature to the MQTT broker
  mosquitto_pub -h "$mqtt_server" -p "$mqtt_port" -t "$mqtt_topic" -m "$tempString" -i "$mqtt_client_id"
  
  # Sleep for a bit before next loop iteration
  sleep 1
done 

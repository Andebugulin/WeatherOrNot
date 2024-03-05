#!/bin/bash


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
  
  # Simulate publishing to MQTT
  printf -v tempString "%.2f" $averageTemp
  echo "Publishing Average Temp (simulated): $tempString°C to MQTT topic 'esp32/temperature'"
  
  # Sleep for a bit before next loop iteration
  sleep 1
done
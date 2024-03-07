#!/bin/bash


mqtt_server="127.0.0.1"  
mqtt_port="1883"  
mqtt_topic_temperature="esp32/temperature"  
mqtt_topic_humidity="esp32/humidity"  
mqtt_client_id="fake_arduino"  


echo "WiFi connected"
echo "Connected to MQTT"


amountOfMeasurements=5
temperatureMeasurements=(0 0 0 0 0)
humidityMeasurements=(0 0 0 0 0)
measurementCounter=0


function addTemperatureMeasurement {
  local temperature=$1
  temperatureMeasurements[$measurementCounter]=$temperature
}


function addHumidityMeasurement {
  local humidity=$1
  humidityMeasurements[$measurementCounter]=$humidity
  measurementCounter=$(( (measurementCounter + 1) % amountOfMeasurements ))
}


function calculateTemperatureAverage {
  local total=0
  for temp in "${temperatureMeasurements[@]}"; do
    total=$(awk -v total="$total" -v temp="$temp" 'BEGIN { print total + temp }')
  done
  echo $(awk -v total="$total" -v count="$amountOfMeasurements" 'BEGIN { print total / count }')
}


function calculateHumidityAverage {
  local total=0
  for humidity in "${humidityMeasurements[@]}"; do
    total=$(awk -v total="$total" -v humidity="$humidity" 'BEGIN { print total + humidity }')
  done
  echo $(awk -v total="$total" -v count="$amountOfMeasurements" 'BEGIN { print total / count }')
}


while true; do
  
  measuredTemp=$(awk -v min=20 -v max=30 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
  
  measuredHumidity=$(awk -v min=30 -v max=60 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
  
  echo ""
  echo "Simulated Temperature: $measuredTemp°C"
  echo "Simulated Humidity: $measuredHumidity%"
  
  
  addTemperatureMeasurement $measuredTemp
  addHumidityMeasurement $measuredHumidity
  averageTemp=$(calculateTemperatureAverage)
  averageHumidity=$(calculateHumidityAverage)
  
  
  printf -v tempString "%.2f" $averageTemp
  printf -v humidityString "%.2f" $averageHumidity
  echo "Publishing Average Temp (simulated): $tempString°C to MQTT topic '$mqtt_topic_temperature'"
  echo "Publishing Average Humidity (simulated): $humidityString% to MQTT topic '$mqtt_topic_humidity'"
  
  # Publish the simulated average temperature and humidity to the MQTT broker
  mosquitto_pub -h "$mqtt_server" -p "$mqtt_port" -t "$mqtt_topic_temperature" -m "$tempString" -i "$mqtt_client_id"
  mosquitto_pub -h "$mqtt_server" -p "$mqtt_port" -t "$mqtt_topic_humidity" -m "$humidityString" -i "$mqtt_client_id"
  
  
  sleep 1
done

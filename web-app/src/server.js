import express from 'express';
import cors from 'cors';
import mqtt from 'mqtt';
import { createServer } from 'http';

const app = express();
const PORT = 3000;
let latestTemperature = ''; // Store the latest temperature
let latestHumidity = ''; // Store the latest humidity

// Enable CORS for all routes
app.use(cors());

// Serve static files from 'public' directory
app.use(express.static('public'));

// Route to get the latest temperature
app.get('/temperature', (req, res) => {
  res.json({ temperature: latestTemperature });
});

// Route to get the latest humidity
app.get('/humidity', (req, res) => {
  res.json({ humidity: latestHumidity });
});

const server = createServer(app);

server.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));

// MQTT setup
const mqttClient = mqtt.connect('mqtt://127.0.0.1');

mqttClient.on('connect', () => {
  console.log('Connected to MQTT Broker');
  // Subscribe to both temperature and humidity topics
  mqttClient.subscribe(['esp32/temperature', 'esp32/humidity'], () => {
    console.log('Subscribed to esp32/temperature and esp32/humidity');
  });
});

mqttClient.on('message', (topic, message) => {
  // Update the latest temperature or humidity based on the topic
  if (topic === 'esp32/temperature') {
    latestTemperature = message.toString();
  } else if (topic === 'esp32/humidity') {
    latestHumidity = message.toString();
  }
});

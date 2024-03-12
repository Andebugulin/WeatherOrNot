import express from 'express';
import cors from 'cors';
import mqtt from 'mqtt';
import { createServer } from 'http';
import mongoose from 'mongoose';
import { SensorData } from '../../server/database/models/SensorData.js';

mongoose.connect('mongodb://root:example@localhost:27017/sensors', { // connect to mongodb with username root and password as example
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

mongoose.connection.on('error', console.error.bind(console, 'MongoDB connection error:'));


const app = express();
const PORT = 3000;
let latestTemperature = ''; // Store the latest temperature
let latestHumidity = ''; // Store the latest humidity

// Enable CORS for all routes
app.use(cors());

// Serve static files from 'public' directory
app.use(express.static('public'));

// Route to get the latest temperature
app.get('/temperature', async (req, res) => {
  const latestTemp = await SensorData.findOne({ type: 'temperature' }).sort({ timestamp: -1 }).exec();
  res.json({ temperature: latestTemp ? latestTemp.value : 'No data' });
});

// Route to get the latest humidity
app.get('/humidity', async (req, res) => {
  const latestHumid = await SensorData.findOne({ type: 'humidity' }).sort({ timestamp: -1 }).exec();
  res.json({ humidity: latestHumid ? latestHumid.value : 'No data' });
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

mqttClient.on('message', async (topic, message) => {
  let type;
  if (topic === 'esp32/temperature') {
    type = 'temperature';
    latestTemperature = message.toString();
  } else if (topic === 'esp32/humidity') {
    type = 'humidity';
    latestHumidity = message.toString();
  }

  // Save the new sensor data to MongoDB
  try {
    const sensorData = new SensorData({
      type,
      value: message.toString(),
    });
    await sensorData.save();
    console.log(`Saved ${type} data to MongoDB.`);
  } catch (error) {
    console.error('Error saving data to MongoDB:', error);
  }
});


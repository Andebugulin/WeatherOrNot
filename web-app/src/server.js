import express from 'express';
import cors from 'cors';
import mqtt from 'mqtt';
import { createServer } from 'http';
import { MongoClient } from 'mongodb';

const app = express();
const PORT = 3000;
let db;

// MongoDB setup
const MONGO_URI = 'mongodb://root:example@localhost:27017/sensors?authSource=admin';
const dbName = 'sensors';

// Connect to MongoDB
const connectToMongoDB = async () => {
  const client = new MongoClient(MONGO_URI);
  try {
    await client.connect();
    console.log('Connected to MongoDB');
    db = client.db(dbName);
  } catch (err) {
    console.error('Failed to connect to MongoDB:', err);
  }
};

// MQTT setup
const mqttClient = mqtt.connect('mqtt://127.0.0.1');

mqttClient.on('connect', () => {
  console.log('Connected to MQTT Broker');
  mqttClient.subscribe(['esp32/temperature', 'esp32/humidity'], () => {
    console.log('Subscribed to esp32/temperature and esp32/humidity');
  });
});

mqttClient.on('message', async (topic, message) => {
  console.log(`Message received on topic ${topic}: ${message}`);
  let type = topic.split('/').pop(); // Assuming the type is the last part of the topic

  try {
    const collection = db.collection('SensorData'); // This should match your collection name
    const document = { type, value: message.toString(), timestamp: new Date() };
    await collection.insertOne(document);
    console.log(`Saved ${type} data to MongoDB.`);
  } catch (error) {
    console.error('Error saving data to MongoDB:', error);
  }
});

// Enable CORS for all routes
app.use(cors());

// Serve static files from 'public' directory
app.use(express.static('public'));

// Route to get the latest temperature
app.get('/temperature', async (req, res) => {
  const latestTemp = await db.collection('SensorData').findOne({ type: 'temperature' }, { sort: { timestamp: -1 } });
  res.json({ temperature: latestTemp ? latestTemp.value : 'No data' });
});

// Route to get the latest humidity
app.get('/humidity', async (req, res) => {
  const latestHumid = await db.collection('SensorData').findOne({ type: 'humidity' }, { sort: { timestamp: -1 } });
  res.json({ humidity: latestHumid ? latestHumid.value : 'No data' });
});

const server = createServer(app);

connectToMongoDB().then(() => {
  server.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
}).catch(console.error);

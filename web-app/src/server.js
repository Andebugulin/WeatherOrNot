// typical express set up.
import express from 'express';
import { WebSocketServer, WebSocket } from 'ws';
import mqtt from 'mqtt';
import { createServer } from 'http';

const app = express();
const PORT = 3000;

// Serve static files from 'public' directory
app.use(express.static('public'));

const server = createServer(app);

server.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));

// WebSocket Server setup
const wss = new WebSocketServer({ server });

wss.on('connection', function connection(ws) {
  console.log('A new client connected');
  ws.on('message', function incoming(message) {
    console.log('received: %s', message);
  });
});

// MQTT setup
const mqttClient = mqtt.connect('mqtt://127.0.0.1');

mqttClient.on('connect', () => {
  console.log('Connected to MQTT Broker');
  mqttClient.subscribe('esp32/temperature', () => {
    console.log('Subscribed to esp32/temperature');
  });
});

mqttClient.on('message', (topic, message) => {
  // Broadcast to all connected WebSocket clients
  wss.clients.forEach(function each(client) {
    if (client.readyState === WebSocket.OPEN) {
      client.send(message.toString());
    }
  });
});


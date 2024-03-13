import mongoose from 'mongoose';

const { Schema, model } = mongoose;

// Sensor data schema
const sensorDataSchema = new Schema({
  type: { type: String, required: true }, // 'temperature' or 'humidity'
  value: { type: String, required: true },
  timestamp: { type: Date, default: Date.now },
});

// Create models for temperature and humidity data
const SensorData = model('SensorData', sensorDataSchema);

export { SensorData };

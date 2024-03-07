import React from 'react';

const WeatherBox = ({ temperature, humidity }) => (
  <div className="box">
    <p>
      <h2>Average Temperature</h2>
      <span>{temperature}°C</span>
      <br />
      <h2>Humidity</h2> 
      <span>{humidity}%</span>
    </p>
  </div>
);

export default WeatherBox;

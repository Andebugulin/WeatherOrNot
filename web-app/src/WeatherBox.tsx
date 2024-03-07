import React from 'react';

const WeatherBox = ({ temperature, humidity }) => (
  <div className="box">
    <div className="top">
      <h2>Temperature</h2>
      <h2>Humidity</h2> 
      </div>
      <div className="bottom">
      <span>{temperature}°C</span>
      <span>{humidity}%</span>
    </div>
  </div>
);

export default WeatherBox;

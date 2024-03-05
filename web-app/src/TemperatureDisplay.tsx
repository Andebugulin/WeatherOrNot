import React, { useState, useEffect } from 'react';

const TemperatureDisplay = () => {
  const [temperature, setTemperature] = useState('Loading...');

  useEffect(() => {
    const fetchTemperature = () => {
      fetch('http://localhost:3000/temperature')
        .then((response) => response.json())
        .then((data) => setTemperature(data.temperature))
        .catch((error) => console.error('Error fetching temperature:', error));
    };

    // Set up an interval to fetch the temperature every 1 second (1000 milliseconds)
    const intervalId = setInterval(fetchTemperature, 1000);

    // Fetch temperature immediately on component mount, then on interval
    fetchTemperature();

    // Clear the interval when the component is unmounted
    return () => clearInterval(intervalId);
  }, []);

  return <div>Current Temperature: {temperature} °C</div>;
};

export default TemperatureDisplay;

import React, { useEffect, useState } from 'react';
import TemperatureDisplay from './TemperatureDisplay';
import WeatherBox from './WeatherBox';

const App: React.FC = () => {
  const [temperature, setTemperature] = useState('Loading...');
  const [humidity, setHumidity] = useState('Loading...');

  useEffect(() => {
    const fetchTemperature = () => {
      fetch('http://localhost:3000/temperature')
        .then((response) => response.json())
        .then((data) => setTemperature(data.temperature))
        .catch((error) => console.error('Error fetching temperature:', error));
    };

    const fetchHumidity = () => {
      fetch('http://localhost:3000/humidity')
        .then((response) => response.json())
        .then((data) => setHumidity(data.humidity))
        .catch((error) => console.error('Error fetching humidity:', error));
    }


    const intervalId = setInterval(fetchTemperature, 1000);
    const intervalId2 = setInterval(fetchHumidity, 1000);
    
    fetchTemperature();
    fetchHumidity();
    
    return () => {clearInterval(intervalId); clearInterval(intervalId2)};
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <h1>WeatherOrNot</h1>
        <h3>Current Location</h3>
        <WeatherBox temperature={temperature} humidity={humidity} />
        <h3>Mikkeli</h3>
        <WeatherBox temperature={temperature} humidity={humidity} />
      </header>
    </div>
  );
};

export default App;

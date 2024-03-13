import React, { useEffect, useState } from 'react';
import TemperatureDisplay from './TemperatureDisplay';
import WeatherBox from './WeatherBox';

const App: React.FC = () => {
  const [temperature, setTemperature] = useState('Loading...');
  const [humidity, setHumidity] = useState('Loading...');
  const [locationTemperature, setlocationTemperature] = useState('Loading...');
  const [locationHumidity, setlocationHumidity] = useState('Loading...');


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

    const fetchLocationWeather = () => {
      fetch('https://api.open-meteo.com/v1/forecast?latitude=61.6875&longitude=27.2736&hourly=temperature_2m,relative_humidity_2m&past_days=1')
        .then((response) => response.json())
        .then((data) => {
          const locationForecast = data.hourly; 
          setlocationTemperature(locationForecast.temperature_2m[0]); 
          setlocationHumidity(locationForecast.relative_humidity_2m[0]);
        })
        .catch((error) => console.error('Error fetching the weather data:', error));
    };


    const intervalId = setInterval(fetchTemperature, 1000);
    const intervalId2 = setInterval(fetchHumidity, 1000);
    
    fetchTemperature();
    fetchHumidity();
    fetchLocationWeather();

    return () => {clearInterval(intervalId); clearInterval(intervalId2)};
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <h1>WeatherOrNot</h1>
        <h3>Current Location</h3>
        <WeatherBox temperature={temperature} humidity={humidity} />
        <h3>Mikkeli (Avg. 24h)</h3>
        <WeatherBox temperature={locationTemperature} humidity={locationHumidity} />
      </header>
    </div>
  );
};

export default App;

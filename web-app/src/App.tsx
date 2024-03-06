import React from 'react';
import TemperatureDisplay from './TemperatureDisplay';
import WeatherBox from './WeatherBox';

const App: React.FC = () => {
  // Fetch the weather data here...
  const temperature = '22.00'; // Replace with actual data later
  const humidity = '78.00'; // Replace this with data later

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

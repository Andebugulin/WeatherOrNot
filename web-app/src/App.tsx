import React from 'react';
import TemperatureDisplay from './TemperatureDisplay';

const App: React.FC = () => {
  return (
    <div className="App">
      <header className="App-header">
        <h1>Real-Time Temperature Monitor</h1>
      </header>
      <main>
        <TemperatureDisplay />
      </main>
    </div>
  );
};

export default App;

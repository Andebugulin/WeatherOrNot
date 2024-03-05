# WeatherOrNot
---

## Structure
```
your-project-name/
│
├── firmware/                 # All microcontroller-related code
│   ├── src/                  # Source files for ESP32
│   │   ├── main.cpp          # Main firmware source file
│   │   └── DHTSensor/        # DHT sensor handling
│   ├── lib/                  # External libraries
│   └── platformio.ini        # Configuration file for PlatformIO
│
├── server/                   # Server-side code
│   ├── Dockerfile            # Dockerfile for server environment
│   ├── docker-compose.yml    # Docker compose file to manage services
│   └── app/                  # Application source code
│       ├── mqtt/             # MQTT broker setup
│       └── database/         # Database scripts
│           ├── models/       # Database models
│           └── migrations/   # Database migration files
│
├── web-app/                  # Web application for end-users
│   ├── src/                  # Vite/React application source files
│   │   ├── components/       # React components
│   │   ├── services/         # Services for backend communication
│   │   └── hooks/            # React hooks
│   ├── index.html            # Entry HTML file
│   ├── vite.config.js        # Vite configuration file
│   └── package.json          # NPM package file
│
└── scripts/                  # Utility scripts
```

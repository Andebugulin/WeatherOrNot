# WeatherOrNot
---

## Structure
```
your-project-name/
│
├── firmware/                 # All microcontroller-related code
│   ├── src/                  # Source files for ESP32
│   │   ├── <something.ino>         # Main firmware source file
│   │  
│   ├── lib/                  # External libraries
│
├── server/                   # Server-side code
│   ├── Dockerfile            # Dockerfile for server environment
│   ├── docker-compose.yml    # Docker compose file to manage services
│   └── app/                  
│       ├── mqtt/             # MQTT broker setup
│       └── database/         # Database scripts
│           ├── models/       
│           └── migrations/   
│
├── web-app/                  # Web application for end-users
│   ├── src/                  
│   │   ├── components/       
│   │   ├── services/        
│   │   └── hooks/            # React hooks
your-project-name/
│
├── firmware/                 # All microcontroller-related code
│   ├── src/                  # Source files for ESP32
│   │   ├── <something.ino>         # Main firmware source file
│   │  
│   ├── lib/                  # External libraries
│
├── server/                   # Server-side code
│   ├── Dockerfile            # Dockerfile for server environment
│   ├── docker-compose.yml    # Docker compose file to manage services
│   └── app/                  
│       ├── mqtt/             # MQTT broker setup
│       └── database/         # Database scripts
│           ├── models/       
│           └── migrations/   
│
├── web-app/                  # Web application for end-users
│   ├── src/                  
│   │   ├── components/       
│   │   ├── services/        
│   │   └── hooks/            
│   ├── index.html            
│   ├── vite.config.js        # Vite configuration file
│   └── package.json          # NPM package file
│
└── scripts/                  # Utility scripts (testing scripts or deployment)
```

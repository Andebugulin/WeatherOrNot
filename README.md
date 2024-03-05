# WeatherOrNot
---

## Structure
```          
your-project-name/
│
├── firmware/                 # All microcontroller-related code
│   ├── src/                  
│   │   ├── <something.ino>   # main firmware
│   │  
│   ├── lib/                  # External libraries
│
├── server/                  
│   ├── Dockerfile            # Dockerfile for server environment
│   ├── docker-compose.yml    # Docker compose file to manage services
│   └── app/                  
│       ├── mqtt/             # MQTT broker setup
│       └── database/         # Database scripts
│           ├── models/       
│           └── migrations/   
│
├── web-app/                  # web for end-users
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

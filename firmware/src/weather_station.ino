#include <WiFi.h>
#include <PubSubClient.h>
#include <DHT.h>

const char* ssid = "YOUR SSID";
const char* password = "YOUR PASSWORD";
const char* mqtt_server = "YOUR IP";

WiFiClient espClient;
PubSubClient mqttClient(espClient);

#define DHTPIN 4
#define DHTTYPE DHT11 

DHT dht(DHTPIN, DHTTYPE);

int amountOfMeasurements = 5;
int measurementCounter = 0;

struct measurement {
  float temperature;
  float humidity; // New humidity field
  struct measurement *next;
};

struct measurement *firstMeasurement;
struct measurement *currentMeasurement;

void setup() {
  Serial.begin(115200);
  dht.begin();
  setup_wifi();
  mqttClient.setServer(mqtt_server, 1883);

  firstMeasurement = (struct measurement *) malloc(sizeof(struct measurement));
  firstMeasurement->next = NULL;
  currentMeasurement = firstMeasurement;

  Serial.println("Using linked list for calculating the sliding average.");
}

void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Connecting to WiFi SSID: ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void reconnect() {
  while (!mqttClient.connected()) {
    Serial.print("Attempting MQTT connection...");
    if (mqttClient.connect("ESP32_Client")) {
      Serial.println("connected");
    } 
    else {
      Serial.print("failed, rc=");
      Serial.print(mqttClient.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

void addMeasurement(float temperature, float humidity) {
  currentMeasurement->temperature = temperature;
  currentMeasurement->humidity = humidity; // Store humidity
  measurementCounter += 1;
  if (measurementCounter == amountOfMeasurements) {
    currentMeasurement = firstMeasurement;
    measurementCounter = 0;
  }
  else {
    if (!currentMeasurement->next) {
      struct measurement *nextMeasurement;
      nextMeasurement = (struct measurement *) malloc(sizeof(struct measurement));
      currentMeasurement->next = nextMeasurement;
      currentMeasurement = currentMeasurement->next;
      currentMeasurement->next = NULL;
    }
    else {
      currentMeasurement = currentMeasurement->next;
    }
  }
}

float calculateAverageTemperature() {
  float avgTemp = 0.0;
  struct measurement *avgMeasurement;
  avgMeasurement = firstMeasurement;
  while(avgMeasurement) {
    avgTemp += avgMeasurement->temperature;
    avgMeasurement = avgMeasurement->next;
  }
  avgTemp = avgTemp / amountOfMeasurements;
  return(avgTemp);
}

float calculateAverageHumidity() {
  float avgHumidity = 0.0;
  struct measurement *avgMeasurement;
  avgMeasurement = firstMeasurement;
  while(avgMeasurement) {
    avgHumidity += avgMeasurement->humidity;
    avgMeasurement = avgMeasurement->next;
  }
  avgHumidity = avgHumidity / amountOfMeasurements;
  return(avgHumidity);
}

void loop() {
  if (!mqttClient.connected()) {
    reconnect();
  }

  float measuredTemp = dht.readTemperature();
  float measuredHumidity = dht.readHumidity(); // Read humidity

  Serial.print("Temperature: ");
  Serial.println(measuredTemp);
  Serial.print("Humidity: ");
  Serial.println(measuredHumidity);

  float averageTemp = 0.0;
  float averageHumidity = 0.0;

  addMeasurement(measuredTemp, measuredHumidity); // Add humidity to measurement
  averageTemp = calculateAverageTemperature();
  averageHumidity = calculateAverageHumidity(); // Calculate average humidity

  Serial.println("--------------");
  Serial.print("Average Temperature: ");
  Serial.println(averageTemp);
  Serial.print("Average Humidity: ");
  Serial.println(averageHumidity);
  Serial.println("--------------");
  char tempString[8];
  dtostrf(averageTemp, 1, 2, tempString);
  mqttClient.publish("esp32/temperature", tempString);

  char humidityString[8];
  dtostrf(averageHumidity, 1, 2, humidityString);
  mqttClient.publish("esp32/humidity", humidityString); // Publish humidity

  delay(2000); // Sleep 2 seconds before next measurement
}

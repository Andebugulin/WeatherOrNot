
### Verifying the MQTT Broker Setup

After you've started your MQTT broker using `docker-compose` 
```
docker-compose up -d
```
you can verify that it's working correctly by subscribing to a topic and publishing a message to that topic. Follow these steps to test your setup:

#### Step 1: Check Docker Container

First, ensure that your MQTT broker container is running:

```bash
docker ps
```

Look for the `eclipse-mosquitto` container in the list. If it's running, you should see it listed along with its status.

#### Step 2: Subscribe to a Topic

Open a new terminal window and use the following command to subscribe to the `test/topic` topic:

```bash
mosquitto_sub -h 127.0.0.1 -t test/topic
```

This command will listen for any messages published to `test/topic`.

#### Step 3: Publish a Message

Open another new terminal window and use the following command to publish a "hello" message to the `test/topic` topic:

```bash
mosquitto_pub -h 127.0.0.1 -t test/topic -m "hello"
```

#### Step 4: Verify Message Receipt

Go back to the terminal where you ran the `mosquitto_sub` command. You should see the "hello" message you just published. If you see the message, it confirms that your MQTT broker is set up correctly and can successfully handle publishing and subscribing to topics.

---
Come back to initial README docs: [Main Project Documentation](../README.md)

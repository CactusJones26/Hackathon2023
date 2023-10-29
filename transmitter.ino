#include <EEPROM.h>
#include <SPI.h>
#include "printf.h"
#include "RF24.h"

#define CE_PIN 0
#define CSN_PIN 10
RF24 radio(CE_PIN, CSN_PIN);

uint8_t address[][6] = {"1Node", "2Node", "3Node", "4Node"};

int radioNumber = 0;
bool role = true;
float payload = 0.0;

struct AckData {
  bool ackReceived;
  unsigned long timestamp;
};

struct AckParam {
  float avgAckRate;
};

AckData ackResults[4][10000];
AckParam savedAckParams[10];
int ackIndex[4] = {0, 0, 0, 0};

unsigned long lastPrintTime = 0;
bool isRecording = false;
int savedAckParamsIndex = 0;
float runningAckRate = 0;
int runningAckCount = 0;

void setup() {
  Serial.begin(115200);
  EEPROM.begin();

  for (int i = 0; i < 10; ++i) {
    EEPROM.get(i * sizeof(AckParam), savedAckParams[i]);
  }
  Serial.begin(115200);
  if (!radio.begin()) {
    Serial.println(F("radio hardware is not responding!!"));
    while (1) {}
  }
  Serial.print(F("radioNumber = "));
  Serial.println((int)radioNumber);
  radio.setPALevel(RF24_PA_MIN);
  radio.setPayloadSize(sizeof(payload));
  radio.openWritingPipe(address[radioNumber]);
  if (role) {
    radio.stopListening();
  } else {
    radio.startListening();
  }
  radio.setAutoAck(true);  // Enable auto acknowledgment
}

void loop() {
  // Check for Serial input to start/stop recording
  if (Serial.available() > 0) {
    String command = Serial.readStringUntil('\n');
    if (command == "start") {
      isRecording = true;
      runningAckRate = 0;
      runningAckCount = 0;
      Serial.println("Recording started.");
    } else if (command == "stop") {
      isRecording = false;
      savedAckParams[savedAckParamsIndex].avgAckRate = runningAckRate / runningAckCount;
      savedAckParamsIndex++;
      Serial.println("Recording stopped. Avg Ack Rate saved.");
    }
  }

  if (role) {
    for (int i = 0; i < 4; ++i) {
      radio.openWritingPipe(address[i]);
      bool ackReceived = radio.write(&payload, sizeof(float));

      // Calculate running average of Ack rate while recording
      if (isRecording) {
        runningAckRate = (runningAckRate * runningAckCount + (ackReceived ? 1 : 0)) / (runningAckCount + 1);
        runningAckCount++;
      } else {
        for (int j = 0; j < savedAckParamsIndex; ++j) {
          if (abs((ackReceived ? 1 : 0) - savedAckParams[j].avgAckRate) <= 0.2) {
            // Trigger your action here
            Serial.println("Triggering action.");
          }
        }
      }

      ackResults[i][ackIndex[i]].ackReceived = ackReceived;
      ackResults[i][ackIndex[i]].timestamp = millis();
      ackIndex[i] = (ackIndex[i] + 1) % 10000;
    }
    payload += 0.01;
  }
}

void saveAckParamsToEEPROM() {
  for (int i = 0; i < savedAckParamsIndex; ++i) {
    EEPROM.put(i * sizeof(AckParam), savedAckParams[i]);
  }
}
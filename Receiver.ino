#include <SPI.h>
#include "printf.h"
#include "RF24.h"

#define CE_PIN 0
#define CSN_PIN 10
// instantiate an object for the nRF24L01 transceiver
RF24 radio(CE_PIN, CSN_PIN);

uint8_t myAddress[] = "4Node";  // Replace with the unique address for this receiver

// to use different addresses on a pair of radios, we need a variable to
// uniquely identify which address this radio will use to transmit
int radioNumber = 4; 

// Used to control whether this node is sending or receiving
bool role = false;  // true = TX role, false = RX role

// For this example, we'll be using a payload containing
// a single float number that will be incremented
// on every successful transmission
float payload = 0.00000000000000000000000;

void setup() {

  Serial.begin(115200);


  // initialize the transceiver on the SPI bus
  if (!radio.begin()) {
    Serial.println(F("radio hardware is not responding!!"));
    while (1) {}  // hold in infinite loop
  }

  // To set the radioNumber via the Serial monitor on startup
  Serial.print(F("radioNumber = "));
  Serial.println((int)radioNumber);
  radio.setPALevel(RF24_PA_MIN);
  radio.setPayloadSize(sizeof(payload));
  radio.setAutoAck(true);  // Enable auto acknowledgment

  // set the RX address of the TX node into a RX pipe
  radio.openReadingPipe(1, myAddress);  // No need for negation (!radioNumber)
  radio.startListening();
}

void loop() {
  if (radio.available()) {
    uint8_t payload;
    radio.read(&payload, sizeof(uint8_t));
    Serial.print("Received payload: ");
    Serial.println(payload);
  }
}

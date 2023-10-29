import express from "express";
import Device from "../database/models/device.model.js";
const SerialPort = require('serialport');
const Readline = require('@serialport/parser-readline');


const deviceController = express.Router();

// Replace with your Arduino's serial port name
const port = new SerialPort('/dev/tty-usbserial1', { baudRate: 9600 });

// Create a parser to handle line breaks
const parser = port.pipe(new Readline({ delimiter: '\n' }));

deviceController.use(express.json()); // for parsing application/json

// POST function to turn on the Arduino
deviceController.post('/turn-on', (req, res) => {
  port.write('1', function(err) {
    if (err) {
      return res.status(500).json({ message: "Failed to send data to Arduino: " + err.message });
    }
    res.status(200).json({ message: 'LED turned on successfully.' });
  });
});

deviceController.post('/turn-off', (req, res) => {
    port.write('0', function(err) {
      if (err) {
        return res.status(500).json({ message: "Failed to send data to Arduino: " + err.message });
      }
      res.status(200).json({ message: 'LED turned on successfully.' });
    });
  });

deviceController.post('/start-calibrating', (req, res) => {
    port.write('C', function(err) {
      if (err) {
        return res.status(500).json({ message: "Failed to send calibration command to Arduino: " + err.message });
      }
      res.status(200).json({ message: 'Calibration started successfully.' });
    });
  });

  deviceController.post('/stop-calibrating', (req, res) => {
    port.write('D', function(err) {
      if (err) {
        return res.status(500).json({ message: "Failed to send calibration command to Arduino: " + err.message });
      }
      res.status(200).json({ message: 'Calibration started successfully.' });
    });
  });

export default userController;

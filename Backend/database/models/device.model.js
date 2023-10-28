import mongoose from "mongoose";
const deviceSchema = require('../schemas/device.schema.js');

const Device = mongoose.model('Device', deviceSchema);

export default Device;
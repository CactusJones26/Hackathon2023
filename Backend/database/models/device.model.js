import mongoose from "mongoose";
import deviceSchema from '../schemas/device.schema.js';

const Device = mongoose.model('Device', deviceSchema);

export default Device;
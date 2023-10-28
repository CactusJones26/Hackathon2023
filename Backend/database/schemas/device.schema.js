import { Schema } from 'mongoose';

const deviceSchema = new Schema({
  ip: { type: String, required: true }
});

export default deviceSchema;
import { Schema } from 'mongoose';

const eventSchema = new Schema({
  device: { type: mongoose.ObjectId, required: true },
});

export default eventSchema;
import { Schema } from 'mongoose';

const userSchema = new Schema({
  username: { type: String, required: true },
  email: { type: String, required: true},
  password: { type: String, required: true },
  device: { type: String, required: false},
  loggedIn: { type: Boolean, required: true }
});

export default userSchema;
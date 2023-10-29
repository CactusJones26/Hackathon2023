import express from 'express';
import mongoose from 'mongoose';
import {userController, deviceController} from "./controller/index.js";
import bodyParser from 'body-parser';
const app = express();
const port = 3000;
const atlasUri = "mongodb+srv://edwardsdevin50:wApUqdAALAeDL6eI@cluster0.k86xptp.mongodb.net/?retryWrites=true&w=majority";

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use('/', userController);
app.use('/', deviceController);

app.get('/health', (req, res) => {
  res.json({ message: 'api is healthy' });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
  mongoose.connect(atlasUri).then(() => {
    console.log('Connected to mongodb at port 27017');
  });
});

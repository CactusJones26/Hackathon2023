const express = require('express');
const app = express();
const port = 3000;

app.get('/greet', (req, res) => {
  res.json({ message: 'Hello from the backend!' });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});

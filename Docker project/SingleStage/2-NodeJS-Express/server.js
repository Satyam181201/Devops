const express = require('express');
const app = express();

app.get('/', (req, res) => {
    res.json({ message: 'Hello from Express!' });
});

app.get('/users', (req, res) => {
    res.json({ users: ['Alice', 'Bob', 'Charlie'] });
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

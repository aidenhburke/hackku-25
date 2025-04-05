// Main server file
// Sets up express app and connects to MongoDB

const express = require("express");
const cors = require("cors");
const connectDB = require("./config/db"); //Import MongoDB connection
require("dotenv").config(); //Load variable from .env

const app = express(); //init express
app.use(cors()); //For allowing request from swift app
app.use(express.json()); //Pasring incoming JSON requests

connectDB(); //connect to MongoDB

//Routes for handling requests for fall events and conatcts
app.use("/api/fall_events", require("./routes/fallEvents"));
app.use("/api/contacts", require("./routes/contacts"));

//Sever on port 3000
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

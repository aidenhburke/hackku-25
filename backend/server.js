// Main server file
// Sets up express app and connects to MongoDB

const express = require("express");
const cors = require("cors");
const connectDB = require("./config/db"); //Import MongoDB connection
require("dotenv").config(); //Load variable from .env

const app = express(); //init express
app.use(
  cors({
    origin: "*", // Allow all origins. Replace '*' with your Swift app URL if needed for security.
    methods: ["GET", "POST", "PUT", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);
app.use(express.json()); //Pasring incoming JSON requests

connectDB(); //connect to MongoDB

//Routes for handling requests for fall events and conatcts
app.use("/api/fall_events", require("./routes/fallEvents"));
app.use("/api/contacts", require("./routes/contacts"));

//defines a route for / to get rid of vercel error message
app.get("/", (req, res) => {
  res.send("Backend is running successfully.");
});

app.post("/api/fall_events", (req, res) => {
  // Handle fall event data
  res.json({ message: "Fall event received successfully." });
});

app.get("/api/fall_events", (req, res) => {
  // Retrieve fall event data from the database
  res.json({ message: "Returning fall events." });
});

//Sever on port 3000
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

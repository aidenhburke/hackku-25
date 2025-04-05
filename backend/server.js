// Main server file
// Sets up express app and connects to MongoDB

const mongoose = require("mongoose");
const express = require("express");
const cors = require("cors");
const connectDB = require("./config/db"); //Import MongoDB connection
require("dotenv").config(); //Load variable from .env

const app = express(); //init express
app.use(cors());
app.use(express.json()); //Pasring incoming JSON requests

connectDB(); //connect to MongoDB

mongoose
  .connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("MongoDB connected successfully."))
  .catch((error) => console.error("MongoDB connection failed:", error.message));

//Routes for handling requests for fall events and conatcts
app.use("/api/fall_events", require("./routes/fallEvents"));
app.use("/api/contacts", require("./routes/contacts"));

//defines a route for / to get rid of vercel error message
app.get("/", (req, res) => {
  res.send("Backend is running successfully.");
});

app.post("/api/fall_events", (req, res) => {
  const { date, description } = req.body;

  if (!date || !description) {
    return res
      .status(400)
      .json({ error: "Date and description are required." });
  }

  console.log("Received fall event:", req.body);
  res.status(200).json({ message: "Fall event received successfully." });
});

app.get("/api/fall_events", (req, res) => {
  // Retrieve fall event data from the database
  res.json({ message: "Returning fall events." });
});

//Sever on port 3000
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

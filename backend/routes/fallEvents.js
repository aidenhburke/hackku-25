//Hadles saving and retrieving of fall event data

const express = require("express");
const router = express.Router();
const FallEvent = require("../models/fallEvent"); //Import FallEvent module

// Route for saving a fall event to the database
router.post("/", async (req, res) => {
  try {
    const fallEvent = new FallEvent(req.body); //Create new fall event from request body
    await fallEvent.save(); //Save fall event to the db
    res.status(200).json({ message: "Fall event saved successfully!" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

//Exporting router for use in server.js
module.exports = router;

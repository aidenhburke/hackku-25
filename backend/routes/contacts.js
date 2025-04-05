// Handles the saving and retrieving of contact data

const express = require("express");
const router = express.Router();
const Contact = require("../models/contact"); //Import contact model

// Route for saving user contacts in the db
router.post("/", async (req, res) => {
  try {
    const contact = new Contact(req.body); //create contact from incomng request
    await contact.save(); //save to db
    res.status(200).json({ message: "Contacts saved successfully!" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

//Export for use in server.js
module.exports = router;

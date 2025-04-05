//Defines how emergency contact data is structured

const mongoose = require("mongoose");

//Structure of the user's contact list
//user id and array of contacts
const ContactSchema = new mongoose.Schema({
  user_id: String,
  contacts: [
    {
      name: String,
      phone: String,
    },
  ],
});

//Export to be used for routes
module.exports = mongoose.model("Contact", ContactSchema);

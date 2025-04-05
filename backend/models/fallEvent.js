//Defines how fall event data is structured

const mongoose = require("mongoose");

//structure of the fall event
const FallEventSchema = new mongoose.Schema({
  user_id: String,
  timestamp: Date,
  data: Array,
  fall_detected: Boolean,
});

//exports to be used in routes
module.exports = mongoose.model("FallEvent", FallEventSchema);

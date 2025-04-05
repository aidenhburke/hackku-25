//Handles connection to MongoDB

const mongoose = require("mongoose"); //mongoosse library for interacting with MongoDB
require("dotenv").config(); // Load .env file

//Connecting to MongoDB
const connectDB = async () => {
  try {
    const uri = process.env.MONGO_URI; //pulls connection string from .env file

    //Check if connection string is grabbed
    if (!uri) {
      throw new Error("MONGO_URI is not defined in your .env file");
    }

    //Connect to DB using Mongoose
    await mongoose.connect(uri);
    console.log("MongoDB connected successfully.");
  } catch (error) {
    console.error("MongoDB connection failed:", error.message);
    process.exit(1);
  }
};

//Export function for use in other files
module.exports = connectDB;

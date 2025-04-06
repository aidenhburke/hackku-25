const express = require("express"); //Express for building API
const cors = require("cors");
const dotenv = require("dotenv"); //Load environmental variables
const twilio = require("twilio"); //Twilio for sedning messages

dotenv.config(); //Load env vars

//Init
const app = express();
app.use(cors()); //Allows requests froms swift
app.use(express.json()); // To parse incoming JSON requests

//Initialize Twilio with credentials from env file
const client = twilio(
  process.env.TWILIO_ACCOUNT_SID,
  process.env.TWILIO_AUTH_TOKEN
);

// API Route to send SMS
app.post("/api/send_sms", async (req, res) => {
  const { name, location, numbers } = req.body;

  if (!name || !location || !numbers) {
    return res.status(400).json({
      error: "Name, location, and a list of phone numbers are required.",
    });
  }

  const message =
    "A fall has been detected from ${name}'s phone. Location: ${location}";

  try {
    //Send messages to all provided numbers
    const sendPromises = numbers.map((number) =>
      client.messages.create({
        body: message,
        from: process.env.TWILIO_PHONE_NUMBER,
        to: number,
      })
    );

    await Promise.all(sendPromises); //Wait for messgaes to be sent

    res.status(200).json({ message: "Messages sent successfully!" });
  } catch (error) {
    console.error("Failed to send messages:", error.message);
    res.status(500).json({ error: "Failed to send messages" });
  }
});

// Root Route to check if backend is running
app.get("/", (req, res) => {
  res.send("Backend is running successfully.");
});

//Start Express server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

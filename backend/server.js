const express = require("express"); //Express for building API
const cors = require("cors");
const dotenv = require("dotenv"); //Load environmental variables
const { Vonage } = require("@vonage/server-sdk"); // Vonage for sending messages

dotenv.config(); //Load env vars

//Init
const app = express();
app.use(cors()); //Allows requests froms swift
app.use(express.json()); // To parse incoming JSON requests

// Initialize Vonage client with credentials from env file
const vonage = new Vonage({
  apiKey: process.env.VONAGE_API_KEY,
  apiSecret: process.env.VONAGE_API_SECRET,
});

// API Route to send SMS
app.post("/api/send_sms", async (req, res) => {
  const { name, location, numbers } = req.body;

  if (!name || !location || !numbers) {
    return res.status(400).json({
      error: "Name, location, and a list of phone numbers are required.",
    });
  }

  const message = `A fall has been detected from ${name}'s phone. Location: ${location}`;

  try {
    // Send messages to all provided numbers
    const sendPromises = numbers.map(
      (number) =>
        new Promise((resolve, reject) => {
          vonage.sms.send(
            {
              from: "SafeStep", // Can be your app name or phone number
              to: number,
              text: message,
            },
            (error, responseData) => {
              if (error) {
                reject(error);
              } else if (responseData.messages[0].status !== "0") {
                reject(
                  new Error(
                    `Message failed with error: ${responseData.messages[0]["error-text"]}`
                  )
                );
              } else {
                resolve(responseData.messages[0].messageId);
              }
            }
          );
        })
    );

    await Promise.all(sendPromises); // Wait for all messages to be sent

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

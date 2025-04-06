const express = require("express"); // Express for building API
const cors = require("cors");
const dotenv = require("dotenv"); // Load environmental variables
const nodemailer = require("nodemailer"); // Nodemailer for sending emails

dotenv.config(); // Load env vars

// Initialize Express
const app = express();
app.use(cors()); // Allows requests from Swift (or other clients)
app.use(express.json()); // Parse incoming JSON requests

// Initialize Nodemailer transporter using SMTP settings from env variables
const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: process.env.SMTP_PORT,
  secure: process.env.SMTP_PORT == 465, // true for port 465, false for other ports
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS,
  },
});

// API Route to send emails
app.post("/api/send_email", async (req, res) => {
  const { name, location, emails } = req.body;

  if (!name || !location || !emails) {
    return res.status(400).json({
      error: "Name, location, and a list of email addresses are required.",
    });
  }

  const subject = `Fall detected for ${name}`;
  const message = `A fall has been detected from ${name}'s phone. Location: ${location}`;

  try {
    // Send emails to all provided email addresses
    const sendPromises = emails.map((email) => {
      const mailOptions = {
        from: process.env.EMAIL_FROM, // Sender address (configured in your .env file)
        to: email,
        subject: subject,
        text: message,
      };

      return transporter.sendMail(mailOptions);
    });

    await Promise.all(sendPromises); // Wait for all emails to be sent

    res.status(200).json({ message: "Emails sent successfully!" });
  } catch (error) {
    console.error("Failed to send emails:", error.message);
    res.status(500).json({ error: "Failed to send emails" });
  }
});

// Root Route to check if backend is running
app.get("/", (req, res) => {
  res.send("Backend is running successfully.");
});

// Start Express server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

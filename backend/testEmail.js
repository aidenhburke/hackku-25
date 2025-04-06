const nodemailer = require("nodemailer");

// Hardcoded SMTP credentials
const transporter = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 465,
  secure: true, // true for port 465, false for other ports
  auth: {
    user: "alert.safestep@gmail.com", // your Gmail address
    pass: "ofrw rkeh pcqh hmhh", // your Gmail password or app password
  },
});

const mailOptions = {
  from: "alert.safestep@gmail.com",
  to: "markmaloney@ku.edu", // recipient email address
  subject: "Test Email",
  text: "This is a test email from Nodemailer with hardcoded credentials.",
};

transporter.sendMail(mailOptions, (error, info) => {
  if (error) {
    console.error("Error sending email:", error);
  } else {
    console.log("Email sent successfully:", info.response);
  }
});

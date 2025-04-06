# 🚶‍♀️ SafeStep – Fall Detection App

SafeStep is an iOS application developed at **HackKU 2025** with a mission to improve safety and peace of mind for elderly individuals and their loved ones. Using the iPhone’s built-in motion sensors, the app detects falls in real-time and provides a simple, accessible interface for emergency contact management.

---

## 💡 Inspiration

As our loved ones age, ensuring their safety becomes increasingly important — especially for those who live alone. SafeStep was built to address this challenge with an easy-to-use fall detection solution that runs locally on an iPhone, without requiring expensive hardware or wearables.

---

## 🔑 Features

- 📱 **Intuitive UI for Seniors**  
  Designed with accessibility in mind — large text, clear buttons, and dark mode support.

- 🚨 **Real-Time Fall Detection**  
  Uses CoreMotion to detect sudden movements or impacts that may indicate a fall.

- 📇 **Emergency Contact Management**  
  Allows users to add and manage emergency contacts for rapid response.

- 🔒 **User Login & Signup**  
  Lightweight authentication for returning and new users.

- ⚙️ **Customizable Settings**  
  Users can tailor their experience to fit their needs.

---


## 🛠️ Built With

- **SwiftUI** – For building a responsive, accessible interface.
- **CoreMotion** – To detect device motion and identify fall events.
- **@AppStorage** – To persist user and app state across sessions.
- **Vercel** – For deployment of backend server.
- **Nodemailer** – For email notification alert sending.
- **Xcode** – Development environment used during HackKU 2025.

---

## 🚀 Getting Started

### Requirements

- macOS with **Xcode 14+**
- iPhone running **iOS 15 or later** (fall detection requires real device sensors)

### Installation

```bash
git clone https://github.com/aidenhburke/hackku-25.git
cd hackku-25/frontend
open SafeStep.xcodeproj

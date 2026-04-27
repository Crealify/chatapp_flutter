# Flutter Chat Application

A feature-rich, scalable, and interactive chat application built with Flutter, Firebase, and ZegoCloud.

## 🌟 Features

- **Real-time Messaging**: Instant messaging powered by Firebase Firestore.
- **Authentication**: Secure login and sign-up using Firebase Auth and Google Sign-In.
- **Audio and Video Calls**: High-quality voice and video calls integrated via ZegoCloud.
- **Media Sharing**: Send and receive images seamlessly (Cloudinary integration).
- **State Management**: Efficient state handling using Riverpod.
- **Modern UI**: Clean and responsive user interface with Cherry Toast notifications.

## 📸 Screenshots

<p align="center">
  <img src="assets/chatapp/1.png" width="200" />
  <img src="assets/chatapp/2.png" width="200" />
  <img src="assets/chatapp/3.png" width="200" />
  <img src="assets/chatapp/4.png" width="200" />
  <img src="assets/chatapp/5.png" width="200" />
  <img src="assets/chatapp/6.png" width="200" />
  <img src="assets/chatapp/7.png" width="200" />
  <img src="assets/chatapp/8.png" width="200" />
  <img src="assets/chatapp/9.png" width="200" />
  <img src="assets/chatapp/10.png" width="200" />
  <img src="assets/chatapp/12.png" width="200" />
  <img src="assets/chatapp/13.png" width="200" />
  <img src="assets/chatapp/14.png" width="200" />
  <img src="assets/chatapp/15.png" width="200" />
  <img src="assets/chatapp/16.png" width="200" />
  <img src="assets/chatapp/17.png" width="200" />
  <img src="assets/chatapp/18.png" width="200" />
  <img src="assets/chatapp/19.png" width="200" />
  <img src="assets/chatapp/20.png" width="200" />
  <img src="assets/chatapp/21.png" width="200" />
  <img src="assets/chatapp/22.png" width="200" />
  <img src="assets/chatapp/23.png" width="200" />
  <img src="assets/chatapp/24.png" width="200" />
  <img src="assets/chatapp/25.png" width="200" />
  <img src="assets/chatapp/26.png" width="200" />
  <img src="assets/chatapp/27.png" width="200" />
  <img src="assets/chatapp/28.png" width="200" />
  <img src="assets/chatapp/29.png" width="200" />
  <img src="assets/chatapp/30.png" width="200" />
  <img src="assets/chatapp/31.png" width="200" />
  <img src="assets/chatapp/32.png" width="200" />
</p>

## 🚀 Getting Started

Follow these steps to set up the project locally on your machine.

### Prerequisites

- Flutter SDK (version 3.10.4 or higher)
- Android Studio or VS Code
- A Firebase project
- A ZegoCloud account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/chatapp_flutter.git
   cd chatapp_flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables**
   Create a `.env` file in the root directory and add your required keys (like Cloudinary, ZegoCloud API keys, etc.):
   ```env
   # Add your environment variables here
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🛠️ Tech Stack & Packages

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
- **Backend Services**:
  - [firebase_core](https://pub.dev/packages/firebase_core)
  - [firebase_auth](https://pub.dev/packages/firebase_auth)
  - [cloud_firestore](https://pub.dev/packages/cloud_firestore)
- **Communication**:
  - [zego_uikit_prebuilt_call](https://pub.dev/packages/zego_uikit_prebuilt_call)
  - [zego_uikit_signaling_plugin](https://pub.dev/packages/zego_uikit_signaling_plugin)
- **Media & Image Handling**:
  - [image_picker](https://pub.dev/packages/image_picker)
  - [cloudinary_public](https://pub.dev/packages/cloudinary_public)
- **Other Utilities**:
  - [google_sign_in](https://pub.dev/packages/google_sign_in)
  - [cherry_toast](https://pub.dev/packages/cherry_toast)
  - [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
  - [permission_handler](https://pub.dev/packages/permission_handler)
  - [intl](https://pub.dev/packages/intl)

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

## 📝 License

This project is open-source and available under the MIT License.

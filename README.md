
# Hajir-F: Attendance Tracker

**Hajir-F** is a Flutter app for tracking subject attendance on Android. It features a tabbed interface, responsive UI, and persistent storage.

---

## 📱 Features

- **Attendance Tab:** View subjects with pie charts showing attendance percentage; mark **Present**, **Absent**, or **Undo**.  
- **Manage Subjects Tab:** Add/delete subjects with input validation.  
- **Responsive UI:**  
  - Subject name and attendance info on the left  
  - Pie chart on the right  
  - Control buttons at the bottom  
- **Persistent Storage:** Saves data using `shared_preferences`.  
- **Visual Feedback:** Displays red warning for subjects with attendance <85%.

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0+)  
- Android device (Android 4.1+) or emulator  
- Android Studio or VS Code with Flutter plugins  

### Installation

Clone the repository and install dependencies:

```bash
git clone https://github.com/your-username/hajir_f.git
cd hajir_f
flutter pub get
```

Verify your setup:

```bash
flutter doctor
```

---

## ▶️ Running the App

### Debug Mode

1. Connect an Android device (USB debugging enabled) or start an emulator.  
2. Run:

   ```bash
   flutter run
   ```
### Prebuilt android apk 
Tested on :``SM A156E (mobile) • RZCX70MM63M • android-arm64 • Android 14 (API 34)``
https://github.com/Rasaili-rain/hajir_f/releases/tag/1.0.0


### Release APK

1. Build the release APK:

   ```bash
   flutter build apk --release
   ```

2. Find the APK at:

   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

3. Transfer to device, enable **"Install unknown apps"**, and install.

---


## 💡 Usage

- **Attendance Tab:** Update attendance with buttons; view percentage in pie chart.  
- **Manage Subjects Tab:** Add/delete subjects; data saves automatically.  
- **Persistence:** Data persists across app restarts.

---

## 🛠 Troubleshooting

- **Device Not Detected:** Enable USB debugging; run:

  ```bash
  flutter devices
  ```

- **Build Errors:** Run:

  ```bash
  flutter clean
  flutter pub get
  ```

- **APK Installation Fails:** Enable **"Install unknown apps"**, then rebuild the APK.  
- **Data Not Persisting:** Verify `shared_preferences` usage in `home_page.dart`.

---

## 🤝 Contributing

1. Fork the repository  
2. Create a new branch  
3. Commit your changes  
4. Open a pull request

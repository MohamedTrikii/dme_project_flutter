# 🩺 DME — Electronic Medical Record (Flutter)

> A cross-platform mobile app for doctors: manage patients, **scan prescriptions with OCR**, **translate** them on-device, **scan medicine barcodes** and sign in with **face detection**, in French, English or Arabic.

🇫🇷 [Version française](README.fr.md)

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.4+-0175C2?logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20·%20Firestore-FFCA28?logo=firebase&logoColor=black)
![ML Kit](https://img.shields.io/badge/Google%20ML%20Kit-on--device%20AI-4285F4?logo=google&logoColor=white)

---

## ✨ Features

| | Feature | Tech |
|---|---|---|
| 🔐 | Email / password sign-up and login, plus **face-detection login** | Firebase Auth · ML Kit Face Detection |
| 👥 | Patient records: create, edit, delete, list (CIN, contact, diagnosis) | Cloud Firestore |
| 📄 | **Prescription OCR**: photograph a prescription and extract its text | ML Kit Text Recognition |
| 🌍 | **On-device translation** with automatic language detection | ML Kit Language ID · Translation |
| 💊 | **Medicine barcode scanner** linked to a Firestore catalogue | ML Kit Barcode Scanning |
| 🕑 | Activity history with unread-notification badge | Local notifications · SharedPreferences |
| ⚙️ | Interface in **FR / EN / AR** (RTL), switchable at runtime | `flutter_localizations` |

All AI features run **on the device** (Google ML Kit): no medical image leaves the phone.

## 🧱 Architecture

```
lib/
├── main.dart            # Firebase init, localisation, routes
├── config/              # navigation menu
├── menu/                # drawer
├── model/               # Patient, Medicament (Firestore mapping)
├── pages/               # auth, sign-up, home, patients, OCR, barcode, face, history, settings
└── services/            # Firestore CRUD, face auth, history, language & UI translations
test/                    # unit tests (models)
```

## 🚀 Getting started

Prerequisites: [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.x, an Android device or emulator (ML Kit features need Android / iOS).

```bash
git clone https://github.com/MohamedTrikii/dme_project_flutter.git
cd dme_project_flutter
flutter pub get
flutter run
```

**Use your own Firebase project** (recommended):

```bash
dart pub global activate flutterfire_cli
flutterfire configure          # regenerates lib/firebase_options.dart and google-services.json
```

Then enable *Email/Password* in Firebase Authentication and create a Firestore database.

## ✅ Quality

```bash
flutter analyze   # No issues found
flutter test      # model unit tests
```

## 👤 Author

**Mohamed Triki** — [GitHub](https://github.com/MohamedTrikii)

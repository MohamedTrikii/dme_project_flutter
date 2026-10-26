# 🩺 DME — Dossier Médical Électronique (Flutter)

> Application mobile multiplateforme pour médecins : gestion des patients, **OCR d'ordonnances**, **traduction** sur l'appareil, **scan des codes-barres de médicaments** et connexion par **détection de visage**, en français, anglais ou arabe.

🇬🇧 [English version](README.md)

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.4+-0175C2?logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20·%20Firestore-FFCA28?logo=firebase&logoColor=black)
![ML Kit](https://img.shields.io/badge/Google%20ML%20Kit-IA%20embarquée-4285F4?logo=google&logoColor=white)

---

## ✨ Fonctionnalités

| | Fonctionnalité | Technologie |
|---|---|---|
| 🔐 | Inscription / connexion par e-mail, et **connexion par détection de visage** | Firebase Auth · ML Kit Face Detection |
| 👥 | Dossiers patients : ajout, modification, suppression, liste (CIN, contact, diagnostic) | Cloud Firestore |
| 📄 | **OCR d'ordonnance** : photographier une ordonnance et en extraire le texte | ML Kit Text Recognition |
| 🌍 | **Traduction sur l'appareil** avec détection automatique de la langue | ML Kit Language ID · Translation |
| 💊 | **Scanner de codes-barres** de médicaments relié à un catalogue Firestore | ML Kit Barcode Scanning |
| 🕑 | Historique des actions avec badge de notifications non lues | Notifications locales · SharedPreferences |
| ⚙️ | Interface **FR / EN / AR** (RTL), changement de langue à chaud | `flutter_localizations` |

Toutes les fonctions d'IA s'exécutent **sur le téléphone** (Google ML Kit) : aucune image médicale ne quitte l'appareil.

## 🧱 Architecture

```
lib/
├── main.dart            # initialisation Firebase, localisation, routes
├── config/              # menu de navigation
├── menu/                # tiroir (drawer)
├── model/               # Patient, Medicament (mapping Firestore)
├── pages/               # connexion, inscription, accueil, patients, OCR, code-barres, visage, historique, paramètres
└── services/            # CRUD Firestore, authentification faciale, historique, langue et traductions de l'interface
test/                    # tests unitaires (modèles)
```

## 🚀 Installation

Prérequis : [SDK Flutter](https://docs.flutter.dev/get-started/install) 3.x, un appareil ou émulateur Android (les fonctions ML Kit nécessitent Android / iOS).

```bash
git clone https://github.com/MohamedTrikii/dme_project_flutter.git
cd dme_project_flutter
flutter pub get
flutter run
```

**Utiliser votre propre projet Firebase** (recommandé) :

```bash
dart pub global activate flutterfire_cli
flutterfire configure          # régénère lib/firebase_options.dart et google-services.json
```

Activez ensuite *E-mail/Mot de passe* dans Firebase Authentication et créez une base Firestore.

## ✅ Qualité

```bash
flutter analyze   # No issues found
flutter test      # tests unitaires des modèles
```

## 👤 Auteur

**Mohamed Triki** — [GitHub](https://github.com/MohamedTrikii)

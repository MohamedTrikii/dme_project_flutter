import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'pages/authentification.page.dart';
import 'pages/inscription.page.dart';
import 'pages/home.page.dart';
import 'pages/ocr.page.dart';
import 'pages/barcode.page.dart';
import 'pages/face.page.dart';
import 'pages/patients.page.dart';
import 'pages/historique.page.dart';
import 'pages/parametres.page.dart';
import 'services/language.service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LanguageService.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LanguageService.localeNotifier,
      builder: (context, locale, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: locale,
          supportedLocales: const [
            Locale('fr'),
            Locale('en'),
            Locale('ar'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: '/authentification',
          routes: {
            '/authentification': (context) => const AuthentificationPage(),
            '/inscription': (context) => const InscriptionPage(),
            '/home': (context) => const HomePage(),
            '/ocr': (context) => const OCRPage(),
            '/barcode': (context) => const BarcodePage(),
            '/face': (context) => const FacePage(),
            '/patients': (context) => const PatientsPage(),
            '/historique': (context) => const HistoriquePage(),
            '/parametres': (context) => const ParametresPage(),
          },
        );
      },
    );
  }
}

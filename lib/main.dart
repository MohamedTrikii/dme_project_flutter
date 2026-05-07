import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/authentification',
      routes: {
        '/authentification': (context) => AuthentificationPage(),
        '/inscription': (context) => InscriptionPage(),
        '/home': (context) => HomePage(),
        '/ocr': (context) => OCRPage(),
        '/barcode': (context) => BarcodePage(),
        '/face': (context) => FacePage(),
        '/patients': (context) => PatientsPage(),
        '/historique': (context) => HistoriquePage(),
        '/parametres': (context) => ParametresPage(),
      },
    );
  }
}

/*void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/authentification',
    routes: {
      '/authentification': (context) => AuthentificationPage(),
      '/inscription': (context) => InscriptionPage(),
      '/home': (context) => HomePage(),
      '/ocr': (context) => OCRPage(),
      '/barcode': (context) => BarcodePage(),
      '/face': (context) => FacePage(),
      '/patients': (context) => PatientsPage(),
      '/historique': (context) => HistoriquePage(),
      '/parametres': (context) => ParametresPage(),
    },
  ));
}

 */

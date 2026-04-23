import 'package:flutter/material.dart';
import 'pages/authentification.page.dart';
import 'pages/inscription.page.dart';
import 'pages/home.page.dart';
import 'pages/ocr.page.dart';
import 'pages/barcode.page.dart';
import 'pages/face.page.dart';
import 'pages/patients.page.dart';
import 'pages/historique.page.dart';
import 'pages/parametres.page.dart';

void main() {
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

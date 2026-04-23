import 'package:flutter/material.dart';

class GlobalParams {
  static List<Map<String, dynamic>> menus = [
    {"title": "Accueil", "icon": Icon(Icons.home, color: Colors.blue), "route": "/home"},
    {"title": "Patients", "icon": Icon(Icons.people, color: Colors.blue), "route": "/patients"},
    {"title": "OCR Ordonnance", "icon": Icon(Icons.text_fields, color: Colors.blue), "route": "/ocr"},
    {"title": "Scan Médicament", "icon": Icon(Icons.qr_code_scanner, color: Colors.blue), "route": "/barcode"},
    {"title": "Login par Visage", "icon": Icon(Icons.face, color: Colors.blue), "route": "/face"},
    {"title": "Historique", "icon": Icon(Icons.history, color: Colors.blue), "route": "/historique"},
    {"title": "Paramètres", "icon": Icon(Icons.settings, color: Colors.blue), "route": "/parametres"},
    {"title": "Déconnexion", "icon": Icon(Icons.logout, color: Colors.blue), "route": "/authentification"},
  ];
}

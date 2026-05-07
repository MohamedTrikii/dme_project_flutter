import 'package:flutter/material.dart';

class GlobalParams {
  static List<Map<String, dynamic>> menus = [
    {"title": "Accueil", "key": "home_menu", "icon": Icon(Icons.home, color: Colors.blue), "route": "/home"},
    {"title": "Patients", "key": "patients", "icon": Icon(Icons.people, color: Colors.blue), "route": "/patients"},
    {"title": "OCR Ordonnance", "key": "ocr", "icon": Icon(Icons.text_fields, color: Colors.blue), "route": "/ocr"},
    {"title": "Scan Médicament", "key": "barcode", "icon": Icon(Icons.qr_code_scanner, color: Colors.blue), "route": "/barcode"},
    {"title": "Historique", "key": "history", "icon": Icon(Icons.history, color: Colors.blue), "route": "/historique"},
    {"title": "Paramètres", "key": "settings", "icon": Icon(Icons.settings, color: Colors.blue), "route": "/parametres"},
    {"title": "Déconnexion", "key": "logout", "icon": Icon(Icons.logout, color: Colors.blue), "route": "/authentification"},
  ];
}

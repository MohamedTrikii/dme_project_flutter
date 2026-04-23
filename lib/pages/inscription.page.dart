import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class InscriptionPage extends StatelessWidget {
  final TextEditingController _login = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Future<void> _onRegister(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('login', _login.text);
    await prefs.setString('pass', _password.text);
    await prefs.setBool('connecte', true);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inscription")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _login, decoration: InputDecoration(labelText: "Login")),
            TextField(controller: _password, decoration: InputDecoration(labelText: "Mot de passe"), obscureText: true),
            ElevatedButton(onPressed: () => _onRegister(context), child: Text("S'inscrire")),
          ],
        ),
      ),
    );
  }
}

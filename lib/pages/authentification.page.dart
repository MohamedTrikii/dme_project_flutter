import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class AuthentificationPage extends StatefulWidget {
  @override
  State<AuthentificationPage> createState() => _AuthentificationPageState();
}

class _AuthentificationPageState extends State<AuthentificationPage> {
  final TextEditingController _login = TextEditingController();

  final TextEditingController _password = TextEditingController();

  Future<void> _onLogin(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _login.text.trim(),
        password: _password.text.trim(),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login succès")));

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String message = "Erreur";

      if (e.code == 'user-not-found') {
        message = "Utilisateur introuvable";
      } else if (e.code == 'wrong-password') {
        message = "Mot de passe incorrect";
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _login,
              decoration: InputDecoration(labelText: "Login"),
            ),
            TextField(
              controller: _password,
              decoration: InputDecoration(labelText: "Mot de passe"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () => _onLogin(context),
              child: Text("Se connecter"),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/inscription'),
              child: Text("Créer un compte"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/face'),
              child: Text("Connexion par visage"),
            ),
          ],
        ),
      ),
    );
  }
}

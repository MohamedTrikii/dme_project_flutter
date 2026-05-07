import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/faceauth.service.dart';

class AuthentificationPage extends StatefulWidget {
  const AuthentificationPage({Key? key}) : super(key: key);

  @override
  State<AuthentificationPage> createState() => _AuthentificationPageState();
}

class _AuthentificationPageState extends State<AuthentificationPage> {
  final TextEditingController loginController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool hidePassword = true;
  bool isLoading = false;

  // ==========================
  // INIT
  // ==========================
  @override
  void initState() {
    super.initState();
    loadSavedLogin();
  }

  Future<void> loadSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      loginController.text = prefs.getString("email") ?? "";
      rememberMe = prefs.getBool("remember") ?? false;
    });
  }

  // ==========================
  // LOGIN
  // ==========================
  Future<void> onLogin() async {
    final email = loginController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage("Veuillez remplir tous les champs");
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final prefs = await SharedPreferences.getInstance();

      if (rememberMe) {
        await prefs.setString("email", email);
        await prefs.setBool("remember", true);
      } else {
        await prefs.remove("email");
        await prefs.setBool("remember", false);
      }

      showMessage("Connexion réussie");

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String message = "Erreur";

      switch (e.code) {
        case 'user-not-found':
          message = "Utilisateur introuvable";
          break;

        case 'wrong-password':
          message = "Mot de passe incorrect";
          break;

        case 'invalid-email':
          message = "Email invalide";
          break;

        case 'invalid-credential':
          message = "Identifiants invalides";
          break;

        default:
          message = "Erreur : ${e.message}";
      }

      showMessage(message);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // ==========================
  // MESSAGE
  // ==========================
  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ==========================
  // UI
  // ==========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connexion"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(Icons.medical_services, size: 90, color: Colors.green),

            const SizedBox(height: 20),

            TextField(
              controller: loginController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: hidePassword,
              decoration: InputDecoration(
                labelText: "Mot de passe",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    hidePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            CheckboxListTile(
              value: rememberMe,
              contentPadding: EdgeInsets.zero,
              title: const Text("Se souvenir de moi"),
              onChanged: (val) {
                setState(() {
                  rememberMe = val ?? false;
                });
              },
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : onLogin,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Se connecter"),
              ),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/inscription');
              },
              child: const Text("Créer un compte"),
            ),

            ElevatedButton(
              onPressed: () async {
                final faceAuth = FaceAuthService();

                bool ok = await faceAuth.verifyFace();

                if (ok) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Face non reconnue")),
                  );
                }
              },
              child: Text("Connexion par visage"),
            )
          ],
        ),
      ),
    );
  }
}

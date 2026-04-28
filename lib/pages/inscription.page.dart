import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({Key? key}) : super(key: key);

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final TextEditingController loginController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmController = TextEditingController();

  final TextEditingController nomController = TextEditingController();

  bool isLoading = false;
  bool hidePassword = true;
  bool hideConfirm = true;

  // ==========================
  // REGISTER
  // ==========================
  Future<void> onRegister() async {
    final email = loginController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();
    final nom = nomController.text.trim();

    if (nom.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      showMessage("Veuillez remplir tous les champs");
      return;
    }

    if (password != confirm) {
      showMessage("Les mots de passe ne correspondent pas");
      return;
    }

    if (password.length < 6) {
      showMessage("Mot de passe minimum 6 caractères");
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      showMessage("Compte créé avec succès");

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String message = "";

      switch (e.code) {
        case 'weak-password':
          message = "Mot de passe trop faible";
          break;

        case 'email-already-in-use':
          message = "Cet email existe déjà";
          break;

        case 'invalid-email':
          message = "Adresse email invalide";
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
    confirmController.dispose();
    nomController.dispose();
    super.dispose();
  }

  // ==========================
  // UI
  // ==========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(Icons.person_add, size: 90, color: Colors.green),

            const SizedBox(height: 20),

            TextField(
              controller: nomController,
              decoration: const InputDecoration(
                labelText: "Nom complet",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 15),

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

            const SizedBox(height: 15),

            TextField(
              controller: confirmController,
              obscureText: hideConfirm,
              decoration: InputDecoration(
                labelText: "Confirmer mot de passe",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    hideConfirm ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      hideConfirm = !hideConfirm;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : onRegister,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("S'inscrire"),
              ),
            ),

            const SizedBox(height: 15),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Déjà un compte ? Connexion"),
            ),
          ],
        ),
      ),
    );
  }
}

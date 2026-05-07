import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/faceauth.service.dart';
import '../services/translation.service.dart';

class AuthentificationPage extends StatefulWidget {
  const AuthentificationPage({super.key});

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
      showMessage(TranslationService.getString('fill_all_fields'));
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

      showMessage(TranslationService.getString('login_success'));
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String message = "Erreur";

      switch (e.code) {
        case 'user-not-found':
          message = TranslationService.getString('user_not_found');
          break;

        case 'wrong-password':
          message = TranslationService.getString('wrong_password');
          break;

        case 'invalid-email':
          message = TranslationService.getString('invalid_email');
          break;

        case 'invalid-credential':
          message = TranslationService.getString('invalid_credential');
          break;

        default:
          message = "${TranslationService.getString('error')} : ${e.message}";
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
        title: Text(TranslationService.getString('connexion')),
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
              decoration: InputDecoration(
                labelText: TranslationService.getString('email'),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: hidePassword,
              decoration: InputDecoration(
                labelText: TranslationService.getString('password'),
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
              title: Text(TranslationService.getString('remember_me')),
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
                    : Text(TranslationService.getString('login')),
              ),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/inscription');
              },
              child: Text(TranslationService.getString('create_account')),
            ),

            ElevatedButton(
              onPressed: () async {
                final faceAuth = FaceAuthService();

                bool ok = await faceAuth.verifyFace();

                if (ok) {
                  if (!mounted) return;
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(TranslationService.getString('face_not_recognized'))),
                  );
                }
              },
              child: Text(TranslationService.getString('face_login')),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/translation.service.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

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
      showMessage(TranslationService.getString('fill_all_fields'));
      return;
    }

    if (password != confirm) {
      showMessage(TranslationService.getString('passwords_dont_match'));
      return;
    }

    if (password.length < 6) {
      showMessage(TranslationService.getString('password_too_short'));
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

      showMessage(TranslationService.getString('account_created_success'));
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String message = "";

      switch (e.code) {
        case 'weak-password':
          message = TranslationService.getString('weak_password');
          break;

        case 'email-already-in-use':
          message = TranslationService.getString('email_already_in_use');
          break;

        case 'invalid-email':
          message = TranslationService.getString('invalid_email');
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
        title: Text(TranslationService.getString('create_account')),
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
              decoration: InputDecoration(
                labelText: TranslationService.getString('full_name'),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 15),

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

            const SizedBox(height: 15),

            TextField(
              controller: confirmController,
              obscureText: hideConfirm,
              decoration: InputDecoration(
                labelText: TranslationService.getString('confirm'),
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
                    : Text(TranslationService.getString('create_account')),
              ),
            ),

            const SizedBox(height: 15),

            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/authentification');
              },
              child: Text(TranslationService.getString('connexion')),
            ),
          ],
        ),
      ),
    );
  }
}

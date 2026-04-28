import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../menu/drawer.widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _deconnexion(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/inscription',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil DME Intelligent"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _deconnexion(context),
          ),
        ],
      ),

      drawer: MyDrawer(),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            // ================= PATIENTS =================
            dashboardCard(
              context,
              icon: Icons.people,
              title: "Patients",
              color: Colors.blue,
              route: '/patients',
            ),

            // ================= OCR =================
            dashboardCard(
              context,
              icon: Icons.document_scanner,
              title: "Ordonnances OCR",
              color: Colors.orange,
              route: '/ocr',
            ),

            // ================= BARCODE =================
            dashboardCard(
              context,
              icon: Icons.qr_code_scanner,
              title: "Scanner Médicaments",
              color: Colors.purple,
              route: '/barcode',
            ),

            // ================= FACE =================
            dashboardCard(
              context,
              icon: Icons.face,
              title: "Face Recognition",
              color: Colors.red,
              route: '/face',
            ),

            // ================= SETTINGS =================
            dashboardCard(
              context,
              icon: Icons.settings,
              title: "Paramètres",
              color: Colors.grey,
              route: '/parametres',
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required String route,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: color.withOpacity(0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

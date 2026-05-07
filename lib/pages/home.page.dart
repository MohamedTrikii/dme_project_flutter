import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../menu/drawer.widget.dart';
import '../services/historique.service.dart';
import '../services/translation.service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _refreshUnreadCount();
  }

  Future<void> _refreshUnreadCount() async {
    final count = await HistoriqueService.getUnreadCount();
    setState(() {
      unreadCount = count;
    });
  }

  Future<void> _deconnexion(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
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
        title: Text(TranslationService.getString('app_title')),
        backgroundColor: Colors.green,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () async {
                  // Clear count immediately
                  await HistoriqueService.resetUnreadCount();
                  setState(() { unreadCount = 0; });
                  
                  if (!mounted) return;
                  await Navigator.pushNamed(context, '/historique');
                  _refreshUnreadCount();
                },
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
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
            dashboardCard(
              context,
              icon: Icons.people,
              title: TranslationService.getString('patients'),
              color: Colors.blue,
              route: '/patients',
            ),
            dashboardCard(
              context,
              icon: Icons.document_scanner,
              title: TranslationService.getString('ocr'),
              color: Colors.orange,
              route: '/ocr',
            ),
            dashboardCard(
              context,
              icon: Icons.qr_code_scanner,
              title: TranslationService.getString('barcode'),
              color: Colors.purple,
              route: '/barcode',
            ),
            dashboardCard(
              context,
              icon: Icons.auto_awesome,
              title: TranslationService.getString('ia_scanner'),
              color: Colors.red,
              route: '/face',
            ),
            dashboardCard(
              context,
              icon: Icons.settings,
              title: TranslationService.getString('settings'),
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
        Navigator.pushNamed(context, route).then((_) => _refreshUnreadCount());
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

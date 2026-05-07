import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../config/global.params.dart';
import '../services/translation.service.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: GlobalParams.menus.map((item) {
          return ListTile(
            title: Text(TranslationService.getString(item['key'])),
            leading: item['icon'],
            onTap: () async {
              final route = item['route'].toString();
              if (route != '/authentification') {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, route);
                return;
              }

              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/authentification',
                    (Route<dynamic> route) => false,
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../config/global.params.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: GlobalParams.menus.map((item) {
          return ListTile(
            title: Text(item['title']),
            leading: item['icon'],
            onTap: () async {
              if('${item['title']}' != "Déconnexion"){
                Navigator.of(context).pop();
                Navigator.pushNamed(context, "${item['route']}");
              }
              else{
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil("/auth", (Route<dynamic> route) => false);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}

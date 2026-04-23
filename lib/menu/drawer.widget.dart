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
            onTap: () => Navigator.pushNamed(context, item['route']),
          );
        }).toList(),
      ),
    );
  }
}

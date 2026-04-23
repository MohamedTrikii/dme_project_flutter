import 'package:flutter/material.dart';

class ParametresPage extends StatefulWidget {
  const ParametresPage({Key? key}) : super(key: key);

  @override
  _ParametresPageState createState() => _ParametresPageState();
}

class _ParametresPageState extends State<ParametresPage> {
  bool son = true;
  bool notifications = true;
  String langue = "Français";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Paramètres")),
      body: Column(
        children: [
          SwitchListTile(
            title: Text("Activer sons"),
            value: son,
            onChanged: (val) => setState(() => son = val),
          ),
          SwitchListTile(
            title: Text("Activer notifications"),
            value: notifications,
            onChanged: (val) => setState(() => notifications = val),
          ),
          DropdownButton<String>(
            value: langue,
            items: ["Français", "English", "العربية"].map((lang) {
              return DropdownMenuItem(value: lang, child: Text(lang));
            }).toList(),
            onChanged: (val) => setState(() => langue = val!),
          ),
        ],
      ),
    );
  }
}

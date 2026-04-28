import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class ParametresPage extends StatefulWidget {
  const ParametresPage({Key? key}) : super(key: key);

  @override
  State<ParametresPage> createState() => _ParametresPageState();
}

class _ParametresPageState extends State<ParametresPage> {
  bool son = true;
  bool notifications = true;
  String langue = "Français";

  String translatedText = "";

  final Map<String, TranslateLanguage> languageMap = {
    "Français": TranslateLanguage.french,
    "English": TranslateLanguage.english,
    "العربية": TranslateLanguage.arabic,
  };

  @override
  void initState() {
    super.initState();
    chargerParametres();
  }

  // =========================
  // LOAD SETTINGS
  // =========================
  Future<void> chargerParametres() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      son = prefs.getBool("son") ?? true;
      notifications = prefs.getBool("notifications") ?? true;
      langue = prefs.getString("langue") ?? "Français";
    });
  }

  // =========================
  // SAVE SETTINGS
  // =========================
  Future<void> sauvegarder() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("son", son);
    await prefs.setBool("notifications", notifications);
    await prefs.setString("langue", langue);
  }

  // =========================
  // TRANSLATE SAMPLE TEXT
  // =========================
  Future<void> traduireTexte() async {
    final source = TranslateLanguage.french;

    final target = languageMap[langue]!;

    final translator = OnDeviceTranslator(
      sourceLanguage: source,
      targetLanguage: target,
    );

    final text = await translator.translateText(
      "Bienvenue dans votre application médicale",
    );

    setState(() {
      translatedText = text;
    });

    translator.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // SOUND
          SwitchListTile(
            title: const Text("Activer sons"),
            subtitle: const Text("Sons boutons, alertes"),
            value: son,
            onChanged: (val) async {
              setState(() => son = val);
              await sauvegarder();
            },
          ),

          const Divider(),

          // NOTIFICATIONS
          SwitchListTile(
            title: const Text("Activer notifications"),
            subtitle: const Text("Rappels livraisons / stock"),
            value: notifications,
            onChanged: (val) async {
              setState(() => notifications = val);
              await sauvegarder();
            },
          ),

          const Divider(),

          // LANGUAGE
          const Text(
            "Langue",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          DropdownButtonFormField<String>(
            value: langue,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: languageMap.keys
                .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                .toList(),
            onChanged: (val) async {
              setState(() {
                langue = val!;
              });

              await sauvegarder();
              await traduireTexte();
            },
          ),

          const SizedBox(height: 25),

          ElevatedButton(
            onPressed: traduireTexte,
            child: const Text("Tester Traduction ML Kit"),
          ),

          const SizedBox(height: 20),

          Text(translatedText, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

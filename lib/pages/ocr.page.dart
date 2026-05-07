import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/historique.service.dart';
import '../services/translation.service.dart';
import '../model/patient.model.dart';
import 'ajout_modif_patient.page.dart';

class OCRPage extends StatefulWidget {
  const OCRPage({super.key});

  @override
  State<OCRPage> createState() => _OCRPageState();
}

class _OCRPageState extends State<OCRPage> {
  final ImagePicker picker = ImagePicker();

  File? imageFile;
  String result = "";
  String translatedText = "";
  bool isLoading = false;
  bool isTranslating = false;

  List<Map<String, dynamic>> savedPrescriptions = [];

  @override
  void initState() {
    super.initState();
    _loadSavedPrescriptions();
  }

  Future<void> _loadSavedPrescriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('saved_prescriptions');
    if (data != null) {
      setState(() {
        savedPrescriptions = List<Map<String, dynamic>>.from(json.decode(data));
      });
    }
  }

  Future<void> _savePrescription(String original, String translated) async {
    final prefs = await SharedPreferences.getInstance();
    final newItem = {
      'date': DateTime.now().toString().substring(0, 16),
      'original': original,
      'translated': translated,
    };
    
    savedPrescriptions.insert(0, newItem);
    await prefs.setString('saved_prescriptions', json.encode(savedPrescriptions));
    setState(() {});
  }

  Patient extractPatient(String text) {
    String nom = "";
    String prenom = "";

    List<String> lines = text.split("\n");

    for (var line in lines) {
      final lower = line.toLowerCase();

      if (lower.contains("nom")) {
        nom = line.replaceAll(RegExp(r'nom', caseSensitive: false), "").trim();
      } else if (lower.contains("prenom")) {
        prenom = line.replaceAll(RegExp(r'prenom', caseSensitive: false), "").trim();
      }
    }

    return Patient(
      nom: nom.isNotEmpty ? nom : null,
      prenom: prenom.isNotEmpty ? prenom : null,
      diagnostic: text,
    );
  }

  Future<void> translateText({bool addHistory = true}) async {
    if (result.isEmpty) return;

    setState(() {
      isTranslating = true;
    });

    final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
    final detectedLang = await languageIdentifier.identifyLanguage(result);

    TranslateLanguage source;
    switch (detectedLang) {
      case "ar":
        source = TranslateLanguage.arabic;
        break;
      case "en":
        source = TranslateLanguage.english;
        break;
      default:
        source = TranslateLanguage.french;
    }

    final prefs = await SharedPreferences.getInstance();
    final String targetLangName = prefs.getString("langue") ?? "Français";
    
    TranslateLanguage targetLang;
    switch (targetLangName) {
      case "English":
        targetLang = TranslateLanguage.english;
        break;
      case "العربية":
        targetLang = TranslateLanguage.arabic;
        break;
      default:
        targetLang = TranslateLanguage.french;
    }

    final translator = OnDeviceTranslator(
      sourceLanguage: source,
      targetLanguage: targetLang,
    );

    final output = await translator.translateText(result);

    await translator.close();
    languageIdentifier.close();

    if (addHistory) {
      await HistoriqueService.addAction("Traduction OCR de $detectedLang vers $targetLangName");
    }

    setState(() {
      translatedText = output;
      isTranslating = false;
    });

    // Save to list
    await _savePrescription(result, translatedText);
  }

  Future<void> showConfirmationDialog(Patient patient) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmer les données"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nom: ${patient.nom ?? "-"}"),
                Text("Prénom: ${patient.prenom ?? "-"}"),
                const SizedBox(height: 10),
                const Text("Diagnostic:"),
                Text(
                  patient.diagnostic ?? "-",
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Confirmer"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AjoutModifPatientPage(
            patient: patient,
            modifMode: false,
          ),
        ),
      );
    }
  }

  Future<void> scanImage() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.camera);

    if (picked == null) return;

    setState(() {
      imageFile = File(picked.path);
      isLoading = true;
      result = "";
      translatedText = "";
    });

    final inputImage = InputImage.fromFilePath(picked.path);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    if (recognizedText.text.trim().isEmpty) {
      setState(() {
        result = "Aucun texte détecté";
        isLoading = false;
      });
      return;
    }

    setState(() {
      result = recognizedText.text;
      isLoading = false;
    });

    await translateText(addHistory: false);

    final textToUse = translatedText.isNotEmpty ? translatedText : result;
    final patient = extractPatient(textToUse);

    await HistoriqueService.addAction("Scan OCR : ordonnance traitée");
    await showConfirmationDialog(patient);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TranslationService.getString('ocr')),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  imageFile!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: scanImage,
                child: Text(TranslationService.getString('scan_prescription')),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: translateText,
                child: Text(TranslationService.getString('translate')),
              ),
            ),

            const SizedBox(height: 20),

            if (isLoading || isTranslating)
              const Center(child: CircularProgressIndicator()),

            if (result.isNotEmpty && !isLoading) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  TranslationService.getString('last_result'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(TranslationService.getString('detected_text'), style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(result),
                    if (translatedText.isNotEmpty) ...[
                      const Divider(),
                      Text(TranslationService.getString('translated_text'), style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(translatedText),
                    ],
                  ],
                ),
              ),
            ],

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                TranslationService.getString('prescription_list'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),

            if (savedPrescriptions.isEmpty)
              Text(TranslationService.getString('no_prescription'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: savedPrescriptions.length,
                itemBuilder: (context, index) {
                  final item = savedPrescriptions[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.description, color: Colors.blue),
                      title: Text("Ordonnance du ${item['date']}"),
                      subtitle: Text(
                        item['translated'].toString().isNotEmpty 
                          ? item['translated'] 
                          : item['original'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Détails Ordonnance - ${item['date']}"),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Texte Original :", style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(item['original']),
                                  const SizedBox(height: 10),
                                  const Text("Texte Traduit :", style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(item['translated']),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Fermer"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
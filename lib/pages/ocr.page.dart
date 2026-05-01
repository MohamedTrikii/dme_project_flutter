import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';

import '../model/patient.model.dart';
import 'ajout_modif_patient.page.dart';

class OCRPage extends StatefulWidget {
  const OCRPage({Key? key}) : super(key: key);

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

  // ==========================
  // EXTRACT PATIENT DATA
  // ==========================
  Patient extractPatient(String text) {
    String nom = "";
    String prenom = "";

    List<String> lines = text.split("\n");

    for (var line in lines) {
      final lower = line.toLowerCase();

      if (lower.contains("nom")) {
        nom = line.replaceAll(RegExp(r'(?i)nom'), "").trim();
      } else if (lower.contains("prenom")) {
        prenom = line.replaceAll(RegExp(r'(?i)prenom'), "").trim();
      }
    }

    return Patient(
      nom: nom.isNotEmpty ? nom : null,
      prenom: prenom.isNotEmpty ? prenom : null,
      diagnostic: text,
    );
  }

  // ==========================
  // TRANSLATION
  // ==========================
  Future<void> translateText() async {
    if (result.isEmpty) return;

    setState(() {
      isTranslating = true;
    });

    final languageIdentifier =
    LanguageIdentifier(confidenceThreshold: 0.5);

    final detectedLang =
    await languageIdentifier.identifyLanguage(result);

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

    final translator = OnDeviceTranslator(
      sourceLanguage: source,
      targetLanguage: TranslateLanguage.french,
    );

    final output = await translator.translateText(result);

    await translator.close();
    languageIdentifier.close();

    setState(() {
      translatedText = output;
      isTranslating = false;
    });
  }

  // ==========================
  // CONFIRMATION DIALOG
  // ==========================
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

  // ==========================
  // OCR PROCESS
  // ==========================
  Future<void> scanImage() async {
    final XFile? picked =
    await picker.pickImage(source: ImageSource.camera);

    if (picked == null) return;

    setState(() {
      imageFile = File(picked.path);
      isLoading = true;
      result = "";
      translatedText = "";
    });

    final inputImage =
    InputImage.fromFilePath(picked.path);

    final textRecognizer = TextRecognizer();

    final recognizedText =
    await textRecognizer.processImage(inputImage);

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

    // OPTIONAL: auto-translate if not French
    await translateText();

    // Extract using translated text if available
    final textToUse =
    translatedText.isNotEmpty ? translatedText : result;

    final patient = extractPatient(textToUse);

    await showConfirmationDialog(patient);
  }

  // ==========================
  // UI
  // ==========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OCR Ordonnance"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
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
                child: const Text("Scanner une ordonnance"),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: translateText,
                child: const Text("Traduire le texte"),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Texte détecté:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      Text(result),

                      const SizedBox(height: 20),

                      if (isTranslating)
                        const CircularProgressIndicator(),

                      if (translatedText.isNotEmpty) ...[
                        const Text(
                          "Texte traduit:",
                          style: TextStyle(
                              fontWeight:
                              FontWeight.bold),
                        ),
                        Text(translatedText),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
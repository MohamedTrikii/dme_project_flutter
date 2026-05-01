import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

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
  bool isLoading = false;

  // ==========================
  // SIMPLE TEXT PARSER
  // ==========================
  Patient extractPatient(String text) {
    String nom = "";
    String prenom = "";

    List<String> lines = text.split("\n");

    for (var line in lines) {
      line = line.toLowerCase();

      if (line.contains("nom")) {
        nom = line.replaceAll("nom", "").trim();
      } else if (line.contains("prenom")) {
        prenom = line.replaceAll("prenom", "").trim();
      }
    }

    return Patient(
      nom: nom.isNotEmpty ? nom : null,
      prenom: prenom.isNotEmpty ? prenom : null,
      diagnostic: text,
    );
  }

  Future<void> showConfirmationDialog(Patient patient) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmer les données"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
          builder: (context) =>
              AjoutModifPatientPage(patient: patient, modifMode: false),
        ),
      );
    }
  }

  // ==========================
  // OCR + REDIRECT
  // ==========================
  Future<void> scanImage() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.camera);

    if (picked == null) return;

    setState(() {
      imageFile = File(picked.path);
      isLoading = true;
      result = "";
    });

    final inputImage = InputImage.fromFilePath(picked.path);

    final TextRecognizer textRecognizer = TextRecognizer();

    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );

    await textRecognizer.close();

    if (recognizedText.text.trim().isEmpty) {
      setState(() {
        result = "Aucun texte détecté";
        isLoading = false;
      });
      return;
    }

    // ==========================
    // EXTRACT DATA
    // ==========================
    Patient extracted = extractPatient(recognizedText.text);

    setState(() {
      result = recognizedText.text;
      isLoading = false;
    });

    // ==========================
    // SHOW CONFIRMATION
    // ==========================
    await showConfirmationDialog(extracted);

    // ==========================
    // REDIRECT TO FORM
    // ==========================
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AjoutModifPatientPage(patient: extracted, modifMode: false),
      ),
    );
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

            const SizedBox(height: 20),

            Expanded(
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : SingleChildScrollView(
                        child: Text(
                          result,
                          style: const TextStyle(fontSize: 16),
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

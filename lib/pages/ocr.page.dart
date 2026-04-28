import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

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

    if (recognizedText.text.trim().isEmpty) {
      result = "Aucun texte détecté";
    } else {
      result = recognizedText.text;
    }

    await textRecognizer.close();

    setState(() {
      isLoading = false;
    });
  }

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

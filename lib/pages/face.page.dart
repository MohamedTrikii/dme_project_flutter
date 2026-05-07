import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/translation.service.dart';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class FacePage extends StatefulWidget {
  const FacePage({super.key});

  @override
  State<FacePage> createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  final ImagePicker picker = ImagePicker();

  File? imageFile;
  String result = "";

  bool isLoading = false;

  // ==========================
  // FACE DETECTION (ML KIT)
  // ==========================
  Future<void> detectFace() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.camera);

    if (picked == null) return;

    setState(() {
      imageFile = File(picked.path);
      isLoading = true;
      result = "";
    });

    final inputImage = InputImage.fromFilePath(picked.path);

    final FaceDetector detector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
        enableContours: true,
        enableClassification: true,
        enableLandmarks: true,
      ),
    );

    final List<Face> faces = await detector.processImage(inputImage);

    if (faces.isEmpty) {
      result = TranslationService.getString('no_face_detected');
    } else {
      result = "${TranslationService.getString('faces_detected')} : ${faces.length}\n\n";

      for (int i = 0; i < faces.length; i++) {
        Face f = faces[i];

        result += "${TranslationService.getString('face')} ${i + 1}\n";
        result +=
        "${TranslationService.getString('smiling')} : ${f.smilingProbability?.toStringAsFixed(2) ?? "N/A"}\n";
        result +=
        "${TranslationService.getString('left_eye_open')} : ${f.leftEyeOpenProbability?.toStringAsFixed(2) ?? "N/A"}\n";
        result +=
        "${TranslationService.getString('right_eye_open')} : ${f.rightEyeOpenProbability?.toStringAsFixed(2) ?? "N/A"}\n\n";
      }
    }

    await detector.close();

    setState(() {
      isLoading = false;
    });
  }

  // ==========================
  // TEXT RECOGNITION
  // ==========================
  Future<void> scanText() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.camera);

    if (picked == null) return;

    setState(() {
      imageFile = File(picked.path);
      isLoading = true;
      result = "";
    });

    final inputImage = InputImage.fromFilePath(picked.path);

    final textRecognizer = TextRecognizer();

    final RecognizedText text = await textRecognizer.processImage(inputImage);

    result = text.text.isEmpty ? TranslationService.getString('no_text_detected') : text.text;

    await textRecognizer.close();

    setState(() {
      isLoading = false;
    });
  }

  // ==========================
  // BARCODE / QR CODE
  // ==========================
  Future<void> scanBarcode() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.camera);

    if (picked == null) return;

    setState(() {
      imageFile = File(picked.path);
      isLoading = true;
      result = "";
    });

    final inputImage = InputImage.fromFilePath(picked.path);

    final barcodeScanner = BarcodeScanner();

    final List<Barcode> barcodes = await barcodeScanner.processImage(
      inputImage,
    );

    if (barcodes.isEmpty) {
      result = TranslationService.getString('no_code_detected');
    } else {
      result = barcodes.map((b) => b.rawValue ?? TranslationService.getString('unknown_value')).join("\n");
    }

    await barcodeScanner.close();

    setState(() {
      isLoading = false;
    });
  }

  // ==========================
  // UI
  // ==========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TranslationService.getString('ia_scanner')),
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

            const SizedBox(height: 15),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: detectFace,
                  child: Text(TranslationService.getString('scan_face')),
                ),
                ElevatedButton(
                  onPressed: scanText,
                  child: Text(TranslationService.getString('scan_text')),
                ),
                ElevatedButton(
                  onPressed: scanBarcode,
                  child: Text(TranslationService.getString('scan_qr')),
                ),
              ],
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

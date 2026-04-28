import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class BarcodePage extends StatefulWidget {
  const BarcodePage({Key? key}) : super(key: key);

  @override
  State<BarcodePage> createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {
  final ImagePicker picker = ImagePicker();

  File? imageFile;
  String result = "";
  bool isLoading = false;

  Future<void> scanBarcode() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.camera);

    if (picked == null) return;

    setState(() {
      imageFile = File(picked.path);
      isLoading = true;
      result = "";
    });

    final inputImage = InputImage.fromFilePath(picked.path);

    final BarcodeScanner scanner = BarcodeScanner();

    final List<Barcode> barcodes = await scanner.processImage(inputImage);

    if (barcodes.isEmpty) {
      result = "Aucun code-barres détecté";
    } else {
      result = "";

      for (int i = 0; i < barcodes.length; i++) {
        final Barcode code = barcodes[i];

        result += "Code ${i + 1}\n";
        result += "Valeur : ${code.rawValue ?? "Inconnue"}\n";
        result += "Format : ${code.format.name}\n\n";
      }
    }

    await scanner.close();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Médicament"),
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
                onPressed: scanBarcode,
                child: const Text("Scanner un code-barres"),
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

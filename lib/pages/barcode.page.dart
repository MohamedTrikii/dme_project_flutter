import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

import '../model/medicament.model.dart';
import '../services/medicament.service.dart';
import '../services/historique.service.dart';
import '../services/translation.service.dart';

class BarcodePage extends StatefulWidget {
  const BarcodePage({super.key});

  @override
  State<BarcodePage> createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {
  final ImagePicker picker = ImagePicker();
  final MedicamentService medicamentService = MedicamentService();

  File? imageFile;
  bool isLoading = false;

  Medicament? medicamentTrouve;
  String? unknownBarcode;

  Future<void> scanBarcode() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.camera);

    if (picked == null) return;

    setState(() {
      imageFile = File(picked.path);
      isLoading = true;
      medicamentTrouve = null;
      unknownBarcode = null;
    });

    final inputImage = InputImage.fromFilePath(picked.path);
    final BarcodeScanner scanner = BarcodeScanner();
    final List<Barcode> barcodes = await scanner.processImage(inputImage);

    if (barcodes.isNotEmpty) {
      final code = barcodes.first.rawValue ?? "";
      
      if (code.isNotEmpty) {
        Medicament? m = await medicamentService.getMedicamentByCode(code);
        if (m != null) {
          setState(() {
            medicamentTrouve = m;
          });
          await HistoriqueService.addAction("Médicament scanné : ${m.nom}");
        } else {
          setState(() {
            unknownBarcode = code;
          });
          await HistoriqueService.addAction("Code-barres inconnu scanné : $code");
        }
      }
    }

    await scanner.close();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> showAddMedicamentDialog(String code) async {
    final nomController = TextEditingController();
    final labelController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(TranslationService.getString('add')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Code: $code"),
              const SizedBox(height: 10),
              TextField(
                controller: nomController,
                decoration: InputDecoration(labelText: TranslationService.getString('med_name')),
              ),
              TextField(
                controller: labelController,
                decoration: InputDecoration(labelText: TranslationService.getString('label')),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(TranslationService.getString('cancel')),
            ),
            ElevatedButton(
              onPressed: () async {
                final nom = nomController.text.trim();
                final label = labelController.text.trim();
                if (nom.isNotEmpty) {
                  Medicament newMed = Medicament(code: code, nom: nom, label: label);
                  await medicamentService.ajouterMedicament(newMed);
                  await HistoriqueService.addAction("Nouveau médicament ajouté : $nom");
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  setState(() {
                    medicamentTrouve = newMed;
                    unknownBarcode = null;
                  });
                }
              },
              child: Text(TranslationService.getString('add')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TranslationService.getString('barcode')),
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
                child: Text(TranslationService.getString('scan_barcode')),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            if (medicamentTrouve != null) ...[
                              const Icon(Icons.check_circle, color: Colors.green, size: 60),
                              const SizedBox(height: 10),
                              Text("Nom : ${medicamentTrouve!.nom}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text("Label : ${medicamentTrouve!.label}", style: const TextStyle(fontSize: 16)),
                            ],
                            if (unknownBarcode != null) ...[
                               Text(TranslationService.getString('med_not_found'), style: const TextStyle(color: Colors.red, fontSize: 18)),
                               const SizedBox(height: 10),
                               IconButton(
                                 icon: const Icon(Icons.add_circle, color: Colors.blue, size: 50),
                                 onPressed: () => showAddMedicamentDialog(unknownBarcode!),
                               ),
                               Text(TranslationService.getString('add_med')),
                            ]
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

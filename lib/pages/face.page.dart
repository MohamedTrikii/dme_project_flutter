import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class FacePage extends StatefulWidget {
  const FacePage({Key? key}) : super(key: key);

  @override
  _FacePageState createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  String result = "";
  final picker = ImagePicker();

  Future<void> _detectFace() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final inputImage = InputImage.fromFilePath(pickedFile.path);
      final faceDetector = FaceDetector(
        options: FaceDetectorOptions(enableContours: true, enableClassification: true),
      );
      final List<Face> faces = await faceDetector.processImage(inputImage);

      setState(() {
        result = faces.isEmpty
            ? "Aucun visage détecté"
            : "Visages détectés : ${faces.length}";
      });

      faceDetector.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion par visage")),
      body: Column(
        children: [
          ElevatedButton(onPressed: _detectFace, child: Text("Scanner visage")),
          Expanded(child: Center(child: Text(result))),
        ],
      ),
    );
  }
}

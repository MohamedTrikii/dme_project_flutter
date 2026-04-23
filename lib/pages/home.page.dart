import 'package:flutter/material.dart';
import '../menu/drawer.widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Accueil DME")),
      drawer: MyDrawer(),
      body: Center(child: Text("Bienvenue dans le DME intelligent")),
    );
  }
}

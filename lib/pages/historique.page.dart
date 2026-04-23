import 'package:flutter/material.dart';

class HistoriquePage extends StatelessWidget {
  const HistoriquePage({Key? key}) : super(key: key);

  final List<String> historique = const [
    "OCR : ordonnance du 20/04",
    "Barcode : médicament Doliprane",
    "Face : connexion réussie",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historique")),
      body: ListView.builder(
        itemCount: historique.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(title: Text(historique[index])),
          );
        },
      ),
    );
  }
}

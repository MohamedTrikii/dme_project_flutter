import 'package:cloud_firestore/cloud_firestore.dart';

class Medicament {
  String? id;
  String code;
  String nom;
  String label;

  Medicament({
    this.id,
    required this.code,
    required this.nom,
    required this.label,
  });

  factory Medicament.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Medicament(
      id: doc.id,
      code: data['code'] ?? '',
      nom: data['nom'] ?? '',
      label: data['label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'nom': nom,
      'label': label,
    };
  }
}

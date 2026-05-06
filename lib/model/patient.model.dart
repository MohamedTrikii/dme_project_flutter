import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  String? id;
  String? nom;
  String? prenom;
  String? cin;
  String? email;
  String? tel;
  String? diagnostic;

  Patient({
    this.id,
    this.nom,
    this.prenom,
    this.cin,
    this.email,
    this.tel,
    this.diagnostic,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id']?.toString(),
      nom: json['nom']?.toString(),
      prenom: json['prenom']?.toString(),
      cin: json['cin']?.toString(),
      email: json['email']?.toString(),
      tel: json['tel']?.toString(),
      diagnostic: json['diagnostic']?.toString(),
    );
  }

  factory Patient.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Patient(
      id: doc.id,
      nom: data['nom']?.toString(),
      prenom: data['prenom']?.toString(),
      cin: data['cin']?.toString(),
      email: data['email']?.toString(),
      tel: data['tel']?.toString(),
      diagnostic: data['diagnostic']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'cin': cin,
      'email': email,
      'tel': tel,
      'diagnostic': diagnostic,
    };
  }
}

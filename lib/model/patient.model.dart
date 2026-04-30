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
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      cin: json['cin'],
      email: json['email'],
      tel: json['tel'],
      diagnostic: json['diagnostic'],
    );
  }

  factory Patient.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Patient(
      id: doc.id,
      nom: data['nom'],
      prenom: data['prenom'],
      cin: data['data'],
      email: data['email'],
      tel: data['tel'],
      diagnostic: data['diagnostic'],
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
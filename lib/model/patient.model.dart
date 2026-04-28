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
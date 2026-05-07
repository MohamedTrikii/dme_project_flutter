import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/medicament.model.dart';

class MedicamentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = "medicaments";

  Future<Medicament?> getMedicamentByCode(String code) async {
    QuerySnapshot snapshot = await _firestore
        .collection(collectionName)
        .where('code', isEqualTo: code)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return Medicament.fromFirestore(snapshot.docs.first);
    }
    return null;
  }

  Future<bool> ajouterMedicament(Medicament m) async {
    try {
      await _firestore.collection(collectionName).add(m.toJson());
      return true;
    } catch (e) {
      print("Erreur ajout medicament: $e");
      return false;
    }
  }
}

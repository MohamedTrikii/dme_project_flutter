import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/patient.model.dart';

class PatientService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = "patient";

  // Get all patients
  Future<List<Patient>> listePatients() async {
    QuerySnapshot snapshot =
    await _firestore.collection(collectionName).get();

    return snapshot.docs.map((doc) {
      return Patient.fromJson({
        "id": doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    }).toList();
  }

  // Add patient
  Future<bool> ajouterPatient(Patient p) async {
    try {
      await _firestore.collection(collectionName).add(p.toJson());
      return true;
    } catch (e) {
      print("Erreur ajout patient: $e");
      return false;
    }
  }

  // Update patient
  Future<bool> modifierPatient(Patient p) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(p.id)
          .update(p.toJson());

      return true;
    } catch (e) {
      print("Erreur modification patient: $e");
      return false;
    }
  }

  // Delete patient
  Future<bool> supprimerPatient(Patient p) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(p.id)
          .delete();

      return true;
    } catch (e) {
      print("Erreur suppression patient: $e");
      return false;
    }
  }
}
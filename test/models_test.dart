import 'package:flutter_test/flutter_test.dart';

import 'package:dme_flutter/model/medicament.model.dart';
import 'package:dme_flutter/model/patient.model.dart';

void main() {
  group('Patient', () {
    test('fromJson reads every field and stringifies values', () {
      final patient = Patient.fromJson({
        'id': 42,
        'nom': 'Ben Ali',
        'prenom': 'Sami',
        'cin': 12345678,
        'email': 'sami@example.com',
        'tel': '+216 20 000 000',
        'diagnostic': 'Hypertension',
      });

      expect(patient.id, '42');
      expect(patient.nom, 'Ben Ali');
      expect(patient.prenom, 'Sami');
      expect(patient.cin, '12345678');
      expect(patient.email, 'sami@example.com');
      expect(patient.tel, '+216 20 000 000');
      expect(patient.diagnostic, 'Hypertension');
    });

    test('fromJson tolerates missing fields', () {
      final patient = Patient.fromJson({'nom': 'Trabelsi'});

      expect(patient.nom, 'Trabelsi');
      expect(patient.prenom, isNull);
      expect(patient.diagnostic, isNull);
    });

    test('toJson does not include the document id', () {
      final json = Patient(id: 'abc', nom: 'Ben Ali', prenom: 'Sami').toJson();

      expect(json.containsKey('id'), isFalse);
      expect(json['nom'], 'Ben Ali');
      expect(json['prenom'], 'Sami');
    });
  });

  group('Medicament', () {
    test('toJson exposes code, name and label', () {
      final json = Medicament(code: '6191234567890', nom: 'Doliprane', label: '500 mg').toJson();

      expect(json, {'code': '6191234567890', 'nom': 'Doliprane', 'label': '500 mg'});
    });
  });
}

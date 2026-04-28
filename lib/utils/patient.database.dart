/*import 'dart:async';
import 'package:path/path.dart';
//import 'package:sqflite/sqflite.dart';
import '../model/patient.model.dart';

class PatientDatabase {
  static Database? _database;

  initDB() async {
    if (_database == null) {
      String databasePath = await getDatabasesPath();
      String _path = join(databasePath, 'patient.db');
      _database = await openDatabase(_path, version: 1, onCreate: onCreate);
    }
  }

  onCreate(Patient db, int version) async {
    String sql = 'CREATE TABLE patient (id INTEGER PRIMARY KEY AUTOINCREMENT, nom STRING, prenom STRING, CIN STRING, email STRING, tel STRING, diagnostic STRING)';
    await db.execute(sql);
  }

  Future<List<Map<String, dynamic>>> recuperer() async {
    await initDB();
    return _database!.query(Patient.table);
  }

  Future<int> inserer(Patient patient) async {
    await initDB();
    return _database!.insert(Patient.table, patient.toJson());
  }

  Future<int> modifier(Patient patient) async {
    await initDB();
    return _database!.update(Patient.table, patient.toJson(), where: 'id = ?', whereArgs: [patient.id]);
  }

  Future<int> supprimer(Patient patient) async {
    await initDB();
    return _database!.delete(Patient.table, where: 'id = ?', whereArgs: [patient.id]);
  }
}

 */
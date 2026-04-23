import 'package:flutter/material.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({Key? key}) : super(key: key);

  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  List<Map<String, dynamic>> patients = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestion des Patients")),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final p = patients[index];
          return Card(
            child: ListTile(
              title: Text(p['nom']),
              subtitle: Text("Âge : ${p['age']}"),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    patients.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            patients.add({"nom": "Nouveau Patient", "age": 0});
          });
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/list_helper.dart';

import '../menu/drawer.widget.dart';
import '../model/patient.model.dart';
import '../services/patient.service.dart';
import 'ajout_modif_patient.page.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({Key? key}) : super(key: key);

  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  List<Map<String, dynamic>> patients = [];
  PatientService patientService = PatientService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestion des Patients")),
      drawer: MyDrawer(),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: FormHelper.submitButton(
                "Ajout",
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AjoutModifPatientPage(),
                    ),
                  ).then((value) {
                    setState(() {});
                  });
                },
                borderRadius: 10,
                btnColor: Colors.blue,
                borderColor: Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            _fetchData(),
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<Patient>> _fetchData() {
    return FutureBuilder<List<Patient>>(
      future: patientService.listePatients(),
      builder: (BuildContext context, AsyncSnapshot<List<Patient>> patients) {
        if (patients.hasData) return _buildDataTable(patients.data!);
        if (patients.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (patients.hasError) {
          print(patients.error);
          return Text("Erreur");
        }

        if (!patients.hasData || patients.data!.isEmpty) {
          return Text("Aucun patient");
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _buildDataTable(List<Patient> listPatients) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListUtils.buildDataTable(
        context,
        ["Nom", "Prenom", "Telephone", "Diagnostic", "Action"],
        ["nom", "prenom", "tel", "diagnostic", ""],
        false,
        0,
        listPatients,
            (Patient p) {
          // Modifier patient
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AjoutModifPatientPage(modifMode: true, patient: p),
            ),
          ).then((value) {
            setState(() {});
          });
        },
            (Patient p) {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Supprimer Patient"),
                content: const Text(
                  "Etes vous sur de vouloir supprimer ce patient?",
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FormHelper.submitButton(
                        "Oui",
                            () {
                          patientService.supprimerPatient(p).then((value) {
                            setState(() {
                              Navigator.of(context).pop();
                            });
                          });
                        },
                        width: 100,
                        borderRadius: 5,
                        btnColor: Colors.green,
                        borderColor: Colors.green,
                      ),
                      const SizedBox(width: 20),
                      FormHelper.submitButton(
                        "Non",
                            () {
                          Navigator.of(context).pop();
                        },
                        width: 100,
                        borderRadius: 5,
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        headingRowColor: Colors.orangeAccent,
        isScrollable: true,
        columnTextFontSize: 20,
        columnTextBold: false,
        columnSpacing: 50,
        onSort: (columnIndex, columnName, asc) {},
      ),
    );
  }
}

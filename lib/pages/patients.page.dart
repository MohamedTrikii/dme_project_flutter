import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/list_helper.dart';

import '../model/patient.model.dart';
import '../services/patient.service.dart';
import '../services/translation.service.dart';
import 'ajout_modif_patient.page.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  List<Map<String, dynamic>> patients = [];
  PatientService patientService = PatientService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TranslationService.getString('patients')),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: FormHelper.submitButton(
                TranslationService.getString('add'),
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
          return Text(TranslationService.getString('error'));
        }

        if (!patients.hasData || patients.data!.isEmpty) {
          return Text(TranslationService.getString('no_patients'));
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
        [
          TranslationService.getString('name'),
          TranslationService.getString('first_name'),
          TranslationService.getString('phone'),
          TranslationService.getString('diagnostic'),
          TranslationService.getString('action')
        ],
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
                title: Text(TranslationService.getString('delete_patient')),
                content: Text(
                  TranslationService.getString('confirm_delete_patient'),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FormHelper.submitButton(
                        TranslationService.getString('yes'),
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
                        TranslationService.getString('no'),
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

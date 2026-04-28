import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import '../model/patient.model.dart';
import '../services/patient.service.dart';

class AjoutModifPatientPage extends StatefulWidget {
  final Patient? patient;
  final bool modifMode;

  const AjoutModifPatientPage({Key? key, this.patient, this.modifMode = false})
    : super(key: key);

  @override
  State<AjoutModifPatientPage> createState() => _AjoutModifPatientPageState();
}

class _AjoutModifPatientPageState extends State<AjoutModifPatientPage> {
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  Patient patient = Patient();
  final PatientService patientService = PatientService();

  @override
  void initState() {
    super.initState();

    if (widget.modifMode && widget.patient != null) {
      patient = widget.patient!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.modifMode ? "Modifier Patient" : "Ajouter Patient"),
        backgroundColor: Colors.green,
      ),

      body: Form(key: globalKey, child: _formUI(context)),

      bottomNavigationBar: SizedBox(
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FormHelper.submitButton(
              widget.modifMode ? "Modifier" : "Ajouter",
              () async {
                if (validateAndSave()) {
                  bool success = false;

                  if (widget.modifMode) {
                    success = await patientService.modifierPatient(patient);
                  } else {
                    success = await patientService.ajouterPatient(patient);
                  }

                  if (success) {
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Erreur lors de l'opération"),
                      ),
                    );
                  }
                }
              },
              btnColor: Colors.green,
              borderColor: Colors.green,
              borderRadius: 10,
            ),

            FormHelper.submitButton(
              "Annuler",
              () {
                Navigator.pop(context);
              },
              btnColor: Colors.grey,
              borderColor: Colors.grey,
              borderRadius: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _formUI(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // NOM
          field(
            context: context,
            name: "nom",
            label: "Nom",
            icon: Icons.person,
            initial: patient.nom,
            onSaved: (val) => patient.nom = val,
          ),

          // PRENOM
          field(
            context: context,
            name: "prenom",
            label: "Prénom",
            icon: Icons.person_outline,
            initial: patient.prenom,
            onSaved: (val) => patient.prenom = val,
          ),

          // CIN
          field(
            context: context,
            name: "cin",
            label: "CIN",
            icon: Icons.badge,
            initial: patient.cin,
            onSaved: (val) => patient.cin = val,
          ),

          // EMAIL
          field(
            context: context,
            name: "email",
            label: "Email",
            icon: Icons.email,
            initial: patient.email,
            onSaved: (val) => patient.email = val,
          ),

          // TELEPHONE
          field(
            context: context,
            name: "tel",
            label: "Téléphone",
            icon: Icons.phone,
            initial: patient.tel,
            isNumeric: true,
            onSaved: (val) => patient.tel = val,
          ),

          // DIAGNOSTIC
          field(
            context: context,
            name: "diagnostic",
            label: "Diagnostic",
            icon: Icons.medical_information,
            initial: patient.diagnostic,
            onSaved: (val) => patient.diagnostic = val,
          ),
        ],
      ),
    );
  }

  Widget field({
    required BuildContext context,
    required String name,
    required String label,
    required IconData icon,
    required Function(String) onSaved,
    String? initial,
    bool isNumeric = false,
  }) {
    return FormHelper.inputFieldWidgetWithLabel(
      context,
      name,
      label,
      "",
      (value) {
        if (value.isEmpty) {
          return "* Required";
        }
        return null;
      },
      (value) {
        onSaved(value.toString().trim());
      },
      initialValue: initial ?? "",
      showPrefixIcon: true,
      prefixIcon: Icon(icon),
      borderRadius: 10,
      contentPadding: 15,
      fontSize: 14,
      labelFontSize: 14,
      paddingLeft: 0,
      paddingRight: 0,
      prefixIconPaddingLeft: 10,
      isNumeric: isNumeric,
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;

    if (form != null && form.validate()) {
      form.save();
      return true;
    }

    return false;
  }
}

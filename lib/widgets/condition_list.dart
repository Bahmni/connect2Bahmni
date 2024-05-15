import 'package:flutter/material.dart';
import '../utils/date_time.dart';
import '../domain/models/omrs_patient.dart';
import '../domain/condition_model.dart';
import '../services/emr_api_service.dart';

class PatientConditionList extends StatefulWidget {
  final String patientUuid;

  const PatientConditionList({super.key, required this.patientUuid});

  @override
  State<PatientConditionList> createState() => _PatientConditionListState();
}

class _PatientConditionListState extends State<PatientConditionList> {
  static const lblEncounterDiagnoses = 'Encounter Diagnoses';
  static const lblNoEncounterDiagnosisFound = 'None found';
  Future<List<ConditionModel>>? _futureDiagnoses;

  @override
  void initState() {
    super.initState();
    _futureDiagnoses = EmrApiService().searchCondition(OmrsPatient(uuid: widget.patientUuid));
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<ConditionModel>>(
        future: _futureDiagnoses,
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List<ConditionModel>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(height: 40, child: Center(child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator())));
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Failed to fetch Diagnoses"),);
          }
          List<ConditionModel> diagnoses = [];
          if (snapshot.hasData) {
            diagnoses = snapshot.data ?? [];
          }
          return ExpansionTile(
            title: const Text(lblEncounterDiagnoses, style: TextStyle(fontWeight: FontWeight.bold)),
            leading: const Icon(Icons.category),
            children: diagnoses.isEmpty ? [_displayEmpty()] : _encounterDiagnoses(diagnoses),
          );
        }
    );
  }

  List<Widget> _encounterDiagnoses(List<ConditionModel> diagnoses) {
    List<Widget> widgets = [];
    for (var dia in diagnoses) {
      var display = '${dia.code?.display}';
      var recordedAt = '';
      if (dia.recordedDate != null) {
        if (dia.recordedDate!.isUtc) {
          recordedAt = formattedDate(dia.recordedDate!);
        }
      }
      var info = '${dia.verificationStatus?.display?.toLowerCase()}, ${dia.order?.name.toLowerCase()} - $recordedAt';
      var conditionNotes = dia.note ?? '';

      var textSpan   = TextSpan(
        text: display,
        style: const TextStyle(color: Colors.black),
        children: <TextSpan>[
          TextSpan(text: '\n$info', style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12))
        ],
      );


      widgets.add(
        ListTile(
          leading: const Icon(Icons.arrow_right),
          title: Text.rich(textSpan),
          subtitle: Text(conditionNotes),
          //dense: true,
        ),

      );
    }
    return widgets;
  }

  Widget _displayEmpty() {
    return ListTile(
      title: Text(lblNoEncounterDiagnosisFound),
      dense: true,
    );
  }

}
import 'package:flutter/material.dart';
import '../utils/date_time.dart';
import '../domain/models/omrs_patient.dart';
import '../domain/condition_model.dart';
import '../services/emr_api_service.dart';

class PatientConditionList extends StatefulWidget {
  final String patientUuid;

  const PatientConditionList({Key? key, required this.patientUuid}) : super(key: key);

  @override
  _PatientConditionListState createState() => _PatientConditionListState();
}

class _PatientConditionListState extends State<PatientConditionList> {
  @override
  Widget build(BuildContext context) {
    Future<List<ConditionModel>> _futureDiagnoses = EmrApiService().searchCondition(OmrsPatient(uuid: widget.patientUuid));
    return FutureBuilder<List<ConditionModel>>(
        future: _futureDiagnoses,
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List<ConditionModel>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(child: Center(child: SizedBox(child: CircularProgressIndicator(), width: 15, height: 15)), height: 40);
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Failed to fetch Diagnoses"),);
          }
          List<ConditionModel> _diagnoses = [];
          if (snapshot.hasData) {
            _diagnoses = snapshot.data ?? [];
          }
          return Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: const Text('Encounter Diagnoses',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ..._encounterDiagnoses(_diagnoses),
            ],
            // initiallyExpanded: true,
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

      // The following does not work with scrolling.
      // TODO try with  https://pub.dev/packages/expandable or plain Expanded
      //   ExpansionTile(
      //     tilePadding: const EdgeInsets.fromLTRB(10,1,0,0),
      //     leading: const Icon(Icons.category),
      //     title: Text(displayText),
      //     children: dia.note == null ? []
      //     : <Widget>[
      //       ListTile(title: Text(dia.note!, style: Theme.of(context).textTheme.caption)),
      //     ],
      //   )

      widgets.add(
        ListTile(
          //title: Text('$displayCode \n$info'),
          leading: const Icon(Icons.category),
          title: Text.rich(textSpan),
          subtitle: Text(conditionNotes),
          //dense: true,
        ),

      );
    }
    return widgets;
  }

}
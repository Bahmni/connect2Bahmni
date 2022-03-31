import 'package:connect2bahmni/screens/models/condition_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../screens/models/consultation_model.dart';

class ConsultPadWidget extends StatefulWidget {
  const ConsultPadWidget({
    Key? key,
    this.patientUuid,
  }) : super(key: key);

  final Color color = const Color(0xFFFFE306);
  final String? patientUuid;

  @override
  State<ConsultPadWidget> createState() => _ConsultPadWidgetState();
}

class _ConsultPadWidgetState extends State<ConsultPadWidget> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.08,
        minChildSize: 0.08,
        //expand: false,
        builder:  (BuildContext context, ScrollController controller) {
          return Container(
            padding: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
              )
            ),
            child: ListView(
              padding: const EdgeInsets.all(5.0),
              controller: controller,
              children: [
                const SizedBox(height: 5,),
                const Divider(color: Colors.blueAccent,),
                Consumer<ConsultationModel>(
                  builder: (context, consultation, child) => _showConsultation(consultation, context)
                )
              ],
            ),
          );
        });
  }

  Widget _showConsultation(ConsultationModel consultation, BuildContext context) {
    var startTime = DateFormat('dd-MMM-yyy, hh:mm a').format(consultation.startTime);
    print('in showconsultation');
    String? display = _statusDisplays[consultation.status];
    return Container(
        color: Theme.of(context).colorScheme.onBackground,
        child: Column(
          children: [
            Text('$display', style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center,),
            const Divider(color: Colors.blueAccent,),
            ..._showDiagoses(consultation.diagnosisList),
            ..._showProblems(consultation.problemList),
          ],
        )
    );
  }

  final _statusDisplays = <ConsultationStatus, String> {
    ConsultationStatus.none:'Empty',
    ConsultationStatus.draft:'Draft',
    ConsultationStatus.finalized:'finalized',
  };

  List<Widget> _showDiagoses(List<ConditionModel> diagnosisList) {
    if (diagnosisList.isEmpty) return [];
    return diagnosisList.map((el) => _diagnosisWidget(el)).toList();
  }
  List<Widget> _showProblems(List<ConditionModel> problemList) {
    if (problemList.isEmpty) return [];
    return problemList.map((el) => _diagnosisWidget(el)).toList();
  }

  Widget _diagnosisWidget(ConditionModel condition) {
    String? display = condition.code?.display;
    display ??= '(Unknown)';
    String? status = condition.verificationStatus?.display;
    String? note = condition.note;
    note ??= '';


    return ExpansionTile(
      tilePadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      title: Text(display),
      subtitle: Text('Certainty: $status', style: Theme.of(context).textTheme.caption),
      children: <Widget>[
        ListTile(title: Text(note, style: Theme.of(context).textTheme.bodyText2)),
      ],
    );

    return ListTile(
      leading: const Icon(Icons.category, size: 24,),
      title: Text(display),
      subtitle: Text('Certainty: $status'),
      tileColor: Colors.red,
    );
  }
}



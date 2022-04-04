import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../utils/date_time.dart';
import 'package:provider/provider.dart';
import '../screens/models/consultation_model.dart';
import '../domain/condition_model.dart';
import '../providers/meta_provider.dart';
import 'condition.dart';
import '../utils/string_utils.dart';

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
    var lastUpdate = consultation.lastUpdateAt != null
        ? formattedDate(consultation.lastUpdateAt!)
        : '';
    String? display = _statusDisplays[consultation.status];
    return Container(
        color: Theme.of(context).colorScheme.onBackground,
        child: Column(
          children: [
            Text('$display $lastUpdate', style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center,),
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
    return diagnosisList.map((el) => _showCondition(el)).toList();
  }
  List<Widget> _showProblems(List<ConditionModel> problemList) {
    if (problemList.isEmpty) return [];
    return problemList.map((el) => _showCondition(el)).toList();
  }

  Widget _showCondition(ConditionModel condition) {
    String? display = condition.code?.display;
    display ??= '(Unknown)';
    String? keyId = condition.id ?? condition.code?.uuid;
    keyId ??= DateTime.now().millisecond.toString();

    var recordedAt = condition.recordedDate == null ? ''
      : formattedDate(condition.recordedDate!);
    var info = '${condition.verificationStatus?.display?.toLowerCase()}, ${condition.order?.name.toLowerCase()} - $recordedAt';
    var conditionNotes = truncate(condition.note ?? '');

    var textSpan   = TextSpan(
      text: display,
      style: const TextStyle(color: Colors.black),
      children: <TextSpan>[
        TextSpan(text: '\n$info', style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12))
      ],
    );
    return Slidable(
      key: Key(keyId),
      child: Container(
        color: Theme.of(context).colorScheme.onBackground,
        child: ListTile(
          leading: const Icon(Icons.category, size: 24,),
          title: Text.rich(textSpan),
          subtitle: Text(conditionNotes),
          tileColor: Colors.red,
        ),
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          _removeConditionAction(condition),
          _editConditionAction(condition),
        ],
      ),
    );
    // return Container(
    //   color: Theme.of(context).colorScheme.onBackground,
    //   child: ListTile(
    //     leading: const Icon(Icons.category, size: 24,),
    //     title: Text(display),
    //     subtitle: Text('Certainty: $status', style: Theme.of(context).textTheme.caption),
    //     tileColor: Colors.red,
    //   ),
    // );

    // return ListTile(
    //   leading: const Icon(Icons.category, size: 24,),
    //   title: Text(display),
    //   subtitle: Text('Certainty: $status', style: Theme.of(context).textTheme.caption),
    //   tileColor: Colors.red,
    // );
  }

  SlidableAction _removeConditionAction(ConditionModel condition) {
    return SlidableAction(
          onPressed: (context) {
            Provider.of<ConsultationModel>(context, listen: false).removeCondition(condition);
          },
          backgroundColor: const Color.fromRGBO(240, 39, 22, 0.6),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Remove',
        );
  }

  SlidableAction _editConditionAction(ConditionModel aCondition) {
    return SlidableAction(
      onPressed: (_) async {
        var vsCertainty = Provider.of<MetaProvider>(context, listen: false).conditionCertainty;
        final edited = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => ConditionWidget(condition: aCondition, valueSetCertainty: vsCertainty),
        ));
        if (edited != null) {
          var consultation = Provider.of<ConsultationModel>(context, listen: false);
          consultation.addCondition(edited as ConditionModel);
        }
      },
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      icon: Icons.edit,
      label: 'Edit',
    );
  }
}



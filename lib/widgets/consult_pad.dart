import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'condition.dart';
import '../utils/date_time.dart';
import '../utils/string_utils.dart';
import '../screens/models/consultation_model.dart';
import '../screens/models/consultation_board.dart';
import '../widgets/consultation_context.dart';
import '../domain/condition_model.dart';
import '../domain/models/omrs_obs.dart';

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
        builder: (BuildContext context, ScrollController controller) {
          return Container(
            padding: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                )),
            child: ListView(
              padding: const EdgeInsets.all(5.0),
              controller: controller,
              children: [
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  color: Colors.blueAccent,
                ),
                Consumer<ConsultationBoard>(
                    builder: (context, board, child) =>
                        _showConsultation(context, board.currentConsultation))
              ],
            ),
          );
        });
  }

  Widget _showConsultation(BuildContext context, ConsultationModel? consultation) {
    return Container(
        color: Theme.of(context).colorScheme.onBackground,
        child: Column(
          children: [
            _heading(context, consultation),
            const Divider(
              color: Colors.blueAccent,
            ),
            _consultationContext(context, consultation),
            ..._diagnoses(consultation?.diagnosisList),
            ..._problemList(consultation?.problemList),
            (consultation?.consultNote != null) ? _ObsListItem(consultNote: consultation!.consultNote!, sliding: true,) : const SizedBox(height: 1),
          ],
        ));
  }

  Widget _heading(BuildContext context, ConsultationModel? consultation) {
    var lastUpdateAt = consultation?.lastUpdateAt;
    var lastUpdateTxt = lastUpdateAt != null ? formattedDate(lastUpdateAt) : '';
    var currentStatus = consultation?.status ?? ConsultationStatus.none;
    String? display = _statusDisplays[currentStatus];
    return Text(
      '$display $lastUpdateTxt',
      style: Theme.of(context).textTheme.bodyText1,
      textAlign: TextAlign.center,
    );
  }


  Widget _consultationContext(BuildContext context, ConsultationModel? consultation) {
    if (consultation == null) {
      return const SizedBox(height: 1);
    }

    if (consultation.status == ConsultationStatus.none) {
      return const SizedBox(height: 1);
    }
    var visitInfo = consultation.visitType?.display;
    visitInfo ??= '?';
    var encounterInfo = consultation.encounterType?.display;
    encounterInfo ??= '?';

    var textSpan   = TextSpan(
      text: 'Visit: $visitInfo / $encounterInfo',
      style: const TextStyle(color: Colors.black),
    );

    return Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Row(children: [
          Expanded(child: Text.rich(textSpan)),
          _editContextButton(consultation.status)
        ]));
  }

  Widget _editContextButton(ConsultationStatus status) {
    return OutlinedButton(
          onPressed: () async {
            debugPrint('Edit Context');
            if (status == ConsultationStatus.finalized) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Already saved!")),
              );
              return;
            }
            var board = Provider.of<ConsultationBoard>(context, listen: false);
            final consultInfo = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConsultationContext(
                      encTypeUuid: board.currentConsultation!.encounterType?.uuid,
                      visitTypeUuid: board.currentConsultation!.visitType?.uuid,
                      patient: board.currentConsultation!.patient!,
                      isNew: false,
                  )),
            );
            if (consultInfo != null) {
              board.updateConsultContext(consultInfo['visitType'], consultInfo['encounterType']);
            }
          },
          child: const Text('edit'),
        );
  }

  final _statusDisplays = <ConsultationStatus, String>{
    ConsultationStatus.none: 'Empty',
    ConsultationStatus.draft: 'Draft',
    ConsultationStatus.finalized: 'finalized',
  };

  List<Widget> _diagnoses(List<ConditionModel>? diagnosisList) {
    if (diagnosisList == null) return [];
    if (diagnosisList.isEmpty) return [];
    return <Widget>[
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
      ...diagnosisList.map((el) => _conditionWidget(el)).toList()
    ];
  }

  List<Widget> _problemList(List<ConditionModel>? problemList) {
    if (problemList == null) return [];
    if (problemList.isEmpty) return [];
    return <Widget>[
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
          child: const Text('Problem List',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      ...problemList.map((el) => _conditionWidget(el)).toList()
    ];
  }

  Widget _conditionWidget(ConditionModel condition) {
    String? display = condition.code?.display;
    display ??= '(Unknown)';
    String? keyId = condition.id ?? condition.code?.uuid;
    keyId ??= DateTime.now().millisecond.toString();

    var recordedAt = condition.recordedDate == null
        ? ''
        : formattedDate(condition.recordedDate!);
    var info =
        '${condition.verificationStatus?.display?.toLowerCase()}, ${condition.order?.name.toLowerCase()} - $recordedAt';
    var conditionNotes = truncate(condition.note ?? '');

    var textSpan = TextSpan(
      text: display,
      style: const TextStyle(color: Colors.black),
      children: <TextSpan>[
        TextSpan(
            text: '\n$info',
            style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12))
      ],
    );
    return Slidable(
      key: Key(keyId),
      child: Container(
        color: Theme.of(context).colorScheme.onBackground,
        child: ListTile(
          leading: const Icon(
            Icons.category,
            size: 24,
          ),
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
  }

  SlidableAction _removeConditionAction(ConditionModel condition) {
    return SlidableAction(
      onPressed: (context) {
        Provider.of<ConsultationBoard>(context, listen: false)
            .removeCondition(condition);
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
        final edited = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConditionWidget(condition: aCondition),
            ));
        if (edited != null) {
          var board = Provider.of<ConsultationBoard>(context, listen: false);
          board.addCondition(edited as ConditionModel);
        }
      },
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      icon: Icons.edit,
      label: 'Edit',
    );
  }
}

class _ObsListItem extends StatelessWidget {
  final OmrsObs consultNote;
  final bool? sliding;

  const _ObsListItem({Key? key, required this.consultNote, this.sliding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _showObs(context, sliding ?? false);
  }

  Card _showObs(BuildContext context, bool shouldSlide) {
    var notes = consultNote.valueAsString ?? '';
    var _title = shouldSlide ? _slidablePane(context) : _simpleRow();

    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(1.0))),
      elevation: 2,
      //margin: const EdgeInsets.all(1.0),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: ExpansionTile(
            initiallyExpanded: true,
            backgroundColor: Colors.white,
            title: _title,
            controlAffinity: ListTileControlAffinity.leading,
            expandedAlignment: Alignment.topLeft,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(notes),
              ),
            ]
        ),
      ),
    );
  }

  Slidable _slidablePane(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      child: Container(
        color: Theme.of(context).colorScheme.onBackground,
        child: const ListTile(
          title: Text('Consultation Notes'),
          tileColor: Colors.red,
        ),
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              debugPrint('Edit note slide');
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          )
        ],
      ),
    );
  }

  Row _simpleRow() {
    return Row(children: [
      const Expanded(child: Text('Consultation Notes')),
      OutlinedButton(
        onPressed: () async {
          debugPrint('Edit note row');
        },
        child: const Text('edit'),
      )
    ]);
  }
}

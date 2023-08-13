import 'package:connect2bahmni/domain/models/bahmni_drug_order.dart';
import 'package:connect2bahmni/domain/models/omrs_order.dart';
import 'package:connect2bahmni/widgets/investigation_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'condition.dart';
import 'consultation_notes.dart';
import '../domain/models/form_definition.dart';
import '../utils/date_time.dart';
import '../utils/string_utils.dart';
import '../screens/models/consultation_model.dart';
import '../screens/models/consultation_board.dart';
import '../widgets/consultation_context.dart';
import '../domain/condition_model.dart';
import '../domain/models/omrs_obs.dart';
import 'medication_details.dart';

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
            ..._investigationList(consultation?.investigationList),
            ..._medicationList(consultation?.medicationList),
            (consultation?.consultNote != null) ? _ConsultationNote(consultNote: consultation!.consultNote!, sliding: true,) : const SizedBox(height: 1),
            ..._formList(consultation?.observationForms),
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
      style: Theme.of(context).textTheme.bodyLarge,
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
                      allowVisitTypeChange: !board.currentConsultation!.existingVisit,
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

  List<Widget> _investigationList(List<OmrsOrder>? investigationList) {
    if (investigationList == null) return [];
    if (investigationList.isEmpty) return [];
    return <Widget>[
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
          child: Text('Investigation List',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      ...investigationList.asMap().entries.map((el) {
        final index = el.key;
        final investigation = el.value;
        return _investigationWidget(investigation, index);
      }).toList()
    ];
  }

  Widget _investigationWidget(OmrsOrder investigation,int index){
    String? text = investigation.concept?.display;
    String? notes = investigation.commentToFulfiller;
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          _removeInvestigationAction(investigation),
          _editInvestigationAction(investigation, index),
        ],
      ),
      child: Container(
          color: Theme.of(context).colorScheme.onBackground,
          child: ListTile(
            leading: const Icon(
              Icons.medical_services_outlined,
              size: 24,
            ),
            title: Text('$text'),
            subtitle: Text('$notes'),
            tileColor: Colors.red,
          ),
      )
    );
  }

  List<Widget> _medicationList(List<BahmniDrugOrder>? medicationList) {
    if (medicationList == null) return [];
    if (medicationList.isEmpty) return [];
    return <Widget>[
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
          child: Text('Medication List',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      ...medicationList.asMap().entries.map((el) {
        final index = el.key;
        final medication = el.value;
        return _medicationWidget(medication, index);
      }).toList()
    ];
  }
  Widget _medicationWidget(BahmniDrugOrder medication,int index){
    String? text = medication.concept?.name;
    String? notes = medication.commentToFulfiller;
    String? units = medication.dosingInstructions?.dose.toString();
    String? doseUnits = medication.dosingInstructions?.doseUnits;
    String? startDate = medication.effectiveStartDate!=null ? DateFormat('dd-MMM-yyy').format(medication.effectiveStartDate!).toString():'  ';
    String? frequency = medication.dosingInstructions?.frequency;
    String? quantity = medication.dosingInstructions?.quantity?.floor().toString();
    String? quantityUnits = medication.dosingInstructions?.quantityUnits;
    String? route = medication.dosingInstructions?.route;
    String? duration = medication.duration.toString();
    String? durationUnits = medication.durationUnits;
    String? administrationInstructions = medication.dosingInstructions?.administrationInstructions;
    return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            _removeMedicationAction(medication),
            _editMedicationAction(medication, index),
          ],
        ),
        child: Container(
          color: Theme.of(context).colorScheme.onBackground,
          child: Column(
            children: [
              ListTile(
              leading: const Icon(
                Icons.medication_outlined,
                size: 24,
              ),
              title: Text('$text'),
              tileColor: Colors.red,
            ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$units $doseUnits,  $frequency,   $administrationInstructions'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$route,   Total: $quantity $quantityUnits'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('From: $startDate  ➤ $duration $durationUnits')),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('Note: $notes',maxLines: 4)),
                  ],
                ),
              ),
      ]
          ),
        )
    );
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
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          _removeConditionAction(condition),
          _editConditionAction(condition),
        ],
      ),
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
    );
  }
  SlidableAction _removeInvestigationAction(OmrsOrder investigation){
    return SlidableAction(
        onPressed: (context){
            Provider.of<ConsultationBoard>(context, listen: false)
                .removeInvestigation(investigation);
        },
        icon: Icons.delete,
        backgroundColor: Color.fromRGBO(240, 39, 22, 0.6),
      foregroundColor: Colors.white,
      label: 'Remove',
    );
  }
  SlidableAction _removeMedicationAction(BahmniDrugOrder medication){
    return SlidableAction(
      onPressed: (context){
        Provider.of<ConsultationBoard>(context, listen: false)
            .removeMedication(medication);
      },
      icon: Icons.delete,
      backgroundColor: Color.fromRGBO(240, 39, 22, 0.6),
      foregroundColor: Colors.white,
      label: 'Remove',
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

  SlidableAction _editInvestigationAction(OmrsOrder investigation,int index) {
    return SlidableAction(
      onPressed: (_) async {
        final edited = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InvestigationDetails(investigation: investigation),
            ));
        if (edited != null && context.mounted) {
          var board = Provider.of<ConsultationBoard>(context, listen: false);
          board.updateInvestigation(edited, index);
        }
      },
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      icon: Icons.edit,
      label: 'Edit',
    );
  }
  SlidableAction _editMedicationAction(BahmniDrugOrder medication,int index) {
    return SlidableAction(
      onPressed: (_) async {
        final edited = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MedicationDetails(medication: medication),
            ));
        if (edited != null && context.mounted) {
          var board = Provider.of<ConsultationBoard>(context, listen: false);
          board.updateMedication(edited, index);
        }
      },
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      icon: Icons.edit,
      label: 'Edit',
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
        if (edited != null && context.mounted) {
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

  List<Widget> _formList(Map<FormResource, List<OmrsObs>>? formObservations) {
    if (formObservations == null) return [];
    if (formObservations.isEmpty) return [];
    return <Widget>[
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
          child: Text('Form List',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      ...formObservations.keys.map((form) { return _obsFormWidget(form);}).toList()
    ];
  }

  Widget _obsFormWidget(FormResource form){
    String? text = form.name;
    return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            _removeObsForm(form),
            _editObsForm(form),
          ],
        ),
        child: Container(
          color: Theme.of(context).colorScheme.onBackground,
          child: ListTile(
            leading: const Icon(
              Icons.description_outlined,
              size: 24,
            ),
            title: Text(text),
            //subtitle: Text('$notes'),
            tileColor: Colors.red,
          ),
        )
    );
  }

  SlidableAction _removeObsForm(FormResource form){
    return SlidableAction (
      onPressed: (context){
        Provider.of<ConsultationBoard>(context, listen: false).removeObsForm(form);
      },
      icon: Icons.delete,
      backgroundColor: Color.fromRGBO(240, 39, 22, 0.6),
      foregroundColor: Colors.white,
      label: 'Remove',
    );
  }

  SlidableAction _editObsForm(FormResource form) {
    return SlidableAction(
      onPressed: (_) async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Not yet Implemented")),
        );
      },
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      icon: Icons.edit,
      label: 'Edit',
    );
  }
}

class _ConsultationNote extends StatelessWidget {
  final OmrsObs consultNote;
  final bool? sliding;

  const _ConsultationNote({Key? key, required this.consultNote, this.sliding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _showObs(context, sliding ?? false);
  }

  Card _showObs(BuildContext context, bool shouldSlide) {
    var notes = consultNote.valueAsString ?? '';
    var title = shouldSlide ? _slidablePane(context) : _simpleRow();

    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(1.0))),
      elevation: 2,
      //margin: const EdgeInsets.all(1.0),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: ExpansionTile(
            initiallyExpanded: true,
            backgroundColor: Colors.white,
            title: title,
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
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              var board = Provider.of<ConsultationBoard>(context, listen: false);
              var consultNote = board.currentConsultation?.consultNote;
              var notes = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConsultationNotesWidget(notes: consultNote?.valueAsString);
                  }
              );
              if (notes != null && context.mounted) {
                board.updateConsultationNotes(notes);
              }
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          )
        ],
      ),
      child: Container(
        color: Theme.of(context).colorScheme.onBackground,
        child: const ListTile(
          title: Text('Consultation Notes'),
          tileColor: Colors.red,
        ),
      ),
    );
  }

  Row _simpleRow() {
    return Row(children: [
      const Expanded(child: Text('Consultation Notes')),
      OutlinedButton(
        onPressed: () async {
          //debugPrint('Edit note row');
        },
        child: const Text('edit'),
      )
    ]);
  }
}

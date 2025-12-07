import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../domain/models/bahmni_drug_order.dart';
import '../domain/models/omrs_order.dart';
import '../domain/models/bahmni_appointment.dart';
import '../utils/app_failures.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bahmniForms/form_view.dart';
import '../widgets/consult_pad.dart';
import '../widgets/consultation_notes.dart';
import '../widgets/investigation_details.dart';
import '../widgets/investigation_search.dart';
import '../widgets/jitsi_meeting.dart';
import '../widgets/medication_details.dart';
import '../widgets/medication_search.dart';
import '../widgets/patient_chart.dart';
import '../providers/user_provider.dart';
import '../screens/models/consultation_model.dart';
import '../widgets/condition.dart';
import '../domain/condition_model.dart';
import '../domain/models/omrs_concept.dart';
import '../widgets/concept_search.dart';
import '../screens/models/consultation_board.dart';
import '../screens/models/patient_model.dart';
import '../utils/app_routes.dart';
import '../domain/models/omrs_location.dart';
import '../providers/auth.dart';
import '../widgets/consultation_context.dart';
import '../providers/meta_provider.dart';
import '../widgets/select_obs_form.dart';


class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardWidgetState();
}

class _PatientDashboardWidgetState extends State<PatientDashboard> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).user;
    var argument = ModalRoute.of(context)!.settings.arguments;
    if (argument == null) {
      return const Center(
        child: Text('Please select a patient first!')
      );
    }

    return ChangeNotifierProvider(
      create: (context) => ConsultationBoard(user!),
      child: _DashboardWidget(
          patient: argument as PatientModel,
          onConsultationSave: null,
      ),
    );
  }
}

typedef OnSaveConsultation = void Function();

class _DashboardWidget extends StatefulWidget {
  final PatientModel patient;
  final OnSaveConsultation? onConsultationSave;
  const _DashboardWidget({required this.patient, this.onConsultationSave});
  @override
  State<_DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<_DashboardWidget> {
  final _widgetState = GlobalKey<_DashboardWidgetState>();
  OmrsLocation? _currentLocation;

  @override
  Widget build(BuildContext context) {
    _currentLocation = Provider.of<AuthProvider>(context).sessionLocation;
    return Scaffold(
      key: _widgetState,
      //floatingActionButton: _floatingActions(),
      //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: _buildAppBar(context),
      drawer: appDrawer(context),
      body: _buildDraggableScrollable(),
      bottomNavigationBar: ConsultationActions(patient: widget.patient),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      //automaticallyImplyLeading: true,
      leading: IconButton(
        icon: const Icon(Icons.home),
        highlightColor: Colors.pink,
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.dashboard, (r) => false);
        },
      ),
      title: _displayHeading(),
      elevation: 0.1,
      actions: <Widget>[
        Consumer<ConsultationBoard>(
            builder: (context, board, child) {
              //good case for Selector?
              return board.currentConsultation == null
                  ? _startNewConsultAction(context)
                  : (board.currentConsultation!.status != ConsultationStatus.finalized) ? _saveConsultAction(context) : SizedBox();
            }
        ),
        _moreOptions()
      ],
    );
  }

  PopupMenuButton<String> _moreOptions() {
    return PopupMenuButton<String>(
      onSelected: (_) {},
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'scheduleAppointment',
            child: const Text('Schedule Appointment'),
            onTap: () => {},
          ),
          PopupMenuItem<String>(
            value: 'virtualAppointment',
            child: const Text('Start Virtual'),
            onTap: () {
              var appointment = BahmniAppointment(
                  uuid: const Uuid().v4(),
                  patient: Subject(
                      uuid: widget.patient.uuid,
                      name: widget.patient.fullName,
                      identifier: widget.patient.uuid)
              );
              //print('launching meeting');
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LaunchMeeting(event: appointment)),
              );
            },
          ),
          PopupMenuItem<String>(
            value: 'graphs',
            child: const Text('Graphs'),
            onTap: () => {},
          ),
          PopupMenuItem<String>(
            value: 'discardSession',
            child: const Text('Discard Session'),
            onTap: () => {},
          )
        ];
      },
    );
  }

  IconButton _startNewConsultAction(BuildContext context) {
    return IconButton(
      tooltip: 'New Consult',
      icon: const Icon(
        Icons.add_to_queue,
        //color: Colors.white,
      ),
      onPressed: () async {
        var board = Provider.of<ConsultationBoard>(context, listen: false);
        var consultEncTypeUuid = (board.currentConsultation == null)
            ? null
            : board.currentConsultation?.encounterType?.uuid;
        var consultVisitTypeUuid = (board.currentConsultation == null)
            ? null
            : board.currentConsultation?.visitType?.uuid;
        final consultInfo = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ConsultationContext(
                    encTypeUuid: consultEncTypeUuid,
                    visitTypeUuid: consultVisitTypeUuid,
                    patient: widget.patient,
                    isNew: true,
                  )),
        );
        if (consultInfo != null) {
          board.initNewConsult(
              widget.patient, _currentLocation, consultInfo['visitType'],
              consultInfo['encounterType'], consultInfo['existingVisit']);
        }
      },
    );
  }

  IconButton _saveConsultAction(BuildContext context) {
    return IconButton(
      tooltip: 'Save Draft',
      icon: const Icon(
        Icons.save_outlined,
        //color: Colors.white,
      ),
      onPressed: () async {
        var board = Provider.of<ConsultationBoard>(context, listen: false);
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        if (board.currentConsultation?.status == ConsultationStatus.finalized) {
          scaffoldMessenger.showSnackBar(const SnackBar(
              content: Text('Consultation is already finalized.')));
        } else {
          try {
            final value = await board.save();
            if (!mounted) return;
            var message = value
                ? 'Consultation Saved'
                : 'Could not save consultation';
            scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
            if (value && (widget.onConsultationSave != null)) {
              widget.onConsultationSave!();
            }
          } catch (error) {
            if (!mounted) return;
            if (error is String) {
              scaffoldMessenger.showSnackBar(SnackBar(content: Text(error)));
            } else if (error is Failure) {
              scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text(error.message)));
            } else if (error is List<Failure>) {
              scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text(error[0].message)));
            } else {
              scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('Could not save consultation')));
            }
          }
        }
      },
    );
  }

  // ignore: unused_element
  FloatingActionButton _floatingActions() {
    return FloatingActionButton(
      elevation: 8,
      onPressed: () => {},
      child: const Icon(Icons.event_outlined),
    );
  }

  Widget _displayHeading() {
    return const Text('Patient Chart');
    //return Text(widget.patient.fullName);
  }

  PatientChartWidget _buildPatientChart() {
    return PatientChartWidget(patient: widget.patient);
  }

  Widget _buildDraggableScrollable() {
    return SizedBox.expand(
        child: Stack(
            children: <Widget>[
              _buildPatientChart(),
              const ConsultPadWidget()
            ]
        )
    );
  }
}

class ConsultationActions extends StatelessWidget {
  final PatientModel patient;
  const ConsultationActions({super.key, required this.patient});
  final FloatingActionButtonLocation fabLocation = FloatingActionButtonLocation.endDocked;
  final NotchedShape shape = const CircularNotchedRectangle();

  static final List<FloatingActionButtonLocation> centerLocations =
  <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];


  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: shape,
      color: Colors.blueGrey,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            if (centerLocations.contains(fabLocation)) const Spacer(),
            IconButton(
              tooltip: 'Condition',
              icon: const Icon(Icons.category_outlined),
              onPressed: () {
                _addConditionToConsultation(context);
              },
            ),
            IconButton(
              tooltip: 'Medication',
              icon: const Icon(Icons.medication_outlined),
              onPressed: () => addMedicationToConsultation(context),
            ),
            IconButton(
              tooltip: 'Investigation',
              icon: const Icon(Icons.medical_services_outlined),
              onPressed: () => addInvestigationToConsultation(context),
            ),
            IconButton(
              tooltip: 'Notes',
              icon: const Icon(Icons.note_add_outlined),
              onPressed: () => _addConsultationNotes(context),
            ),
            _obsForm(context),
          ],
        ),
      ),
    );
  }

  Widget _obsForm(BuildContext context) {
    return IconButton(
      tooltip: 'Form',
      icon: Icon(
        Icons.description_outlined,
        //color: Colors.white,
      ),
      onPressed: () async {
        var board = _activeBoardToUpdate(context);
        if (board == null) return;
        final form = await showDialog(
          context: context,
          builder: (BuildContext context) => SelectObsFormWidget(),
        );
        if (form != null && context.mounted) {
          final obsList = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => ObservationForm(patient: patient, formToDisplay: form)),
          );
          if (obsList != null) {
            board.addFormObsList(form, obsList);
          }
        }
      },
    );
  }
   addInvestigationToConsultation(BuildContext context) async {
    var board = _activeBoardToUpdate(context);
    if (board == null) return;

    OmrsConcept? concept = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const InvestigationSearch()));
    if (context.mounted) {
      var newInvestigation = OmrsOrder(concept: concept);
      OmrsOrder? details = await Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => InvestigationDetails(investigation :newInvestigation),
          ));
      if (details != null) {
        board.addInvestigation(details);
      }
    }
    }
  addMedicationToConsultation(BuildContext context) async {
    var board = _activeBoardToUpdate(context);
    if (board == null) return;

    DrugConcept? concept = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MedicationSearch()));
    if (concept != null && context.mounted) {
      var drugOrder = BahmniDrugOrder(drug: DrugInfo(uuid: concept.uuid, name: concept.name));
      BahmniDrugOrder? details = await Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => MedicationDetails(medOrder: drugOrder),
          ));
      if (details != null) {
        board.addMedicationRequest(details);
      }
    }
    }

    Future<void> _addConditionToConsultation(BuildContext context) async {
    var board = _activeBoardToUpdate(context);
    if (board == null) return;

    OmrsConcept? concept = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => const ConceptSearch(searchType: 'Condition')),
    );

    if (context.mounted) {
      var newCondition = ConditionModel(code: concept);
      ConditionModel? condition = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ConditionWidget(condition: newCondition)),
      );
      if (condition != null) {
        board.addCondition(condition);
      }
    }
    }

  Future<void> _addConsultationNotes(BuildContext ctx) async {
    var board = _activeBoardToUpdate(ctx);
    if (board == null) return;
    var notes = await showDialog(
        context: ctx,
        builder: (BuildContext context) => ConsultationNotesWidget(notes: board.currentConsultation?.consultationNotes)
    );
    if (notes != null && ctx.mounted) {
      var consultNoteConcept = Provider.of<MetaProvider>(ctx, listen: false).consultNoteConcept;
      board.addConsultationNotes(notes, consultNoteConcept);
    }
  }

  ConsultationBoard? _activeBoardToUpdate(BuildContext context) {
    var board = Provider.of<ConsultationBoard>(context, listen: false);
    if (board.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please start a session first')));
      return null;
    }
    return board;
  }
}

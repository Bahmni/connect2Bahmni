import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/consult_pad.dart';
import '../widgets/patient_chart.dart';
import '../providers/user_provider.dart';
import '../screens/models/consultation_model.dart';
import '../widgets/condition.dart';
import '../domain/condition_model.dart';
import '../domain/models/omrs_concept.dart';
import '../widgets/concept_search.dart';
import '../providers/meta_provider.dart';
import '../screens/models/patient_view.dart';
import '../utils/app_routes.dart';
import '../domain/models/omrs_location.dart';
import '../providers/auth.dart';


class PatientDashboard extends StatefulWidget {
  const PatientDashboard({Key? key}) : super(key: key);

  @override
  _PatientDashboardWidgetState createState() => _PatientDashboardWidgetState();
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
      create: (context) => ConsultationModel(user!),
      child: _DashboardWidget(
          patient: argument as PatientModel,
          onConsultationSave: () {
            setState(() {});
          },
      ),
    );
  }
}

typedef OnSaveConsultation = void Function();

class _DashboardWidget extends StatefulWidget {
  final PatientModel patient;
  final OnSaveConsultation? onConsultationSave;
  const _DashboardWidget({Key? key, required this.patient, this.onConsultationSave}) : super(key: key);
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: _buildAppBar(context),
      drawer: appDrawer(context),
      body: _buildDraggableScrollable(),
      bottomNavigationBar: const ConsultationActions(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      //automaticallyImplyLeading: true,
      leading:  IconButton(
        icon: const Icon(Icons.home),
        highlightColor: Colors.pink,
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.dashboard, (r) => false);
        },
      ),
      title: _displayHeading(),
      elevation: 0.1,
      actions: <Widget>[
        Consumer<ConsultationModel>(
            builder: (context, consultation, child) {
              if (consultation.status == ConsultationStatus.none) {
                return _startNewConsultAction(context);
              }
              return _saveConsultAction(context);
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
            return {'New Appointment', 'Graphs'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
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
      onPressed: () {
          Provider.of<ConsultationModel>(context, listen: false).initialize(widget.patient, _currentLocation);
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
      onPressed: () {
        var currentConsultation = Provider.of<ConsultationModel>(context, listen: false);
        if (currentConsultation.status == ConsultationStatus.finalized) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Consultation is already finalized.')));
        } else {
          currentConsultation.save().then((value) {
            var message = value
                ? 'Consultation Saved'
                : 'Could not save consultation';
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)));
            if (widget.onConsultationSave != null) {
              widget.onConsultationSave!();
            }
          });
        }
      },
    );
  }

  // ignore: unused_element
  FloatingActionButton _floatingActions() {
    return FloatingActionButton(
      child: const Icon(Icons.event_outlined),
      elevation: 8,
      onPressed: () => {},
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
  const ConsultationActions({Key? key}) : super(key: key);
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
              icon: const Icon(Icons.category),
              onPressed: () {
                _navigateToAddCondition(context);
              },
            ),
            IconButton(
              tooltip: 'Medication',
              icon: const Icon(Icons.medication_sharp),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Investigation',
              icon: const Icon(Icons.assessment),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Notes',
              icon: const Icon(Icons.description),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  void _navigateToAddCondition(BuildContext context) async {
    final concept = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => const ConceptSearch(searchType: 'Condition')),
    );

    if (concept != null) {
      var vsCertainty = Provider.of<MetaProvider>(context, listen: false).conditionCertainty;
      var newCondition = ConditionModel(code: concept as OmrsConcept);
      final condition = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ConditionWidget(condition: newCondition, valueSetCertainty: vsCertainty)),
      );
      if (condition != null) {
        var consultation = Provider.of<ConsultationModel>(context, listen: false);
        consultation.addCondition(condition as ConditionModel);
      }
    }
  }
}


import 'package:connect2bahmni/domain/models/omrs_concept.dart';
import 'package:connect2bahmni/widgets/concept_search.dart';
import 'package:fhir/r4.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../screens/consult_pad.dart';
import '../screens/patient_chart.dart';
import '../providers/user_provider.dart';
import '../screens/models/consultation_model.dart';
import '../utils/arguments.dart';
import '../widgets/condition.dart';
import '../providers/auth.dart';
import '../screens/models/condition_model.dart';


class PatientDashboard extends StatefulWidget {
  const PatientDashboard({Key? key}) : super(key: key);

  @override
  _PatientDashboardWidgetState createState() => _PatientDashboardWidgetState();
}

class _PatientDashboardWidgetState extends State<PatientDashboard> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).user;
    //var currentLocation = Provider.of<AuthProvider>(context).sessionLocation;
    var args = ModalRoute.of(context)!.settings.arguments as SelectedPatient;
    return ChangeNotifierProvider(
      create: (context) => ConsultationModel(user!),
      child: _DashboardWidget(patient: _toFhirPatient(args)),
    );
  }
}

class _DashboardWidget extends StatefulWidget {
  final Patient patient;
  const _DashboardWidget({Key? key, required this.patient}) : super(key: key);
  @override
  State<_DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<_DashboardWidget> {
  final _widgetState = GlobalKey<_DashboardWidgetState>();
  @override
  Widget build(BuildContext context) {
    var panels = _buildDraggableScrollable();
    return Scaffold(
      key: _widgetState,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _displayHeading(),
        elevation: 0.1,
        actions: <Widget>[
          IconButton(
            tooltip: 'Consultation',
            icon: const Icon(
              Icons.add_comment,
              color: Colors.white,
            ),
            onPressed: () {
              Provider.of<ConsultationModel>(context, listen: false).initialize(widget.patient);
            },
          )
        ],
      ),
      drawer: appDrawer(context),
      body: panels,
      bottomNavigationBar: const ConsultationActions(),
    );
  }

  Widget _displayHeading() {
    String? patientName = widget.patient.name?.first.text;
    patientName ??= 'unknown';
    return Text(patientName);
  }

  PatientChartWidget _buildPatientChart() {
    var uuid = widget.patient.id?.value;
    var name = widget.patient.name?.first.text;
    return PatientChartWidget(patientUuid: uuid ?? '', patientName: name ?? '');
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

Patient _toFhirPatient(SelectedPatient args) {
  return Patient(
    id: Id(args.uuid),
    name: [
      HumanName(text: args.name)
    ],
  );
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
              icon: const Icon(Icons.add_to_photos_outlined),
              onPressed: () {
                _navigateToAddCondition(context);
              },
            ),
            IconButton(
              tooltip: 'Investigations',
              icon: const Icon(Icons.add_chart_rounded),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Notes',
              icon: const Icon(Icons.new_releases_sharp),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddCondition(BuildContext context) async {
    final concept = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => const ConceptSearch()),
    );

    if (concept != null) {
      final condition = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ConditionWidget(concept: concept as OmrsConcept)),
      );
      if (condition != null) {
        var consultation = Provider.of<ConsultationModel>(context, listen: false);
        consultation.addCondition(condition as ConditionModel);
      }
    }
  }
}


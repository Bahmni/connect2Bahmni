import 'package:fhir/r4.dart';
import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../screens/consult_pad.dart';
import '../screens/patient_chart.dart';
import '../providers/user_provider.dart';
import '../screens/models/consultation_model.dart';
import '../utils/arguments.dart';


class PatientDashboard extends StatefulWidget {
  const PatientDashboard({Key? key}) : super(key: key);

  @override
  _PatientDashboardWidgetState createState() => _PatientDashboardWidgetState();
}

class _PatientDashboardWidgetState extends State<PatientDashboard> {
  //final _pDbState = GlobalKey<_PatientDashboardWidgetState>();
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).user;
    var args = ModalRoute.of(context)!.settings.arguments as SelectedPatient;
    return ChangeNotifierProvider(
      create: (context) => ConsultationModel(user!),
      child: _DashboardWidget(patient: _toFhirPatient(args)),
    );
  }

}

class _DashboardWidget extends StatefulWidget {
  const _DashboardWidget({Key? key, required this.patient}) : super(key: key);
  final Patient patient;
  @override
  State<_DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<_DashboardWidget> {
  final _widgetState = GlobalKey<_DashboardWidgetState>();
  final MultiSplitViewController _controller = MultiSplitViewController(weights: [0.98, 0.02]);
  @override
  Widget build(BuildContext context) {
    MultiSplitViewTheme splitViewTheme = MultiSplitViewTheme(
        child: MultiSplitView(
          children: [_buildPatientChart(), const ConsultPadWidget()],
          controller: _controller,
        ),
        data: MultiSplitViewThemeData(
            dividerPainter: DividerPainters.grooved1(color: Colors.indigo[100]!, highlightedColor: Colors.indigo[900]!)
        )
    );
    return Scaffold(
      key: _widgetState,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Patient Charts'),
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
      body: splitViewTheme, //multiSplitView,
      bottomNavigationBar: const ConsultationActions(),
    );
  }

  PatientChartWidget _buildPatientChart() {
    var uuid = widget.patient.id?.value;
    var name = widget.patient.name?.first.text;
    return PatientChartWidget(patientUuid: uuid ?? '', patientName: name ?? '');
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



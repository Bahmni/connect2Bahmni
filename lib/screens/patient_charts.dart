import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class PatientCharts extends StatefulWidget {
  const PatientCharts({Key? key}) : super(key: key);

  @override
  _PatientChartsWidgetState createState() => _PatientChartsWidgetState();
}

class _PatientChartsWidgetState extends State<PatientCharts> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PatientChartArguments;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Patient Charts'),
        elevation: 0.1,
      ),
      drawer: appDrawer(context),
      body: Text('Patient Chart for ${args.name}, uuid = ${args.uuid}'),
    );
  }
}

class PatientChartArguments {
  final String uuid;
  final String name;
  PatientChartArguments(this.uuid, this.name);
}
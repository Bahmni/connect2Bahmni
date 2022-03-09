import 'package:flutter/material.dart';

class PatientCharts extends StatefulWidget {
  const PatientCharts({Key? key}) : super(key: key);

  @override
  _PatientChartsWidgetState createState() => _PatientChartsWidgetState();
}

class _PatientChartsWidgetState extends State<PatientCharts> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return const Text('abc');
  }
}
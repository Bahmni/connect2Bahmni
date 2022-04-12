import 'package:flutter/material.dart';

import 'visit_list.dart';
import '../screens/models/patient_view.dart';
import 'condition_list.dart';
import 'patient_info.dart';

class PatientChartWidget extends StatefulWidget {
  const PatientChartWidget({
    Key? key,
    required this.patient,
  }) : super(key: key);

  final Color color = const Color(0xFFFFE306);
  final PatientModel patient;

  @override
  State<PatientChartWidget> createState() => _PatientChartWidgetState();
}

class _PatientChartWidgetState extends State<PatientChartWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          //Flex(direction: Axis.horizontal,children: [PatientInfo(patient: widget.patient)]),
          PatientInfo(patient: widget.patient),
          PatientVisitList(patientUuid: widget.patient.uuid),
          PatientConditionList(patientUuid: widget.patient.uuid),
        ],
      )
    );
  }

}

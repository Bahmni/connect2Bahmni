import '../widgets/visit_list.dart';
import 'package:flutter/material.dart';

class PatientChartWidget extends StatefulWidget {
  const PatientChartWidget({
    Key? key,
    required this.patientUuid,
    required this.patientName,
  }) : super(key: key);

  final Color color = const Color(0xFFFFE306);
  final String patientUuid;
  final String patientName;

  @override
  State<PatientChartWidget> createState() => _PatientChartWidgetState();
}

class _PatientChartWidgetState extends State<PatientChartWidget> {
  @override
  Widget build(BuildContext context) {
    double _size = 1.0;
    return Container(
      transform: Matrix4.diagonal3Values(_size, _size, 1.0),
      child: Column(
        children: [
          PatientVisitList(patientUuid: widget.patientUuid),
        ],
      )
    );
  }
}

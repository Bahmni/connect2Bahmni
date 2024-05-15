import 'package:flutter/material.dart';
import '../screens/models/patient_model.dart';
import '../services/order_service.dart';
import '../widgets/medication_list.dart';
import '../widgets/patient_appointment_list.dart';
import 'condition_list.dart';
import 'lab_result_list.dart';
import 'obs_flow_sheet_view.dart';
import 'patient_info.dart';
import 'visit_list.dart';

class PatientChartWidget extends StatefulWidget {
  const PatientChartWidget({
    super.key,
    required this.patient,
  });

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
          MedicationList(patientUuid: widget.patient.uuid),
          LabResultsView(patientUuid: widget.patient.uuid),
          PatientAppointmentList(patientUuid: widget.patient.uuid),
          ObsFlowSheetView(patientUuid: widget.patient.uuid),
          SizedBox(height: 60),
        ],
      )
    );
  }

  @override
  void initState() {
    super.initState();
    OrderService().fetch(widget.patient.uuid).then((value) {

    });
  }
}


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../domain/models/lab_result.dart';
import '../services/order_service.dart';

class LabResultsView extends StatefulWidget {
  final String patientUuid;

  const LabResultsView({Key? key, required this.patientUuid}) : super(key: key);

  @override
  State<LabResultsView> createState() => _LabResultsViewState();
}

class _LabResultsViewState extends State<LabResultsView> {
  Future<List<LabResult>>? labResultsFuture;
  static const errFailedToFetchLabResults = "Failed to fetch lab results";
  static const lblLabInvestigations = 'Lab Investigations';
  static const lblNoInvestigationsFound = 'None found';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LabResult>>(
        future: labResultsFuture,
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List<LabResult>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(height: 40, child: Center(child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator())));
          }
          if (snapshot.hasError) {
            return const Center(child: Text(errFailedToFetchLabResults));
          }
          List<LabResult> results = [];
          if (snapshot.hasData) {
            results = snapshot.data ?? [];
          }
          return ExpansionTile(
            title: const Text(lblLabInvestigations, style: TextStyle(fontWeight: FontWeight.bold)),
            // collapsedShape: const RoundedRectangleBorder(
            //   borderRadius: BorderRadius.all(Radius.circular(15.0)),
            // ),
            // collapsedBackgroundColor: Colors.lightBlueAccent,
            leading: const Icon(Icons.medical_services_outlined),
            children: results.isEmpty ? [_displayEmpty()] : results.map((investigation) => _displayResult(investigation)).toList(),
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    labResultsFuture = OrderService().fetch(widget.patientUuid);
  }

  Widget _displayResult(LabResult investigation) {
    String resultText = '';
    TextStyle resultStyle = TextStyle(fontSize: 15, fontStyle: FontStyle.italic);
    if (investigation.result != null) {
        resultText = investigation.result.toString();
        if (investigation.abnormal != null && investigation.abnormal!) {
          resultStyle = const TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: Colors.red);
        }
    } else {
      resultText = '(pending)';
      resultStyle = const TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: Colors.grey);
    }


    var textSpan = TextSpan(
      text: investigation.name,
      style: const TextStyle(color: Colors.black),
      children: <TextSpan>[
          TextSpan(text: ' - $resultText', style: resultStyle),
      ],
    );

    return ListTile(
      leading: const Icon(Icons.arrow_right),
      title: Text.rich(textSpan),
      subtitle: investigation.accessionDateTime != null ? Text(formattedDate(investigation.accessionDateTime)) : const Text(''),
      //dense: true,
    );
  }

  Widget _displayEmpty() {
    return ListTile(
      title: Text(lblNoInvestigationsFound),
      dense: true,
    );
  }

  String formattedDate(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    var localDateTime = dateTime.isUtc ? dateTime.toLocal() : dateTime;
    return DateFormat('dd-MMM-yyy, hh:mm a').format(localDateTime);
  }
}
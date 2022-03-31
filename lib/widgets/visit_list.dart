import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../domain/models/oms_visit.dart';
import '../services/visits.dart';

class PatientVisitList extends StatefulWidget {
  final String patientUuid;

  const PatientVisitList({Key? key, required this.patientUuid}) : super(key: key);

  @override
  _PatientVisitListState createState() => _PatientVisitListState();
}

class _PatientVisitListState extends State<PatientVisitList> {
  @override
  Widget build(BuildContext context) {
    Future<List<OmrsVisit>> _patientVisits = Visits().visitsForPatient(widget.patientUuid);
    return FutureBuilder<List<OmrsVisit>>(
        future: _patientVisits,
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List<OmrsVisit>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Failed to load visits"),);
          }
          List<OmrsVisit> visits = [];
          if (snapshot.hasData) {
            visits = snapshot.data ?? [];
          }
          return ExpansionTile(
            title: const Text('Visits',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  // background: Paint()
                  //   ..strokeWidth = 30.0
                  //   ..color = Colors.grey
                  //   ..style = PaintingStyle.stroke
                  //   ..strokeJoin = StrokeJoin.round
                ),
            ),
            children: [..._buildVisitList(visits)],
            initiallyExpanded: true,
          );
        }
    );
  }

  _buildVisitList(List<OmrsVisit> visits) {
    List<Widget> columnContent = [];
    for (var v in visits) {
      var visitTime = DateFormat('dd-MMM-yyy, hh:mm a').format(v.startDatetime!);
      columnContent.add(
        ListTile(
          title: Text('${v.location!.name} - $visitTime'),
          leading: const Icon(Icons.location_city_rounded),
        ),
      );
    }
    return columnContent;
  }

}
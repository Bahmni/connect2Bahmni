import 'package:flutter/material.dart';
import '../utils/date_time.dart';
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
            return const SizedBox(child: Center(child: SizedBox(child: CircularProgressIndicator(), width: 15, height: 15)), height: 40);
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Failed to load visits"),);
          }
          List<OmrsVisit> visits = [];
          if (snapshot.hasData) {
            visits = snapshot.data ?? [];
          }
          return Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: const Text('Visits',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ),
              ..._buildVisitList(visits),
            ],
            // initiallyExpanded: true,
          );
        }
    );
  }

  List<Widget> _buildVisitList(List<OmrsVisit> visits) {
    List<Widget> columnContent = [];
    for (var v in visits) {
      var visitTime = formattedDate(v.startDatetime!);
      columnContent.add(
        ListTile(
          title: Text('${v.location!.name} - $visitTime'),
          leading: const Image(image: AssetImage('assets/facility_1.png'), width: 24.0, height: 24.0,),
          dense: true,
        ),
      );
    }
    return columnContent;
  }

}
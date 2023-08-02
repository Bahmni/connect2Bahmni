import 'package:flutter/material.dart';
import '../utils/date_time.dart';
import '../domain/models/oms_visit.dart';
import '../services/visits.dart';

class PatientVisitList extends StatefulWidget {
  final String patientUuid;

  const PatientVisitList({Key? key, required this.patientUuid}) : super(key: key);

  @override
  State<PatientVisitList> createState() => _PatientVisitListState();
}

class _PatientVisitListState extends State<PatientVisitList> {
  late Future<List<OmrsVisit>> patientVisits;
  static const lblVisits = 'Visits';
  static const lblNoVisitFound ='None found';

  @override
  void initState() {
    super.initState();
    patientVisits = Visits().visitsForPatient(widget.patientUuid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OmrsVisit>>(
        future: patientVisits,
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List<OmrsVisit>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(height: 40, child: Center(child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator())));
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Failed to load visits"),);
          }
          List<OmrsVisit> visits = [];
          if (snapshot.hasData) {
            visits = snapshot.data ?? [];
          }
          return ExpansionTile(
            title: const Text(lblVisits, style: TextStyle(fontWeight: FontWeight.bold)),
            leading: const Image(image: AssetImage('assets/facility_1.png'), width: 24.0, height: 24.0,),
            initiallyExpanded: true,
            children: visits.isEmpty ? [_displayEmpty()] : _buildVisitList(visits),
          );
          // return Column(
          //   children: [
          //     Align(
          //       alignment: Alignment.centerLeft,
          //       child: Container(
          //         padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
          //         child: const Text(lblVisits,
          //             style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ),
          //     ),
          //     ..._buildVisitList(visits),
          //   ],
          //   // initiallyExpanded: true,
          // );
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
          leading: const Icon(Icons.arrow_right),
          dense: true,
        ),
      );
    }
    return columnContent;
  }

  Widget _displayEmpty() {
    return ListTile(
      title: Text(lblNoVisitFound),
      dense: true,
    );
  }

}
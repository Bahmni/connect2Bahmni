import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import '../services/disease_summary.dart';

class ObsFlowSheetView extends StatefulWidget {
  final String patientUuid;

  const ObsFlowSheetView({Key? key, required this.patientUuid}) : super(key: key);

  @override
  State<ObsFlowSheetView> createState() => _ObsFlowSheetViewState();
}

class _ObsFlowSheetViewState extends State<ObsFlowSheetView> {
  Future<ObsFlowSheet>? obsFlowSheetFuture;
  static const errFailedToFetchObservationsFlowSheet = 'Failed to fetch observations in flow sheet';
  final List<String> flowSheetConceptNames = [];


  @override
  void initState() {
    super.initState();
    var conceptNames = dotenv.get('app.flowSheet.concepts', fallback: '');
    if (conceptNames.trim().isEmpty) {
      obsFlowSheetFuture = Future.value(ObsFlowSheet(dates: [], conceptsDataMap: {}));
    } else {
      flowSheetConceptNames.addAll(conceptNames.split(','));
      obsFlowSheetFuture = DiseaseSummaryService().fetch(widget.patientUuid, flowSheetConceptNames);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ObsFlowSheet>(
        future: obsFlowSheetFuture,
        builder: (BuildContext context, AsyncSnapshot<ObsFlowSheet> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(height: 40, child: Center(child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator())));
          }
          if (snapshot.hasError) {
            return const Center(child: Text(errFailedToFetchObservationsFlowSheet));
          }
          ObsFlowSheet? obsFlowSheet;
          if (snapshot.hasData) {
            obsFlowSheet = snapshot.data;
          }
          if (obsFlowSheet == null || obsFlowSheet.conceptsDataMap == null) {
            return SizedBox();
          }
          if (obsFlowSheet.dates == null || obsFlowSheet.dates!.isEmpty) {
            return SizedBox();
          }

          obsFlowSheet.dates!.sort((a, b) => a.compareTo(b));
          for (var element in obsFlowSheet.conceptsDataMap!.values) {
            element.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
          }

          var headers = [DataColumn(label: Text('Date'))];
          headers.addAll(obsFlowSheet.dates!.map((e) => DataColumn(label: _columnHeader(e))).toList());
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(5, 2, 2, 5),
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: headers,
                headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      return Theme.of(context).colorScheme.surfaceTint.withOpacity(0.3);
                    }),
                rows: List<DataRow>.generate(
                    obsFlowSheet.conceptsDataMap!.length,
                      (int index) => DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          // All rows will have the same selected color.
                          if (states.contains(MaterialState.selected)) {
                            return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                          }
                          // Even rows will have a grey color.
                          if (index.isEven) {
                            return Colors.grey.withOpacity(0.3);
                          }
                          return null; // Use default value for other states and odd rows.
                        }),
                    cells: _getRowCells(obsFlowSheet!, index, headers.length),
                  ),
                ),
              ),
            )
          );
        }
    );
  }

  Text _columnHeader(DateTime date) {
    var obsDate = date.isUtc ? date.toLocal() : date;
    var datePart = DateFormat('d MMM yy').format(obsDate);
    var timePart = DateFormat('hh:mm a').format(obsDate);

    return Text.rich(TextSpan(
      text: datePart,
      style: TextStyle(color: Colors.black),
      children: <TextSpan>[
        TextSpan(text: '\n$timePart',
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12))
      ],
    ));

  }

  List<DataCell> _getRowCells(ObsFlowSheet obsFlowSheet, int index, int columnLength) {
    var conceptName = obsFlowSheet.conceptsDataMap!.keys.elementAt(index);
    List<ObsData> obsDataList = obsFlowSheet.conceptsDataMap!.values.elementAt(index);
    List<DataCell> rowCells = [];
    rowCells.add(DataCell(Text(conceptName)));
    for (var obs in obsDataList) {
      var obsValue = obs.value;
      rowCells.add(DataCell(Text(obsValue)));
    }
    if (columnLength > rowCells.length) {
      rowCells.addAll(List.generate(columnLength-rowCells.length, (index) => DataCell(Text(''))));
    }
    return rowCells;
  }
}
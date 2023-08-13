
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../domain/models/bahmni_drug_order.dart';
import '../services/drug_orders.dart';

class MedicationList extends StatefulWidget {
  final String patientUuid;

  const MedicationList({Key? key, required this.patientUuid}) : super(key: key);

  @override
  State<MedicationList> createState() => _MedicationListState();
}

class _MedicationListState extends State<MedicationList> {
  Future<List<BahmniDrugOrder>>? drugListFuture;
  static const errFailedToFetchMedications = "Failed to fetch medication list";
  static const lblActiveMedications = 'Active Medications';
  static const lblNoMedRequestFound = 'None found';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BahmniDrugOrder>>(
        future: drugListFuture,
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List<BahmniDrugOrder>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(height: 40, child: Center(child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator())));
          }
          if (snapshot.hasError) {
            return const Center(child: Text(errFailedToFetchMedications));
          }
          List<BahmniDrugOrder> meds = [];
          if (snapshot.hasData) {
            meds = snapshot.data ?? [];
          }
          List<BahmniDrugOrder> activeMeds = activeMedications(meds);
          if (activeMeds.isEmpty) {
            return SizedBox();
          }
          return ExpansionTile(
            title: const Text(lblActiveMedications, style: TextStyle(fontWeight: FontWeight.bold)),
            leading: const Icon(Icons.medication_outlined),
            children: activeMeds.isEmpty ? [_displayEmpty()] : activeMeds.map((med) => _displayMedication(med)).toList(),
          );
          // return Column(
          //   children: [
          //     Align(
          //       alignment: Alignment.centerLeft,
          //       child: Container(
          //         padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
          //         child: const Text(lblActiveMedications,
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //     ),
          //     ...activeMeds.map((med) => _displayMedication(med)).toList(),
          //   ],
          //   // initiallyExpanded: true,
          // );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    drugListFuture = DrugOrders().fetch(widget.patientUuid);
  }

  List<BahmniDrugOrder> activeMedications(List<BahmniDrugOrder> meds) {
    var currentDate = DateTime.now();
    return meds.where((element) {
      if (element.effectiveStartDate == null) {
        return true;
      }
      return element.effectiveStopDate!.isAfter(currentDate);
    }).toList();
  }

  Widget _displayMedication(BahmniDrugOrder medicationOrder) {
    var display = medicationOrder.drug?.name;
    var effectivePeriod = '';
    if (medicationOrder.effectiveStartDate != null) {
        effectivePeriod = formattedDate(medicationOrder.effectiveStartDate!);
    }

    var textSpan = TextSpan(
      text: display,
      style: const TextStyle(color: Colors.black),
      children: <TextSpan>[
        TextSpan(text: ' $effectivePeriod', style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12))
      ],
    );

    return ListTile(
      leading: const Icon(Icons.arrow_right),
      title: Text.rich(textSpan),
      //subtitle: Text(conditionNotes),
      //dense: true,
    );
  }

  Widget _displayEmpty() {
    return ListTile(
      title: Text(lblNoMedRequestFound),
      dense: true,
    );
  }

  String formattedDate(DateTime dateTime) {
    var localDateTime = dateTime.isUtc ? dateTime.toLocal() : dateTime;
    return DateFormat('dd-MMM-yyy, hh:mm a').format(localDateTime);
  }
}
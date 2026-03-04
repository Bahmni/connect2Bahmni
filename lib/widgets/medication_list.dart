
import 'package:flutter/material.dart';
import 'package:fhir/r4.dart';
import 'package:intl/intl.dart';
import '../services/drug_orders.dart';

class MedicationList extends StatefulWidget {
  final String patientUuid;

  const MedicationList({super.key, required this.patientUuid});

  @override
  State<MedicationList> createState() => _MedicationListState();
}

class _MedicationListState extends State<MedicationList> {
  Future<Bundle>? drugListFuture;
  static const errFailedToFetchMedications = "Failed to fetch medication list";
  static const lblActiveMedications = 'Active Medications';
  static const lblNoMedRequestFound = 'None found';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Bundle>(
        future: drugListFuture,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<Bundle> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(height: 40, child: Center(child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator())));
          }
          if (snapshot.hasError) {
            return const Center(child: Text(errFailedToFetchMedications));
          }
          Bundle? bundle = snapshot.data;
          if (bundle?.entry?.isEmpty ?? true) {
            return const SizedBox();
          }
          return ExpansionTile(
            title: const Text(lblActiveMedications, style: TextStyle(fontWeight: FontWeight.bold)),
            leading: const Icon(Icons.medication_outlined),
            children: _buildMedicationList(bundle!),
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    drugListFuture = DrugOrders().fetch(widget.patientUuid);
  }

  List<Widget> _buildMedicationList(Bundle bundle) {
    List<Widget> meds = [];
    if (bundle.entry == null) return [_displayEmpty()];

    for (var entry in bundle.entry!) {
      if (entry.resource is MedicationRequest) {
        MedicationRequest request = entry.resource as MedicationRequest;
        if (_isActiveMedication(request)) {
          meds.add(_displayMedication(request));
        }
      }
    }
    return meds.isEmpty ? [_displayEmpty()] : meds;
  }

  bool _isActiveMedication(MedicationRequest request) {
    // Check if medication request is active based on status
    String? status = request.status?.toString();
    if (status == 'MedicationRequestStatus.active' || status == 'MedicationRequestStatus.on-hold') {
      // If there's a stop date, check if it's in the future
      if (request.dispenseRequest?.validityPeriod?.end?.value != null) {
        DateTime stopDate = request.dispenseRequest!.validityPeriod!.end!.value;
        if (stopDate.isBefore(DateTime.now())) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  Widget _displayMedication(MedicationRequest request) {
    var drugName = request.medicationCodeableConcept?.text ??
        request.medicationCodeableConcept?.coding?.first.display ??
        'Unknown Medication';
    var dosage = request.dosageInstruction?.first.text ?? '';
    var authoredDate = '';
    var authoredDateTime = request.authoredOn?.value;
    if (authoredDateTime != null) {
      authoredDate = formattedDate(authoredDateTime);
    }

    var textSpan = TextSpan(
      text: drugName,
      style: const TextStyle(color: Colors.black),
      children: <TextSpan>[
        TextSpan(text: ' $authoredDate', style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12))
      ],
    );

    return ListTile(
      leading: const Icon(Icons.arrow_right),
      title: Text.rich(textSpan),
      subtitle: dosage.isNotEmpty ? Text(dosage) : null,
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
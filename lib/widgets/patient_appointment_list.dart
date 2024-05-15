
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../domain/models/bahmni_appointment.dart';
import '../services/bahmni_appointments.dart';

class PatientAppointmentList extends StatefulWidget {
  final String patientUuid;

  const PatientAppointmentList({super.key, required this.patientUuid});

  @override
  State<PatientAppointmentList> createState() => _PatientAppointmentListState();
}

class _PatientAppointmentListState extends State<PatientAppointmentList> {
  Future<List<BahmniAppointment>>? appointmentsFuture;
  static const errFailedToFetchAppointments = "Failed to fetch appointments";
  static const lblUpcomingAppointments = 'Upcoming Appointments';
  static const lblNoAppointmentFound = 'None found';

  @override
  void initState() {
    super.initState();
    appointmentsFuture = Appointments().forPatient(widget.patientUuid, DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BahmniAppointment>>(
        future: appointmentsFuture,
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List<BahmniAppointment>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(height: 40, child: Center(child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator())));
          }
          if (snapshot.hasError) {
            return const Center(child: Text(errFailedToFetchAppointments));
          }
          List<BahmniAppointment> results = [];
          if (snapshot.hasData) {
            results = snapshot.data ?? [];
          }
          return ExpansionTile(
            title: const Text(lblUpcomingAppointments, style: TextStyle(fontWeight: FontWeight.bold)),
            leading: const Icon(Icons.access_alarm_outlined),
            children: results.isEmpty ? [_displayEmpty()] : results.map((appointment) => _displayAppointmentInfo(appointment)).toList(),
          );
        }
    );
  }

  Widget _displayAppointmentInfo(BahmniAppointment appointment) {
    String info = appointment.startDateTime != null ? formattedDate(appointment.startDateTime) : '';
    String providerNames = appointment.providers?.where((provider) => provider.name != null).map((e) => e.name).join(', ') ?? '';
    var textSpan = TextSpan(
      text: appointment.service?.name,
      style: const TextStyle(color: Colors.black),
    );
    return ListTile(
      leading: const Icon(Icons.arrow_right),
      title: Text.rich(textSpan),
      subtitle: Text('$info - $providerNames'),
      dense: true,
    );
  }

  Widget _displayEmpty() {
    return ListTile(
      title: Text(lblNoAppointmentFound),
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
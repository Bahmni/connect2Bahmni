import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/flutter_day_view_calendar.dart';
import '../domain/models/bahmni_appointment.dart';
import '../services/bahmni_appointments.dart';
import '../utils/shared_preference.dart';
import '../widgets/app_drawer.dart';

class MyAppointmentsWidget extends StatefulWidget {
  const MyAppointmentsWidget({Key? key}) : super(key: key);

  @override
  _MyAppointmentsWidgetState createState() => _MyAppointmentsWidgetState();
}

class _MyAppointmentsWidgetState extends State<MyAppointmentsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<BahmniAppointment>> _futureAppointments;
  //DateTime _forDate = DateTime.now().add(const Duration(days: -1));
  DateTime _forDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    print('fetching for date: $_forDate');
    _futureAppointments = fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    print('Building appointments widget');
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Appointments'),
          elevation: 0.1,
        ),
        drawer: appDrawer(),
        body: _appointmentsDayView(),
    );
  }

  FutureBuilder<List<BahmniAppointment>> _appointmentsDayView() {
    return FutureBuilder<List<BahmniAppointment>>(
      future: _futureAppointments,
      initialData: const [],
      builder: (BuildContext context, AsyncSnapshot<List<BahmniAppointment>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          //write to log
          return const Center(child: Text("Failed to load appointments"),);
        }
        if (snapshot.hasData) {
          return dayViewCalendar(snapshot, _forDate, _navigate);
        }
        return const CircularProgressIndicator();
      },
    );

  }

  void _navigate(DateTime date) {
    print('fetching for date: ${date.add(const Duration(days: 1))}');
    setState(() {
      _forDate = date.add(const Duration(days: 1));
      _futureAppointments = fetchAppointments();
    });
  }

  Future<List<BahmniAppointment>> fetchAppointments() => Appointments().allAppointments(_forDate, () => UserPreferences().getSessionId());

}




import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/ss_calendar_view.dart' as sscv;
import '../domain/models/bahmni_appointment.dart';
import '../services/bahmni_appointments.dart';
import '../widgets/app_drawer.dart';
import '../utils/app_failures.dart';
import '../utils/app_routes.dart';

class AppointmentsCalendar extends StatefulWidget {
  const AppointmentsCalendar({Key? key}) : super(key: key);

  @override
  State<AppointmentsCalendar> createState() => _AppointmentsCalendarState();
}

class _AppointmentsCalendarState extends State<AppointmentsCalendar> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<BahmniAppointment>> _futureAppointments;
  DateTime _forDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    debugPrint('fetching for date: $_forDate');
    _futureAppointments = fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building appointments widget');
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          //  automaticallyImplyLeading: false,
          title: const Text('Appointments'),
          elevation: 0.1,
          actions: <Widget>[
            IconButton(
              tooltip: 'Consultation',
              icon: const Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
              },
            )
          ],
        ),
        drawer: appDrawer(context),
        body: _appointmentsDayView(),
    );
  }

  FutureBuilder<List<BahmniAppointment>> _appointmentsDayView() {
    return FutureBuilder<List<BahmniAppointment>>(
      future: _futureAppointments,
      initialData: const [],
      builder: (BuildContext context, AsyncSnapshot<List<BahmniAppointment>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          //write to log
          String errorMsg = _snapshotError(snapshot.error!);
          return Center(child: Text('Failed to load appointments. $errorMsg'),);
        }
        if (snapshot.hasData) {
          return sscv.myAppointmentWidget(snapshot);
          //return fdvc.dayViewCalendar(snapshot, _forDate, _navigate);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );

  }

  // ignore: unused_element
  void _navigate(DateTime date) {
    debugPrint('fetching for date: ${date.add(const Duration(days: 1))}');
    setState(() {
      _forDate = date.add(const Duration(days: 1));
      _futureAppointments = fetchAppointments();
    });
  }

  Future<List<BahmniAppointment>> fetchAppointments() => Appointments().allAppointments(_forDate);

  String _snapshotError(Object error) {
    if (error is Failure) {
      return '${error.message}. response code:${error.errorCode}';
    }
    return error.toString();
  }

}




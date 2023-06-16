import 'package:flutter/material.dart';
import '../utils/date_time.dart';
import '../services/bahmni_appointments.dart';
import '../domain/models/bahmni_appointment.dart';

class AppointmentsListView extends StatefulWidget {
  final String? practitionerUuid;
  const AppointmentsListView({Key? key, this.practitionerUuid}) : super(key: key);

  @override
  State<AppointmentsListView> createState() => _AppointmentsListViewState();
}

class _AppointmentsListViewState extends State<AppointmentsListView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<BahmniAppointment>> _futureAppointments;

  @override
  void initState() {
    super.initState();
    final DateTime current = DateTime.now();
    final DateTime fromDate = DateTime(current.year, current.month, current.day);
    final DateTime tillDate = fromDate.add(const Duration(days: 1)).subtract(const Duration(seconds: 1));
    _futureAppointments = Appointments().forPractitioner(widget.practitionerUuid, fromDate, tillDate);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BahmniAppointment>>(
        future: _futureAppointments,
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List<BahmniAppointment>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              //write to log
              return const Center(child: Text("Failed to load appointments"),);
            }
            if (snapshot.hasData) {
              return Column (
                children: _upcomingAppointments(context, snapshot.data),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }
    );
  }

  List<Padding> _upcomingAppointments(BuildContext context, List<BahmniAppointment>? appointments) {
    var list = appointments ?? [];
    return list.map((e) {
      return createAppointmentWidget(context, e);
    }).toList();
  }

  Padding createAppointmentWidget(BuildContext context, BahmniAppointment appointment) {
    return
      Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 12),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.92,
        height: 70,
        decoration: BoxDecoration(color: const Color(0xFFF4F5F7), borderRadius: BorderRadius.circular(8),),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding:
              const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: const Color(0x6639D2C0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                  child: Icon(Icons.event, size: 24,),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.patient.name,
                      style: Theme.of(context).textTheme.titleMedium?.merge(const TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Color(0xFF1E2429),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(formattedTime(appointment.startDateTime!),
                        style: Theme.of(context).textTheme.bodyLarge?.merge(const TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF090F13),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'M 22',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.titleSmall?.merge(const TextStyle(
                      fontFamily: 'Lexend Deca',
                      color: Color(0xFF39D2C0),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                    child: Text(
                      'Appointment',
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodyLarge?.merge(const TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Color(0xFF090F13),
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../domain/models/bahmni_appointment.dart';
import '../services/bahmni_appointments.dart';
import '../utils/debouncer.dart';
import '../providers/user_provider.dart';
import '../domain/models/user.dart';
import '../screens/models/patient_model.dart';
import '../services/patients.dart';
import '../utils/app_routes.dart';
import '../utils/date_time.dart';
import 'jitsi_wrapper_meeting.dart';

CalendarControllerProvider calendarProvider(BuildContext context, AsyncSnapshot<List<BahmniAppointment>> snapshot) {
  return CalendarControllerProvider<BahmniAppointment>(
    controller: EventController<BahmniAppointment>()..addAll(_eventList(snapshot.data)),
    child: _bahmniAppointmentsDayWidget([]),
  );
}

Widget myAppointmentWidget(AsyncSnapshot<List<BahmniAppointment>> snapshot) {
  return _bahmniAppointmentsDayWidget(snapshot.data ?? []);
}


List<CalendarEventData<BahmniAppointment>> _eventList(List<BahmniAppointment>? appointmentList) {
  if (appointmentList == null) {
    return [];
  }
  return appointmentList.map((event) {
    return CalendarEventData(
      date: event.startDateTime!,
      event: event,
      title: event.patient.name,
      //description: "Today is project meeting.",
      startTime: event.startDateTime,
      endTime: event.endDateTime,
    );
  }).toList();
}

Widget _bahmniAppointmentsDayWidget(List<BahmniAppointment> eventList) {
  return Scaffold(
    floatingActionButton: FloatingActionButton(
      elevation: 8,
      onPressed: () async {
//        final event =
//        await context.pushRoute<CalendarEventData<Event>>(CreateEventPage(
//          withDuration: true,
//        ));
//        if (event == null) return;
//        CalendarControllerProvider.of<BahmniAppointment>(context).controller.add(event);
      },
      child: const Icon(Icons.add),
    ),
    body: AppointmentsDayView(initialList: eventList),
  );
}


class AppointmentsDayView extends StatefulWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;
  final List<BahmniAppointment>? initialList;

  const AppointmentsDayView({
    super.key,
    this.state,
    this.width,
    this.initialList,
  });

  @override
  State<AppointmentsDayView> createState() => _AppointmentsDayViewState();
}

class _AppointmentsDayViewState extends State<AppointmentsDayView> {
  final Map<String, bool> history = <String, bool>{};
  final EventController<BahmniAppointment?> controller = EventController<BahmniAppointment?>();
  User? _user;
  final heightPerMinute = 1.7;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<UserProvider>(context, listen: false).user;
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialList != null) {
      controller.addAll(_eventList(widget.initialList));
      //TODO, pass the initial date as state
      history.putIfAbsent(keyForDate(DateTime.now()), () => true);
    }
    var currentHour = DateTime.now().hour;
    return DayView<BahmniAppointment?>(
      onPageChange: (date, page) => browseToDate(date),
      key: widget.state,
      controller: controller,
      width: widget.width,
      heightPerMinute: heightPerMinute,
      scrollOffset: heightPerMinute*60*currentHour,
      eventTileBuilder: _defaultEventTileBuilder,
      onEventTap: (List<CalendarEventData<Object?>> events, DateTime date) {
        if (events.isNotEmpty) {
          var event = events.single.event as BahmniAppointment;
          _showEventInfoDialog(context, event).then((value) async {
            if (value == 'Charts') {
              final navigator = Navigator.of(context);
              var patientModel = await _patientUuidFromEvent(event);
              navigator.pushNamed(AppRoutes.patients, arguments: patientModel);
              //Navigator.pushNamed(context, AppRoutes.patients, arguments: patientModel);
            }
            if (value == 'Join') {
              //joinJitsiMeeting(event, _user!);
              joinJitsiWrapperMeeting(event, _user!);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => LaunchMeeting(event: _event)),
              // );
            }
          });
        }
      },

    );
  }

  Future<String?> _showEventInfoDialog(BuildContext context, BahmniAppointment event) {
    var isTeleConsult = true;//event.teleconsultation ?? false;
    List<Widget> actions = [];
    actions.add(TextButton(
      onPressed: () => Navigator.pop(context, 'OK'),
      child: const Text('OK'),
    ));
    actions.add(TextButton(
      onPressed: () => Navigator.pop(context, 'Charts'),
      child: const Text('View Charts'),
    ));
    if (isTeleConsult) {
      actions.add(TextButton(
        onPressed: () => Navigator.pop(context, 'Join'),
        child: const Text('Join'),
      ));
    }
    var starTime = formattedTime(event.startDateTime!);
    var endTime = formattedTime(event.endDateTime!);
    var description = '${event.patient.name} ($starTime - $endTime)';
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Appointment'),
        content: Text(description),
        actions: actions
      ),
    );
  }

  void browseToDate(DateTime date) {
    fetchAppointmentsForDate(date);
  }

  void fetchAppointmentsForDate(DateTime date) {
    Debouncer().run(() {
      var dateKey = keyForDate(date);
      bool alreadyFetched = history[dateKey] ?? false;
      if (!alreadyFetched) {
        var endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);
        Appointments().forPractitioner(_user?.provider?.uuid, date, endDate).then((response) {
          if (response.isNotEmpty) {
            controller.addAll(_eventList(response));
          }
          history.putIfAbsent(dateKey, () => true);
        });
      } else {
        history.putIfAbsent(dateKey, () => true);
      }
    });
  }

  String keyForDate(DateTime date) => '${date.year}${date.month}${date.day}';

  Future<PatientModel?> _patientUuidFromEvent(BahmniAppointment? event) async {
    if (event == null) return Future.value(null);
    var omrsPatient = await Patients().withUuid(event.patient.uuid);
    return omrsPatient != null ? Future.value(PatientModel(omrsPatient.toFhir())) : Future.value(null);
  }
}

Widget _defaultEventTileBuilder(
    DateTime date,
    List<CalendarEventData<Object?>> events,
    Rect boundary,
    DateTime startDuration,
    DateTime endDuration,
    ) {

  if (events.isNotEmpty) {
    return RoundedEventTile(
      borderRadius: BorderRadius.circular(6.0),
      title: truncateWithEllipsis(10, events[0].title),
      totalEvents: events.length - 1,
      description: events[0].description,
      //padding: const EdgeInsets.all(2.0),
      padding: const EdgeInsets.fromLTRB(5, 2, 2, 0),
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9.0, color: Colors.white),
      backgroundColor: events[0].color,
      margin: const EdgeInsets.all(2.0),
    );
  } else {
    return Container();
  }
}

String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
}

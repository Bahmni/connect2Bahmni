import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


import '../domain/models/bahmni_appointment.dart';
import '../services/bahmni_appointments.dart';
import '../utils/debouncer.dart';
import '../providers/user_provider.dart';
import '../domain/models/user.dart';
import '../widgets/jitsi_meeting.dart';

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
    debugPrint('appointment found. name = ${event.patient.name}, start = ${event.startDateTime}, end = ${event.endDateTime}');
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
      child: const Icon(Icons.add),
      elevation: 8,
      onPressed: () async {
//        final event =
//        await context.pushRoute<CalendarEventData<Event>>(CreateEventPage(
//          withDuration: true,
//        ));
//        if (event == null) return;
//        CalendarControllerProvider.of<BahmniAppointment>(context).controller.add(event);
      },
    ),
    body: AppointmentsDayView(initialList: eventList),
  );
}


class AppointmentsDayView extends StatefulWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;
  final List<BahmniAppointment>? initialList;

  const AppointmentsDayView({
    Key? key,
    this.state,
    this.width,
    this.initialList,
  }) : super(key: key);

  @override
  State<AppointmentsDayView> createState() => _AppointmentsDayViewState();
}

class _AppointmentsDayViewState extends State<AppointmentsDayView> {
  final Map<String, bool> history = <String, bool>{};

  final EventController<BahmniAppointment> controller = EventController<BahmniAppointment>();

  User? _user;

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<UserProvider>(context).user;
    if (widget.initialList != null) {
      controller.addAll(_eventList(widget.initialList));
      //TODO, pass the initialdate as state
      history.putIfAbsent(keyForDate(DateTime.now()), () => true);
    }

    return DayView<BahmniAppointment>(
      onPageChange: (date, page) => browseToDate(date),
      key: widget.state,
      controller: controller,
      width: widget.width,
      heightPerMinute: 1.7,
      eventTileBuilder: _defaultEventTileBuilder,
      onEventTap: (events, date) {
        debugPrint('Event tapped : $events');
        if (events.isNotEmpty) {
          _showEventInfoDialog(context, events.single.event!);
        }
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const LaunchMeeting()),
        // );
      },
    );
  }

  Future<String?> _showEventInfoDialog(BuildContext context, BahmniAppointment event) {
    var _isTeleConsult = event.teleconsultation ?? false;
    List<Widget> _actions = [];
    _actions.add(TextButton(
      onPressed: () => Navigator.pop(context, 'OK'),
      child: const Text('OK'),
    ));
    _actions.add(TextButton(
      onPressed: () => Navigator.pop(context, 'Charts'),
      child: const Text('View Charts'),
    ));
    if (_isTeleConsult) {
      _actions.add(TextButton(
        onPressed: () {
          Navigator.pop(context, 'Join');
          joinJitsiMeeting(event, _user!);
        },
        child: const Text('Join'),
      ));
    }
    var _starTime = DateFormat('hh:mm a').format(event.startDateTime!);
    var _endTime = DateFormat('hh:mm a').format(event.endDateTime!);
    var _description = '${event.patient.name} ($_starTime - $_endTime)';
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Appointment'),
        content: Text(_description),
        actions: _actions
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
        Appointments().allAppointments(date)
            .then((response) {
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
}

Widget _defaultEventTileBuilder(
    DateTime date,
    List<CalendarEventData<BahmniAppointment>> events,
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
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';


import '../domain/models/bahmni_appointment.dart';
import '../services/bahmni_appointments.dart';
import '../utils/debouncer.dart';
import '../utils/shared_preference.dart';

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
  print('eventList called .... ');
  if (appointmentList == null) {
    return [];
  }
  return appointmentList.map((event) {
    print('appointment found. name = ${event.patient.name}, start = ${event.startDateTime}, end = ${event.endDateTime}');
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
        print('Add clicked');
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


class AppointmentsDayView extends StatelessWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;
  final List<BahmniAppointment>? initialList;
  final Map<String, bool> history = <String, bool>{};
  final EventController<BahmniAppointment> controller = EventController<BahmniAppointment>();

  AppointmentsDayView({
    Key? key,
    this.state,
    this.width,
    this.initialList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Rendering Day view widget');

    if (initialList != null) {
      controller.addAll(_eventList(initialList));
      //TODO, pass the initialdate as state
      history.putIfAbsent(keyForDate(DateTime.now()), () => true);
    }

    return DayView<BahmniAppointment>(
      onPageChange: (date, page) => browseToDate(date),
      key: state,
      controller: controller,
      width: width,
      heightPerMinute: 1.7,
      eventTileBuilder: _defaultEventTileBuilder,
      onEventTap: (events, date) => print('Event tapped : $events'),
    );
  }

  void browseToDate(DateTime date) {
    print('Navigated to date = $date');
    fetchAppointmentsForDate(date);

  }

  void fetchAppointmentsForDate(DateTime date) {
    Debouncer().run(() {
      var dateKey = keyForDate(date);
      bool alreadyFetched = history[dateKey] ?? false;
      if (!alreadyFetched) {
        print('Fetching for date $date => $alreadyFetched');
        Appointments().allAppointments(date, () => UserPreferences().getSessionId())
            .then((response) {
          print('fetched $response');
          if (response.isNotEmpty) {
            controller.addAll(_eventList(response));
          }
          history.putIfAbsent(dateKey, () => true);
        });
      } else {
        print('Already fetched for $date. Skipping');
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
  print('In event builder');

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

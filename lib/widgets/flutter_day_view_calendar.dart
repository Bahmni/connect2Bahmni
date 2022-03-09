import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import '../domain/models/bahmni_appointment.dart';
import '../utils/app_type_def.dart';

String removeLastWord(String string) {
  List<String> words = string.split(' ');
  if (words.isEmpty) {
    return '';
  }
  return words.getRange(0, words.length - 1).join(' ');
}

bool? _exceedHeight(List<TextSpan> input, TextStyle? textStyle, double height, double width) {
  double fontSize = textStyle?.fontSize ?? 14;
  int maxLines = height ~/ ((textStyle?.height ?? 1.2) * fontSize);
  if (maxLines == 0) {
    return null;
  }

  TextPainter painter = TextPainter(
    text: TextSpan(
      children: input,
      style: textStyle,
    ),
    maxLines: maxLines,
    textDirection: TextDirection.ltr,
  );
  painter.layout(maxWidth: width);
  return painter.didExceedMaxLines;
}

bool ellipsize(List<TextSpan> input, [String ellipse = '…']) {
  if (input.isEmpty) {
    return false;
  }

  TextSpan last = input.last;
  String? text = last.text;
  if (text == null || text.isEmpty || text == ellipse) {
    input.removeLast();
    if (text == ellipse) {
      ellipsize(input, ellipse);
    }
    return true;
  }

  String truncatedText;
  if (text.endsWith('\n')) {
    truncatedText = text.substring(0, text.length - 1) + ellipse;
  } else {
    truncatedText = removeLastWord(text);
    truncatedText = truncatedText.substring(0, math.max(0, truncatedText.length - 2)) + ellipse;
  }

  input[input.length - 1] = TextSpan(text: truncatedText, style: last.style,);
  return true;
}

Widget customEventTextBuilder(FlutterWeekViewEvent event, BuildContext context, DayView dayView, double height, double width) {
  print('Building event title: ${event.title}');
  List<TextSpan> text = [
    TextSpan(
      text: event.title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
    ),
//      TextSpan(
//        text: ' ' +  dayView.hoursColumnStyle.timeFormatter(HourMinute.fromDateTime(dateTime: event.start))
//            + ' - ' + dayView.hoursColumnStyle.timeFormatter(HourMinute.fromDateTime(dateTime: event.end)) + '\n\n',
//      ),
//      TextSpan(
//        text: event.description,
//      ),
  ];

  bool? exceedHeight;
  while (exceedHeight ?? true) {
    exceedHeight = _exceedHeight(text, event.textStyle, height, width);
    if (exceedHeight == null || !exceedHeight) {
      if (exceedHeight == null) {
        //text.clear();
      }
      break;
    }

    if (!ellipsize(text)) {
      break;
    }
  }

  return RichText(
    text: TextSpan(
      children: text,
      style: event.textStyle,
    ),
  );
}

FlutterWeekViewEvent flutterWeekViewEvent(BahmniAppointment event) {
  return FlutterWeekViewEvent(
      title: event.patient.name,
      description: 'Appointment',
      start: event.startDateTime!,
      end: event.endDateTime!,
      textStyle: const TextStyle(color: Colors.white, height: 0.5),
      eventTextBuilder:(event, context, dayView, height, width) => customEventTextBuilder(event, context, dayView, height, width) ,
      onTap: () {
        print('event. name = ${event.patient.name}, start = ${event.startDateTime}, end = ${event.endDateTime}');
      }
  );
}

DayView dayViewCalendar(AsyncSnapshot<List<BahmniAppointment>> snapshot, DateTime forDate, NavigateToDate nav) {
  return DayView(
    initialTime: const HourMinute(hour: 7),
    dayBarStyle: DayBarStyle.fromDate(date: forDate, dateFormatter: _formatDate),
    date: forDate,
    onDayBarTappedDown: (dt) => nav(dt),
    events: _eventList(snapshot.data),
    style: DayViewStyle.fromDate(date: forDate, currentTimeCircleColor: Colors.red, hourRowHeight: 150.0),
    //style: DayViewStyle.fromDate(date: _forDate, currentTimeCircleColor: Colors.red, headerSize: 0),
  );
}

String _formatDate (int year, int month, int day) {
  return "${day.toString().padLeft(2,'0')}-${month.toString().padLeft(2,'0')}-$year";
}

List<FlutterWeekViewEvent> _eventList(List<BahmniAppointment>? appointmentList) {
  print('eventList called .... ');
  if (appointmentList == null) {
    return [];
  }
  return appointmentList.map((event) {
    print('appointment found. name = ${event.patient.name}, start = ${event.startDateTime}, end = ${event.endDateTime}');
    return flutterWeekViewEvent(event);
  }).toList();
}
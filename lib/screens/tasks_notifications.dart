import 'dart:async';

import 'package:fhir/r4/resource_types/base/workflow/workflow.dart';
import 'package:flutter/material.dart';
import '../widgets/my_tasks.dart';
import '../widgets/app_drawer.dart';

class TasksAndNotificationsWidget extends StatefulWidget {
  const TasksAndNotificationsWidget({Key? key}) : super(key: key);

  @override
  _TasksAndNotificationsWidgetState createState() => _TasksAndNotificationsWidgetState();
}

class _TasksAndNotificationsWidgetState extends State<TasksAndNotificationsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Stream<Appointment> _bids = (() {
    late final StreamController<Appointment> controller;
    controller = StreamController<Appointment>(
      onListen: () async {
        await Future<void>.delayed(const Duration(seconds: 1));
        List<AppointmentParticipant> participants = [];
        controller.add(Appointment(participant: participants));
        await Future<void>.delayed(const Duration(seconds: 1));
        await controller.close();
      },
    );
    return controller.stream;
  })();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Tasks & Notifications'),
        elevation: 0.1,
      ),
      drawer: appDrawer(),
      body: const TaskNotificationWidget(),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/my_tasks.dart';
import '../widgets/app_drawer.dart';

class TasksAndNotificationsWidget extends StatefulWidget {
  const TasksAndNotificationsWidget({super.key});

  @override
  State<TasksAndNotificationsWidget> createState() => _TasksAndNotificationsWidgetState();
}

class _TasksAndNotificationsWidgetState extends State<TasksAndNotificationsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Tasks & Notifications'),
        elevation: 0.1,
      ),
      drawer: appDrawer(context),
      body: const TaskNotificationWidget(),
    );
  }
}

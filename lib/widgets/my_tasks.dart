import 'package:flutter/material.dart';
import '../domain/models/task_notifications.dart';

class TaskNotificationWidget extends StatefulWidget {
  const TaskNotificationWidget({Key? key}) : super(key: key);

  @override
  _TaskNotificationWidgetState createState() => _TaskNotificationWidgetState();
}

class _TaskNotificationWidgetState extends State<TaskNotificationWidget> {
  final scrollController = ScrollController();
  late AllTasksNotifications notifications;

  @override
  void initState() {
    notifications = AllTasksNotifications();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        notifications.loadMore();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: notifications.stream,
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if(!_snapshot.hasData){
          return const Center(child: CircularProgressIndicator());
        } else {
          return RefreshIndicator(
            onRefresh: notifications.refresh,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              controller: scrollController,
              separatorBuilder: (context, index) => const Divider(),
              itemCount: _snapshot.data.length + 1,
              itemBuilder: (BuildContext _context, int index) {
                if(index < _snapshot.data.length){
                  return Task(taskNotification: _snapshot.data[index]);
                } else if(notifications.hasMore){
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: Text('nothing more to load!')),
                  );
                }
              },
            ),
          );
        }
      },
    );
  }
}

class Task extends StatelessWidget {
  final TaskNotification taskNotification;
  const Task({Key? key, required this.taskNotification,})  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Image(image: AssetImage('assets/2955252_calander_calendar_appointment_date_event_icon.png'), width: 60.0, height: 60.0,),
      title: Text(taskNotification.body),
    );
  }
}
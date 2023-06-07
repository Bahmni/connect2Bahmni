import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../screens/dashboard.dart';

class UserDashBoard extends StatefulWidget {
  const UserDashBoard({Key? key}) : super(key: key);
  @override
  State<UserDashBoard> createState() => _UserDashBoardState();
}

class _UserDashBoardState extends State<UserDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bahmni"),
        elevation: 0.1,
      ),
      drawer: appDrawer(context),
      body: const DashboardWidget()
    );
  }
}
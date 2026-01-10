import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meta_provider.dart';
import '../widgets/app_drawer.dart';
import '../screens/dashboard.dart';

class UserDashBoard extends StatefulWidget {
  const UserDashBoard({super.key});
  @override
  State<UserDashBoard> createState() => _UserDashBoardState();
}

class _UserDashBoardState extends State<UserDashBoard> {
  @override
  void initState() {
    super.initState();
    // Initialize MetaProvider when dashboard loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MetaProvider>(context, listen: false).initMetaData();
    });
  }

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

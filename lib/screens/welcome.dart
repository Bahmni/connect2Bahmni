import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/models/user.dart';
import '../providers/user_provider.dart';

class Welcome extends StatelessWidget {
  final User user;

  const Welcome({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context).setUser(user);

    return const Scaffold(
      body: Center(
          child: Text("WELCOME PAGE"),
        ),
      );
  }
}
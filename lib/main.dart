import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/shared_preference.dart';
import '../providers/user_provider.dart';
import '../domain/models/user.dart';
import '../providers/auth.dart';
import '../screens/user_dashboard.dart';
import '../screens/login.dart';
import '../screens/register.dart';
import '../screens/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<User?> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          title: 'Bahmni For Doctors',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.data == null) {
                      return const Login();
                    } else {
                      UserPreferences().removeUser();
                    }
                    return const Text('Logged in ');
                    //return const Welcome(user: snapshot.data);
                }
              }),
          routes: {
            '/dashboard': (context) => const UserDashBoard(),
            '/login': (context) => const Login(),
            '/register': (context) => const Register(),
          }),
    );
  }
}

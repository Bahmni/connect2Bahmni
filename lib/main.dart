import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../domain/models/session.dart';
import '../utils/shared_preference.dart';
import '../providers/user_provider.dart';
import '../providers/auth.dart';
import '../screens/user_dashboard.dart';
import '../screens/login.dart';
import '../screens/register.dart';
import '../screens/appointments_calendar.dart';
import '../utils/app_routes.dart';
import 'screens/patient_search.dart';
import 'screens/tasks_notifications.dart';
import '../screens/patient_charts.dart';
import '../screens/login_location.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<Session?> getUserData() => UserPreferences().getSession();
    HttpOverrides.global = DevHttpOverrides();

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
                      UserPreferences().removeSession();
                      return const Login();
                      //return const SpeechEg();
                    } else {
                      UserPreferences().removeSession();
                    }
                    return const Text('Logged in ');
                    //return const Welcome(user: snapshot.data);
                }
              }),
          routes: {
            AppRoutes.dashboard: (context) => const UserDashBoard(),
            AppRoutes.login: (context) => const Login(),
            AppRoutes.register: (context) => const Register(),
            AppRoutes.appointments: (context) => const AppointmentsCalendar(),
            AppRoutes.taskNotification: (context) => const TasksAndNotificationsWidget(),
            AppRoutes.searchPatients: (context) => const PatientSearch(),
            AppRoutes.patientCharts: (context) => const PatientCharts(),
            AppRoutes.loginLocations: (context) => const LoginLocation(),
          }),
    );
  }
}


class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

import 'dart:io';

import 'package:connect2bahmni/screens/registration/patient_registration.dart';
import 'package:connect2bahmni/screens/registration/registration_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/user_provider.dart';
import '../providers/auth.dart';
import '../screens/user_dashboard.dart';
import '../screens/login.dart';
import '../screens/register.dart';
import '../screens/appointments_calendar.dart';
import '../utils/app_routes.dart';
import 'domain/models/session.dart';
import 'widgets/patient_search.dart';
import 'screens/tasks_notifications.dart';
import '../screens/patient_dashboard.dart';
import '../screens/login_location.dart';
import '../providers/meta_provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authProvider = AuthProvider();
    HttpOverrides.global = DevHttpOverrides();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MetaProvider())
      ],
      child: MaterialApp(
          title: 'Bahmni For Doctors',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder(
              future: authProvider.getSession(),
              builder: (context, AsyncSnapshot<Session?> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData) {
                      return const Login();
                    }
                    Provider.of<UserProvider>(context, listen: false).updateUser((snapshot.data as Session).user);
                    return const UserDashBoard();
                }
              }),
          routes: {
            AppRoutes.dashboard: (context) => const UserDashBoard(),
            AppRoutes.login: (context) => const Login(),
            AppRoutes.register: (context) => const Register(),
            AppRoutes.appointments: (context) => const AppointmentsCalendar(),
            AppRoutes.taskNotification: (context) => const TasksAndNotificationsWidget(),
            AppRoutes.searchPatients: (context) => const PatientSearch(),
            AppRoutes.patients: (context) => const PatientDashboard(),
            AppRoutes.loginLocations: (context) => const LoginLocation(),
            AppRoutes.registerPatient: (context) => const PatientRegistration(),
            'registerNewPatient': (context) => const RegistrationPage(),
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

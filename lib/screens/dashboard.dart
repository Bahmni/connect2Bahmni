import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../domain/models/user.dart';
import '../providers/user_provider.dart';
import '../utils/app_routes.dart';
import '../widgets/appointments_list_view.dart';
import '../domain/models/person.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);


  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _greetings(context, user),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 6,
                        color: Color(0x4B1A1F24),
                        offset: Offset(0, 2),
                      )
                    ],
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00968A), Color(0xFFF2A384)],
                      stops: [0, 1],
                      begin: AlignmentDirectional(0.94, -1),
                      end: AlignmentDirectional(-0.94, 1),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              _mainContent(context, user),
            ],
          ),
        ),
      ),
    );
  }

  Padding _greetings(BuildContext context, User? user) {
    return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                            child:  Icon(
                              Icons.person,
                              color: Color(0xFF1E2429),
                              size: 40,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Welcome,',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Padding(
                              padding:
                              const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                              child: Text(
                                (user as User).username,
                                style: Theme.of(context).textTheme.subtitle2?.merge(const TextStyle(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF00968A),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                )),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: Text(
                            'Your latest updates are below.',
                            style: Theme.of(context).textTheme.bodyText1?.merge(const TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF090F13),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ))
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
  }

  Padding _mainContent(BuildContext context, User? user) {
    return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x39000000),
                      offset: Offset(0, -1),
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Quick Service',
                            style: Theme.of(context).textTheme.bodyText1?.merge(const TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF090F13),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _patientSearch(),
                          _myAppointments(),
                          _myNotifications(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Quick View',
                            style: Theme.of(context).textTheme.bodyText1?.merge(const TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF090F13),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            )),
                          ),
                        ],
                      ),
                    ),
                    _quickViewList(user),
                  ],
                ),
              ),
            );
  }

  Widget _patientSearch() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Color(0x3B000000),
            offset: Offset(0, 2),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, AppRoutes.searchPatients),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person,
                color: Color(0xFF1E2429),
                size: 40,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                child: Text(
                  'Patients',
                  style: Theme.of(context).textTheme.bodyText2?.merge(const TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Color(0xFF090F13),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _myAppointments() {
    return Container(
      width: 110,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Color(0x3A000000),
            offset: Offset(0, 2),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, AppRoutes.appointments),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.access_alarm,
                color: Color(0xFF1E2429),
                size: 40,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    0, 8, 0, 0),
                child: Text(
                  'Appointments',
                  style: Theme.of(context).textTheme.bodyText1?.merge(const TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Color(0xFF090F13),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _myNotifications() {
    return Container(
      width: 110,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Color(0x39000000),
            offset: Offset(0, 2),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, AppRoutes.taskNotification),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.event_note,
                color: Color(0xFF1E2429),
                size: 40,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    0, 8, 0, 0),
                child: Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.bodyText1?.merge(const TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Color(0xFF090F13),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickViewList(User? user) {
      var practitionerUuid = user!.provider!.uuid;
      return Column(
        children: [
          ..._recentPatients(user),
          ..._newInformation(),
          AppointmentsListView(practitionerUuid: practitionerUuid),
        ],
      );
  }

  List<Padding> _newInformation() {
    List<Padding> newInfo = [];
    newInfo.add(Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.92,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5F7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                  const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: const Color(0x6639D2C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          8, 8, 8, 8),
                      child: Icon(Icons.notification_important_rounded, size: 24,),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        12, 0, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hina Patel (Example)',
                          style: Theme.of(context).textTheme.subtitle1?.merge(const TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF1E2429),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: Text(
                            'New Health Record',
                            style: Theme.of(context).textTheme.bodyText1?.merge(const TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF090F13),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      12, 0, 12, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'F 26',
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.subtitle2?.merge(const TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF39D2C0),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          'Diagnostic Report',
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.bodyText1?.merge(const TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF090F13),
                              fontSize: 12,
                              fontWeight: FontWeight.normal)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
    return newInfo;
  }

  List<Container> _recentPatients(User user) {
    var recentlyViewedPatients = user.recentlyViewedPatients();
    int _limit = recentlyViewedPatients.length < 3 ? recentlyViewedPatients.length : 3;
    var subList = recentlyViewedPatients.isNotEmpty ? recentlyViewedPatients.sublist(0,_limit) : [];
    List<Container> recentList =
      List<Container>.of(subList.map((person) {
        return _recentPatient(person);
      }));
    if (recentList.isEmpty) {
      recentList.add(_demoRecentPatient());
    }
    return recentList;
  }

  Container _demoRecentPatient() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.92,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFFF4F5F7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: const Color(0x6639D2C0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      8, 8, 8, 8),
                  child: Icon(Icons.person_rounded, size: 24,),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rutgar Ragos (Example)',
                      style: Theme.of(context).textTheme.subtitle1?.merge(const TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Color(0xFF1E2429),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'Recently visited',
                        style: Theme.of(context).textTheme.bodyText1?.merge(const TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF090F13),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'M 87',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.subtitle2?.merge(const TextStyle(
                      fontFamily: 'Lexend Deca',
                      color: Color(0xFF39D2C0),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                    child: Text(
                      'Favorite',
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodyText1?.merge(const TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Color(0xFF090F13),
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }

  Container _recentPatient(Person person) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.92,
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: const Color(0x6639D2C0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    8, 8, 8, 8),
                child: Icon(Icons.person_rounded, size: 24,),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person.display,
                    style: Theme.of(context).textTheme.subtitle1?.merge(const TextStyle(
                      fontFamily: 'Lexend Deca',
                      color: Color(0xFF1E2429),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                    child: Text(
                      'Recently visited',
                      style: Theme.of(context).textTheme.bodyText1?.merge(const TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Color(0xFF090F13),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:
            const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '',
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.subtitle2?.merge(const TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Color(0xFF39D2C0),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                  child: Text(
                    'Patient',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodyText1?.merge(const TextStyle(
                      fontFamily: 'Lexend Deca',
                      color: Color(0xFF090F13),
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

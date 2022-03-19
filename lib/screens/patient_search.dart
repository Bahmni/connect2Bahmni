import 'dart:async';
import 'package:fhir/r4.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../services/patients.dart';
import '../utils/debouncer.dart';
import 'models/patient_view.dart';
import '../screens/patient_charts.dart';
import '../utils/app_routes.dart';


class PatientSearch extends StatefulWidget {
  const PatientSearch({Key? key}) : super(key: key);

  @override
  _PatientsSearchWidgetState createState() => _PatientsSearchWidgetState();
}

class _PatientsSearchWidgetState extends State<PatientSearch> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer();
  AuthProvider? _authProvider;
  List<PatientViewModel> patientList = [];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<String?> retrieveSessionId() async {
    if (_authProvider != null) {
        return await _authProvider!.sessionId;
    } else {
      return null;
    }
  }

  void _searchForPatients() {
    _debouncer.run(() {
      print('Search text field: ${searchController.text}');
      if (searchController.text.isEmpty) {
        setState(() {
          patientList.clear();
        });
        return;
      }
      final Future<Map<String, dynamic>> request = Patients().searchByName(searchController.text);
      request.then((response) {
        //print('got patient response $response');
        if (response['status']) {
          List<PatientViewModel> patients = [];
          Bundle bundle = response['result'];
          bundle.entry?.forEach((element) {
            var patientViewModel = PatientViewModel(element.resource as Patient);
            patients.add(patientViewModel);
          });
          setState(() {
            patientList.clear();
            patientList.addAll(patients);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Search failed")),
          );
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(_searchForPatients);
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Search Patients'),),
      body: Column(
        children: [
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFDBE2E7),
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                    child: _searchPatientsView(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (var p in patientList) _patientRow(p)
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }

  Card _searchPatientsView() {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
              child: Icon(
                Icons.search_rounded,
                color: Color(0xFF95A1AC),
                size: 24,
              ),
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                child: TextFormField(
                  controller: searchController,
                  obscureText: false,
                  decoration: InputDecoration(
                    //labelText: 'Search for patients...',
                    labelStyle: Theme
                        .of(context)
                        .textTheme
                        .bodyText1
                        ?.merge(const TextStyle(
                      fontFamily: 'Lexend Deca',
                      color: Color(0xFF82878C),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    )),
                    hintText: 'Find patients by name or identifier',
                    hintStyle: Theme.of(context).textTheme.bodyText1?.merge(const TextStyle(
                      fontFamily: 'Lexend Deca',
                      color: Color(0xFF95A1AC),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    )),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x004B39EF),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x004B39EF),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                  ),
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyText1
                      ?.merge(const TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Color(0xFF151B1E),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  )),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _patientRow(PatientViewModel patient) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color(0xFFC8CED5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(shape: BoxShape.circle,),
                      child: const Icon(Icons.person_rounded, size: 24,),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          patient.fullName,
                          style: Theme.of(context).textTheme.subtitle1?.merge(const TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF15212B),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            strutStyle: const StrutStyle(fontSize: 12.0),
                            text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                  text: patient.minimalInfo,),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                child: InkWell(
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      AppRoutes.patientCharts,
                      arguments: PatientChartArguments(
                        patient.uuid,
                        patient.fullName
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF82878C),
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}




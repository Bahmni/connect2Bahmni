import 'package:fhir/r4.dart';
import 'package:flutter/material.dart';

import '../services/patients.dart';
import '../utils/debouncer.dart';
import '../screens/models/patient_view.dart';
import '../utils/app_routes.dart';
import '../utils/app_failures.dart';
import '../widgets/patient_info.dart';


class PatientSearch extends StatefulWidget {
  final OnSelectPatient? onSelect;
  const PatientSearch({Key? key, this.onSelect}) : super(key: key);

  @override
  _PatientsSearchWidgetState createState() => _PatientsSearchWidgetState();
}

class _PatientsSearchWidgetState extends State<PatientSearch> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer();
  List<PatientModel> patientList = [];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(_searchForPatients);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Patients'),),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
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

  void _searchForPatients() {
    if (searchController.text.trim().isEmpty) return;
    if (searchController.text.trim().length < 3) return;
    _debouncer.run(() {
      if (searchController.text.isEmpty) {
        setState(() {
          patientList.clear();
        });
        return;
      }
      Patients().searchByName(searchController.text).then((result) {
        List<PatientModel> patients = result.entry != null
            ? List<PatientModel>.from(result.entry!.map((e) => PatientModel(e.resource as Patient)))
            : [];
        setState(() {
          patientList.clear();
          patientList.addAll(patients);
        });
      },
      onError: (err) {
        debugPrint(err.toString());
        String errorMsg = err is Failure ? err.message : '';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Search failed. $errorMsg')),
        );
      });
    });
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
                    labelStyle: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge
                        ?.merge(const TextStyle(
                      fontFamily: 'Lexend Deca',
                      color: Color(0xFF82878C),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    )),
                    hintText: 'Find patients by name or identifier',
                    hintStyle: Theme.of(context).textTheme.bodyLarge?.merge(const TextStyle(
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
                      .bodyLarge
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

  Row _patientRow(PatientModel patient) {
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
                          style: Theme.of(context).textTheme.titleMedium?.merge(const TextStyle(
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
                    _debouncer.stop();
                    await Navigator.pushNamed(
                      context,
                      AppRoutes.patients,
                      arguments: patient,
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





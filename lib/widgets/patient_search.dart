import 'package:fhir/r4.dart';
import 'package:flutter/material.dart';

import '../screens/patient_profile_view.dart';
import '../screens/models/patient_model.dart';
import '../services/patients.dart';
import '../utils/debouncer.dart';
import '../utils/app_routes.dart';
import '../utils/app_failures.dart';
import '../widgets/patient_list.dart';


class PatientSearch extends StatefulWidget {
  final PatientSearchType searchType;
  const PatientSearch({Key? key, this.searchType = PatientSearchType.all}) : super(key: key);

  @override
  State<PatientSearch> createState() => _PatientsSearchWidgetState();
}

class _PatientsSearchWidgetState extends State<PatientSearch> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer();
  late List<PatientModel> _initialPatientList;
  final ValueNotifier<List<PatientModel>> patientListNotifier = ValueNotifier<List<PatientModel>>([]);

  @override
  void initState() {
    super.initState();
    _fetchPatientList();
    searchController.addListener(_searchForPatients);
  }

  @override
  void dispose() {
    searchController.removeListener(_searchForPatients);
    searchController.dispose();
    patientListNotifier.dispose();
    super.dispose();
  }

  void _fetchPatientList() {
    if (widget.searchType == PatientSearchType.all) {
      _initialPatientList = [];
      patientListNotifier.value = [];
      return;
    }

    var fetchResults = widget.searchType == PatientSearchType.activePatients ? Patients().getActivePatients() : Patients().getDispensingPatients();
    fetchResults.then((result) {
      List<PatientModel> patients = result.entry != null ? List<PatientModel>.from(result.entry!.map((e) => PatientModel(e.resource as Patient))) : [];
      _initialPatientList = patients;
      patientListNotifier.value = patients;
    }).onError((error, stackTrace) {
      String errorMsg = error is Failure ? error.message : '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error. $errorMsg')),
      );
      _initialPatientList = [];
      patientListNotifier.value = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    String headingText = widget.searchType.display;
    return Scaffold(
      appBar: AppBar(
        title: Text(headingText),
        actions: [
          //_switchStatus(),
          IconButton(
            tooltip: 'New Patient',
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () async {
              _primaryAction();
            },
          )],
      ),
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
            child: ValueListenableBuilder<List<PatientModel>>(
              valueListenable: patientListNotifier,
              builder: (context, patients, child) {
                return PatientListWidget(
                  patientList: patients,
                  onAction: _onActionPatient,
                  onSelect: _onSelectPatient,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // bool _showActive = true;
  // Switch _switchStatus() {
  //   return Switch(
  //           activeColor: Colors.white70,
  //           value: _showActive,
  //           onChanged: (val) {
  //             setState(() {
  //               _showActive = val;
  //             });
  //       });
  // }

  void _primaryAction() async {
    Navigator.of(context).pushReplacementNamed(AppRoutes.registerPatient);
    // Navigator.of(context).pushReplacementNamed('registerNewPatient');
  }

  void _onActionPatient(PatientModel patient) async {
    _debouncer.stop();
    await Navigator.pushNamed(
      context,
      AppRoutes.patients,
      arguments: patient,
    );
  }

  void _onSelectPatient(PatientModel patient) async {
    _debouncer.stop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PatientProfileView(patientUuid: patient.uuid,)),
    );
  }

  void _searchForPatients() {
      var searchInList = widget.searchType != PatientSearchType.all;
      if (searchController.text.trim().isEmpty) {
        patientListNotifier.value = searchInList ? _initialPatientList : [];
        return;
      }

      if (searchInList && searchController.text.trim().length < 2) {
        var matching = _initialPatientList.where((element) => element.fullName.toUpperCase().contains(searchController.text.toUpperCase())).toList();
        patientListNotifier.value = matching;
        return;
      }

      if (searchController.text.trim().length < 3) {
        return;
      }

      _debouncer.run(() {
          if (searchController.text.isEmpty) {
            _debouncer.stop();
            return;
          }
          if (searchInList) {
            _debouncer.stop();
            // ignore_for_file: INVALID_USE_OF_PROTECTED_MEMBER
            if (patientListNotifier.hasListeners) {
              var matching = _initialPatientList.where((element) => element.fullName.toUpperCase().contains(searchController.text.toUpperCase())).toList();
              patientListNotifier.value = matching;
            }
            return;
          }
          Patients().searchByName(searchController.text).then((result) {
            List<PatientModel> patients = result.entry != null
                ? List<PatientModel>.from(result.entry!.map((e) => PatientModel(e.resource as Patient)))
                : [];
            _debouncer.stop();
            if (patientListNotifier.hasListeners) {
              patientListNotifier.value = patients;
            }
          },
          onError: (err) {
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
                    hintText: 'Name or Identifier',
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
}
enum PatientSearchType {
  all('Patients'), activePatients('Active Patients'), dispensingPatients('Dispense');

  final String display;
  const PatientSearchType(this.display);
}





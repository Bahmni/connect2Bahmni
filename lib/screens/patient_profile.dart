
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/models/omrs_visit_type.dart';
import '../domain/models/oms_visit.dart';
import '../providers/meta_provider.dart';
import '../screens/models/profile_model.dart';
import '../screens/registration/profile_summary.dart';
import '../../services/patients.dart';
import '../services/visits.dart';

class PatientProfileView extends StatefulWidget {
  final String patientUuid;

  const PatientProfileView({Key? key, required this.patientUuid}) : super(key: key);

  @override
  State<PatientProfileView> createState() => _PatientProfileView();
}

const errFetchPatientProfile = "Failed to fetch patient profile";
const lblCloseVisit = 'Close Visit';
const lblStartVisit = 'Start Visit';
const lblNameHeading = 'My Bahmni';

class _PatientProfileView extends State<PatientProfileView> {

  late Future<PatientWithVisit> profileFuture;
  late List<OmrsVisitType>? visitTypes;

  @override
  void initState() {
    super.initState();
    profileFuture = Patients().getPatientProfile(widget.patientUuid)
        .then((value) => ProfileModel.fromProfileJson(value))
        .then((profile) => Visits().visitsForPatient(profile.uuid!, false).then((visits) => PatientWithVisit(profile: profile, visits: visits)));
    visitTypes = Provider.of<MetaProvider>(context, listen: false).visitTypes;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PatientWithVisit>(
        future: profileFuture,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<PatientWithVisit> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(height: 40, child: Center(child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator())));
          }

          if (snapshot.hasError) {
            return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text(lblNameHeading),
                  elevation: 0.1,
                ),
                body: Container(
                  padding: const EdgeInsets.all(40.0),
                  child: const Center(
                    child: Text(errFetchPatientProfile),
                  ),
                )
            );
          }
          ProfileModel existingPatient = ProfileModel();
          if (snapshot.hasData) {
            existingPatient = snapshot.data!.profile;
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text(lblNameHeading),
              elevation: 0.1,
            ),
            body: Container(
              padding: const EdgeInsets.all(5.0),
              child: ListView(
                children: [
                  ProfileSummary(
                      identifiers: existingPatient.identifiers,
                      basicDetails: existingPatient.basicDetails,
                      attributes: existingPatient.attributes,
                      address: existingPatient.address),
                ],
              ),
            ),
            floatingActionButton: _buildActionButton(snapshot.data!.visits),
          );
        }
    );
  }

  Widget _buildActionButton(List<OmrsVisit>? visits) {
    bool hasOpenVisit = visits != null && visits.isNotEmpty;
    if (hasOpenVisit) {
      return FloatingActionButton.extended(
        onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Not yet Implemented")),
            );
        },
        //isExtended: false,
        label: Text(lblCloseVisit),
        icon: Icon(Icons.start_outlined),
        backgroundColor: Colors.pink,
      );
    }

    return
      SpeedDial(
      icon: Icons.start_outlined,
      label: Text(lblStartVisit),
      buttonSize: Size(50, 48),
      backgroundColor: Colors.pink,
        children: [
          ..._startVisitOptions(),
        ]
    );
    // return ExpandableFab(
    //   distance: 160,
    //   icon: Icon(Icons.start_outlined),
    //   label: lblStartVisit,
    //   showText: true,
    //   backgroundColor: Colors.pink,
    //   children: [
    //     ActionButton(
    //       onPressed: () => debugPrint('Pressed 1'),
    //       icon: const Icon(Icons.open_in_new),
    //     ),
    //   ],
    // );
  }

  List<SpeedDialChild> _startVisitOptions() {
    if (visitTypes == null || visitTypes!.isEmpty) {
      return [];
    }

    return visitTypes!.map((e) => SpeedDialChild(
          child: const Icon(Icons.start_outlined,color: Colors.white),
          label: e.display,
          backgroundColor: Colors.blueAccent,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Not yet Implemented")),
            );
          },
        )).toList();
  }
}

class PatientWithVisit {
  final ProfileModel profile;
  final List<OmrsVisit>? visits;
  PatientWithVisit({required this.profile, this.visits});
}
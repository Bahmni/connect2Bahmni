
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/models/omrs_visit_type.dart';
import '../domain/models/oms_visit.dart';
import '../providers/meta_provider.dart';
import '../screens/models/profile_model.dart';
import '../screens/registration/profile_summary.dart';
import '../services/registrations.dart';
import '../services/visits.dart';
import '../utils/app_failures.dart';

class PatientProfileView extends StatefulWidget {
  final String patientUuid;

  const PatientProfileView({Key? key, required this.patientUuid}) : super(key: key);

  @override
  State<PatientProfileView> createState() => _PatientProfileView();
}

const errFetchPatientProfile = "Failed to fetch patient profile";
const lblCloseVisit = 'Close Visit';
const lblStartVisit = 'Start Visit';
const lblNameHeading = 'Patient';

class _PatientProfileView extends State<PatientProfileView> {

  late Future<PatientWithVisit> profileFuture;
  late List<OmrsVisitType>? visitTypes;
  bool visitStarted = false;

  @override
  void initState() {
    super.initState();
    profileFuture = Registrations().getPatientProfile(widget.patientUuid)
        .then((profile) => Visits().visitsForPatient(profile.uuid!, false).then((visits) => PatientWithVisit(profile: profile, visits: visits)));
    visitTypes = Provider.of<MetaProvider>(context, listen: false).visitTypes;
  }


  @override
  Widget build(BuildContext context) {
    debugPrint("PatientProfileView.build");
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
                  automaticallyImplyLeading: true,
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
              automaticallyImplyLeading: true,
              title: const Text(lblNameHeading),
              elevation: 0.1,
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Not yet Implemented")),
                    );
                  },
                ),
              ],
            ),
            body: Container(
              padding: const EdgeInsets.all(5.0),
              child: ListView(
                children: [
                  ProfileSummary(
                      uuid: existingPatient.uuid,
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
    if (hasOpenVisit || visitStarted) {
      return FloatingActionButton.extended(
        onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Not yet Implemented")),
            );
        },
        //isExtended: false,
        label: Text(lblCloseVisit),
        icon: Icon(Icons.stop_circle_outlined),
        backgroundColor: Colors.pink,
      );
    }

    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   crossAxisAlignment: CrossAxisAlignment.end,
    //   children: [
    //     FloatingActionButton(
    //       onPressed: () {},
    //       child: Icon(Icons.edit_outlined),
    //     ),
    //     SizedBox(height: 10,),
    //     SpeedDial(
    //         icon: Icons.start_outlined,
    //         label: Text(lblStartVisit),
    //         buttonSize: Size(50, 48),
    //         backgroundColor: Colors.pink,
    //         children: [
    //           ..._startVisitOptions(),
    //         ]
    //     ),
    //   ],
    // );

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

    return visitTypes!.map((visitType) => SpeedDialChild(
          child: const Icon(Icons.start_outlined,color: Colors.white),
          label: visitType.display,
          backgroundColor: Colors.blueAccent,
          onTap: () async {
            await Visits().startVisit(widget.patientUuid, visitType.uuid!)
                .then((value) => _visitStarted(value))
                .onError((error, stackTrace) => _visitStartFailed(error));
            setState(() {});
          },
        )).toList();
  }

  void _visitStartFailed(Object? error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error is Failure ? error.message : '')),
    );
  }

  void _visitStarted(OmrsVisit newVisit) {
    visitStarted = true;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Visit started")),
    );
  }
}

class PatientWithVisit {
  final ProfileModel profile;
  final List<OmrsVisit>? visits;
  PatientWithVisit({required this.profile, this.visits});
}
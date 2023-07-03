
import 'package:flutter/material.dart';
import '../screens/models/profile_model.dart';
import '../screens/registration/profile_summary.dart';
import '../../services/patients.dart';
import '../widgets/expandable_fab.dart';

class PatientProfileView extends StatefulWidget {
  final String patientUuid;

  const PatientProfileView({Key? key, required this.patientUuid}) : super(key: key);

  @override
  State<PatientProfileView> createState() => _PatientProfileView();
}

const errFetchPatientProfile = "Failed to fetch patient profile";
const lblNameHeading = 'My Bahmni';

class _PatientProfileView extends State<PatientProfileView> {

  late Future<ProfileModel> profileFuture;

  @override
  void initState() {
    super.initState();
    profileFuture = Patients().getPatientProfile(widget.patientUuid).then((value) => ProfileModel.fromProfileJson(value));
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileModel>(
        future: profileFuture,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<ProfileModel> snapshot) {
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
            existingPatient = snapshot.data!;
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
            floatingActionButton: ExpandableFab(
              distance: 80,
              icon: Icon(Icons.start_outlined),
              label: 'Start Visit',
              showText: true,
              backgroundColor: Colors.blueGrey,
              children: [
                ActionButton(
                  onPressed: () => debugPrint('Pressed 1'),
                  icon: const Icon(Icons.open_in_new),
                ),
                ActionButton(
                  onPressed: () => debugPrint('Pressed 2'),
                  icon: const Icon(Icons.insert_photo),
                ),
                ActionButton(
                  onPressed: () => debugPrint('Pressed 3'),
                  icon: const Icon(Icons.videocam),
                ),
              ],
            ),
            // floatingActionButton: FloatingActionButton.extended(
            //   onPressed: () {
            //     // Add your onPressed code here!
            //   },
            //   //isExtended: false,
            //   label: Text('Start Visit'),
            //   icon: Icon(Icons.start_outlined),
            //   backgroundColor: Colors.pink,
            // ),
          );
        }
    );
  }
}
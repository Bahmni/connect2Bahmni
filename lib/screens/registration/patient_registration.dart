import 'dart:convert';

import 'package:connect2bahmni/domain/models/omrs_identifier_type.dart';
import 'package:connect2bahmni/screens/registration/profile_summary.dart';

import '../../providers/meta_provider.dart';
import '../../screens/registration/profile_attributes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/patients.dart';
import '../../widgets/address_selection.dart';
import 'profile_basic.dart';
import '../models/profile_model.dart';

const String lblNext = 'Next';
const String lblSaveProfile = 'Save Profile';
const String lblEditProfile = 'Edit Profile';
const String lblPrevious = 'Previous';
const String lblPatientProfile =  "Patient Profile";

class PatientRegistration extends StatefulWidget {
  const PatientRegistration({Key? key}) : super(key: key);

  @override
  State<PatientRegistration> createState() => _PatientRegistration();
}

class _PatientRegistration extends State<PatientRegistration> {

  final _profileAttributeFormKey = GlobalKey<FormState>();
  late OmrsIdentifierType? primaryPatientIdentifierType;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    primaryPatientIdentifierType = Provider.of<MetaProvider>(context, listen: false).primaryPatientIdentifierType;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileModel>(
      create: (context) => ProfileModel(primaryPatientIdentifierType: primaryPatientIdentifierType),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(lblPatientProfile,),
        ),
        body: Consumer<ProfileModel>(
          builder: (context, profile, child) {
            switch (profile.currentSection) {
              case 1:
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ..._heading(),
                    SizedBox(height: 5.0),
                    Container (
                      padding: EdgeInsets.all(10),
                      child: ProfileAttributes(attributes: profile.attributes, formKey: _profileAttributeFormKey,),
                    ),
                  ],
                );
              case 2:
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ..._heading(),
                    SizedBox(height: 5.0),
                    Container (
                      padding: EdgeInsets.all(10),
                      child: AddressScreen(address: profile.address),
                    ),
                  ],
                );
              case 3:
                return ListView(
                    children: [
                      ProfileSummary(
                          identifiers: profile.identifiers,
                          basicDetails: profile.basicDetails,
                          attributes: profile.attributes,
                          address: profile.address),
                    ],
                  );
              default :
                return Container (
                  padding: EdgeInsets.all(10),
                  child: BasicProfile(
                      identifiers: profile.identifiers,
                      basicDetails: profile.basicDetails,
                      phoneNumber: profile.phoneNumber,
                  )
                );
            }
          },
          // floatingActionButton: FloatingActionButton(
          //   // When the button is pressed,
          //   // give focus to the text field using myFocusNode.
          //   onPressed: () => myFocusNode.requestFocus(),
          //   tooltip: 'Focus Second Text Field',
          //   child: const Icon(Icons.edit),
          // ),
        ),
        floatingActionButton: Consumer<ProfileModel>(
          builder: (context, profile, child) {
            if (profile.currentSection == 3) {
              return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (profile.isNewPatient)
                        FloatingActionButton(
                          onPressed: () {
                            profile.previousSection();
                          },
                          tooltip: lblPrevious,
                          child: const Icon(Icons.navigate_before_outlined),
                        ),
                      SizedBox(width: 10.0),
                      if (profile.isNewPatient)
                        FloatingActionButton(
                          onPressed: () async {
                            await validateAndSave(profile);
                            // Navigator.pushNamed(context, '/patientSummary', arguments: patient);
                          },
                          tooltip: lblSaveProfile,
                          child: const Icon(Icons.save_outlined),
                        )
                      else
                        FloatingActionButton(
                          onPressed: () {
                            // Navigator.pushNamed(context, '/patientSummary', arguments: patient);
                          },
                          tooltip: lblEditProfile,
                          child: const Icon(Icons.edit_outlined),
                        ),
                    ]);
              }
            return SizedBox();
            //return _buildNavBar(profile);
          },
        )
      ),
    );
  }

  Future<void> validateAndSave(ProfileModel profile) async {
    profile.validate();
    var profileJson = profile.toProfileJson();
    debugPrint(jsonEncode(profileJson));
    if (profile.isNewPatient) {
      var response = await Patients().createPatient(profileJson);
      debugPrint('Profile post response: $response');
      var serverResponse = ProfileModel.fromProfileJson(response);
      profile.updateFrom(serverResponse);
    } else {
      // var response = await Patients().updatePatient(profile.toProfileJson());
      // debugPrint('Profile post response: $response');
      // var serverResponse = ProfileModel.fromProfileJson(response);
      // profile.updateFrom(serverResponse);
    }
  }

  List<Widget> _heading() {
    return [Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            ListTile(
              leading: Icon(Icons.person_add_alt_1_rounded),
              title: Text('New Patient Registration'),
              subtitle: Text(''),
            ),
          ],
        )
    )];
  }

}



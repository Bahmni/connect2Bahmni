import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/address_entry.dart';
import '../../domain/models/omrs_identifier_type.dart';
import '../../providers/meta_provider.dart';
import '../../screens/registration/profile_attributes.dart';
import '../../services/address_hierarchy.dart';
import '../../services/visits.dart';
import '../../utils/app_failures.dart';
import '../../widgets/address_selection.dart';
import '../../services/registrations.dart';
import '../../widgets/visit_types_fab.dart';
import '../models/profile_model.dart';
import 'profile_basic.dart';
import 'profile_controller.dart';
import 'profile_heading.dart';
import 'profile_summary.dart';

const String lblNext = 'Next';
const String lblStartVisit = 'Start Visit';
const String lblSaveProfile = 'Save Profile';
const String lblEditProfile = 'Edit Profile';
const String lblError = 'Profile Error';
const String lblPrevious = 'Previous';
const errInvalidProfile = 'Please provide required information';

class PatientRegistration extends StatefulWidget {
  const PatientRegistration({super.key});

  @override
  State<PatientRegistration> createState() => _PatientRegistration();
}

class _PatientRegistration extends State<PatientRegistration> {

  final _profileAttributeFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();
  final _basicDetailsFormKey = GlobalKey<FormState>();
  late OmrsIdentifierType? primaryPatientIdentifierType;
  final ProfileController<List<ProfileAttribute>> _attributesController = ProfileController<List<ProfileAttribute>>();
  final ProfileController<ProfileAddress> _addressController = ProfileController<ProfileAddress>();
  final ProfileController<ProfileBasics> _basicDetailsController = ProfileController<ProfileBasics>();

  final ValueNotifier<int> _pageIndex = ValueNotifier<int>(0);
  final ValueNotifier<bool> _profileSaved = ValueNotifier<bool>(false);
  late ProfileModel profile;
  final List<AddressEntry> addressHierarchy = [];

  static const errStartingVisit = "Error occurred while trying to start visit";
  static const lblScreenTitle = 'Patient';
  static const lblProfileHeading = 'Patient Profile';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    primaryPatientIdentifierType = Provider.of<MetaProvider>(context, listen: false).primaryPatientIdentifierType;
    AddressHierarchy().loadAddressHierarchy(context).then((value) {
      addressHierarchy.addAll(value);
    });
    profile = initializeModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(lblScreenTitle),
        actions:  [
          ValueListenableBuilder<int>(
            builder: (BuildContext context, int pageIndex, Widget? child) {
              if (pageIndex != 0) {
                return IconButton(onPressed: () { _pageAction(pageIndex-1); }, icon: Icon(Icons.navigate_before));
              }
              return SizedBox();
            },
            valueListenable: _pageIndex,
          ),
          // SizedBox(width: MediaQuery.of(context).size.width*0.75),
          ValueListenableBuilder<int>(
            builder: (BuildContext context, int pageIndex, Widget? child) {
              if (pageIndex != 3) {
                return IconButton(onPressed: () { _pageAction(pageIndex+1); }, icon: Icon(Icons.navigate_next));
              }
              return SizedBox();
            },
            valueListenable: _pageIndex,
          ),
        ],
      ),
      body: ValueListenableBuilder<int>(
          builder: (BuildContext context, int pageIndex, Widget? child) {
            return _buildPage(pageIndex);
          },
          valueListenable: _pageIndex,
      ),
      floatingActionButton: ValueListenableBuilder<int>(
        builder: (BuildContext context, int pageIndex, Widget? child) {
          if (pageIndex == 3) {
            return _profileActionButton();
          }
          return SizedBox();
        },
        valueListenable: _pageIndex,
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        builder: (BuildContext context, int value, Widget? child) {
          return BottomNavigationBar(
            selectedItemColor: Colors.amber[800],
            currentIndex: value,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.info_outline_rounded),label: 'Basics'),
              BottomNavigationBarItem(icon: Icon(Icons.more_horiz_outlined),label: 'Additional'),
              BottomNavigationBarItem(icon: Icon(Icons.pin_drop_rounded),label: 'Address'),
              BottomNavigationBarItem(icon: Icon(Icons.summarize_outlined),label: 'Summary'),
            ],
            type: BottomNavigationBarType.fixed,
            onTap: (navItemIndex) {
              _pageAction(navItemIndex);
            },
          );
        },
        valueListenable: _pageIndex,
      ),
    );
  }

  Widget _buildPage(int pageIndex) {
    return SingleChildScrollView(
      child: Wrap(
          children: [
            if (pageIndex != 3)
              ProfileHeading(title: lblProfileHeading),
            Container(
              padding: EdgeInsets.all(10),
              child: _pageWidget(pageIndex),
            )
          ]
      )
    );
  }

  Widget _pageWidget(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return BasicProfile(
          formKey: _basicDetailsFormKey,
          identifiers: profile.identifiers,
          basicDetails: profile.basicDetails,
          controller: _basicDetailsController,
          readOnly: _profileSaved.value,
        );
      case 1:
        return ProfileAttributes(
          formKey: _profileAttributeFormKey,
          attributes: profile.attributes,
          controller: _attributesController,
          readOnly: _profileSaved.value,
        );
      case 2:
        return AddressScreen(
          formKey: _addressFormKey,
          address: profile.address,
          controller: _addressController,
          readOnly: _profileSaved.value,
          onSearch: (pattern) async {
            return _findAddressEntries(pattern);
          },
        );
      case 3:
      default:
        return ProfileSummary(
          uuid: profile.uuid,
          basicDetails: profile.basicDetails,
          address: profile.address,
          attributes: profile.attributes,
          identifiers: profile.identifiers,
        );
    }
  }

  /// TODO: refactor the code. This is a quick fix
  List<AddressEntry> _findAddressEntries(String pattern) {
      if (pattern.trim().isEmpty) {
        return addressHierarchy;
      }
      var searchString = pattern.trim();
      bool showAllChildren = searchString.endsWith("|");
      if (showAllChildren) {
        searchString = searchString.substring(0, searchString.length-1);
      }
      var queries = searchString.split('|');
      var searchable = addressHierarchy;
      switch (queries.length) {
        case 1: //State
          if (showAllChildren) {
              AddressEntry? entry = addressHierarchy.where((element) => element.name == queries[0]).firstOrNull;
              return entry != null ? (entry.children ?? []) : [];
          }
          return searchable.where((element) => element.name.toLowerCase().contains(queries[0].toLowerCase())).toList();
        case 2: //District
          AddressEntry? entry = addressHierarchy.where((element) => element.name == queries[0]).firstOrNull;
          if (entry != null) {
            if (showAllChildren) {
              entry = entry.children?.where((element) => element.name == queries[1]).firstOrNull;
              return entry != null ? (entry.children ?? []) : [];
            } else {
              return entry.children?.where((element) => element.name.toLowerCase().contains(queries[1].toLowerCase())).toList() ?? [];
            }
          } else {
            return [];
          }
        case 3: //Sub - District
          AddressEntry? entry = addressHierarchy.where((element) => element.name == queries[0]).firstOrNull;
          if (entry != null) {
            entry = entry.children?.where((element) => element.name == queries[1]).firstOrNull;
            if (entry != null) {
              if (showAllChildren) {
                entry = entry.children?.where((element) => element.name == queries[2]).firstOrNull;
                return entry != null ? (entry.children ?? []) : [];
              } else {
                return entry.children?.where((element) => element.name.toLowerCase().contains(queries[2].toLowerCase())).toList() ?? [];
              }
            } else {
              return [];
            }
          } else {
            return [];
          }
        case 4: // village
          AddressEntry? entry = addressHierarchy.where((element) => element.name == queries[0]).firstOrNull;
          if (entry != null) {
            entry = entry.children?.where((element) => element.name == queries[1]).firstOrNull;
            if (entry != null) {
              entry = entry.children?.where((element) => element.name == queries[2]).firstOrNull;
              if (entry != null) {
                if (showAllChildren) {
                  entry = entry.children?.where((element) => element.name == queries[3]).firstOrNull;
                  return entry != null ? (entry.children ?? []) : [];
                } else {
                  return entry.children?.where((element) => element.name.toLowerCase().contains(queries[3].toLowerCase())).toList() ?? [];
                }
              } else {
                return [];
              }
            } else {
              return [];
            }
          } else {
            return [];
          }
        default:
          return [];
      }
  }

  Widget _profileActionButton() {
    var profileValidated = profile.validate();
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(width: 10.0),
          if (profileValidated)
            ValueListenableBuilder(
              valueListenable: _profileSaved,
              builder: (context, saved, child) {
                if (saved) {
                  return _showVisitStartOption();
                }
                return FloatingActionButton(
                    onPressed: () async {
                      var saved = await validateAndSave(profile);
                      _profileSaved.value = saved;
                    },
                    tooltip: lblSaveProfile,
                    child: const Icon(Icons.save_outlined),
                );
              },
            )
          else if (!profileValidated)
            FloatingActionButton(
              onPressed: () {
                // should show error about why not validated
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(errInvalidProfile)),
                );
              },
              tooltip: lblError,
              backgroundColor: Colors.redAccent,
              child: const Icon(Icons.error),
            )
          else if (_profileSaved.value)
              FloatingActionButton.extended(
                label: const Text(lblStartVisit),
                backgroundColor: Colors.pink,
                onPressed: () {
                  // Navigator.pushNamed(context, '/patientSummary', arguments: patient);
                },
                tooltip: lblStartVisit,
                icon: const Icon(Icons.start),
              )
          else
            SizedBox()
        ]
    );
  }

  VisitTypesFab _showVisitStartOption() {
    return VisitTypesFab(
              label: lblStartVisit,
              icon: Icons.start_outlined,
              onSelect: (visitType) async {
                try {
                  await Visits().startVisit(profile.uuid!, visitType.uuid!);
                  if (!mounted) return;
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(errStartingVisit)),
                  );
                }
              },
            );
  }

  void _pageAction(int pageNumber) {
    bool pageValidated = false;
    switch (_pageIndex.value) {
      case 0:
        pageValidated = _validateAndUpdateBasicDetails();
        break;
      case 1:
        pageValidated = _validateAndUpdateAttributes();
        break;
      case 2:
        pageValidated = _validateAndUpdateAddress();
        break;
      case 3:
      default:
        pageValidated = true;
        break;
    }
    if (pageValidated) {
      _pageIndex.value = pageNumber;
    }
  }

  bool _validateAndUpdateBasicDetails() {
    if (_basicDetailsFormKey.currentState!.validate()) {
      _basicDetailsFormKey.currentState!.save();
    } else {
      return false;
    }
    var data = _basicDetailsController.getData();
    if (data?.identifiers != null) {
      profile.updateIdentifiers(data!.identifiers!);
    }
    //profile?.updatePhone(_phoneNumber);
    profile.updateBasicDetails(ProfileBasics(
        firstName: data?.firstName,
        lastName: data?.lastName,
        gender: data?.gender,
        dateOfBirth: data?.dateOfBirth));
    return true;
  }

  bool _validateAndUpdateAttributes() {
    if (_profileAttributeFormKey.currentState!.validate()) {
      _profileAttributeFormKey.currentState!.save();
    } else {
      return false;
    }
    var data = _attributesController.getData();
    if (data != null && data.isNotEmpty) {
      profile.updateAttributes(data);
    }
    return true;
  }

  bool _validateAndUpdateAddress() {
    if (_addressFormKey.currentState!.validate()) {
      _addressFormKey.currentState!.save();
    } else {
      return false;
    }
    var data = _addressController.getData();
    if (data != null) {
      profile.updateProfileAddress(data);
    }
    return true;
  }

  ProfileModel initializeModel() {
    var profileModel = ProfileModel(primaryPatientIdentifierType: primaryPatientIdentifierType);
    _attributesController.setData([]);
    _addressController.setData(ProfileAddress());
    _basicDetailsController.setData(ProfileBasics(attributes: [], identifiers: []));
    return profileModel;
  }

  Future<bool> validateAndSave(ProfileModel profile) async {
    if (!profile.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errInvalidProfile)),
      );
      return false;
    }
    if (profile.isNewPatient) {
        return Registrations().createPatient(profile)
            .then((value) => profile.updateFrom(value))
          .then((value) => true)
          .onError((error, stackTrace) {
              if (!mounted) return false;
              String errorMsg = error is Failure ? error.message : '';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Could not save patient. $errorMsg')),
              );
              return false;
            });
    } else {
      ///TODO: update patient
      // var response = await Registrations().updatePatient(profile.toProfileJson());
      // debugPrint('Profile post response: $response');
      // var serverResponse = ProfileModel.fromProfileJson(response);
      // profile.updateFrom(serverResponse);
    }
    return true;
  }
}

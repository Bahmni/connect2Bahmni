import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'profile_age.dart';
import '../models/person_age.dart';
import '../models/profile_model.dart';
import '../../domain/models/omrs_identifier_type.dart';
import '../../providers/meta_provider.dart';
import '../../utils/date_time.dart';
import '../../widgets/form_fields.dart';

class BasicProfile extends StatefulWidget {

  final ProfileBasics? basicDetails;
  final String? phoneNumber;
  final List<ProfileIdentifier>? identifiers;

  const BasicProfile({Key? key, this.phoneNumber, this.basicDetails, this.identifiers}) : super(key: key);

  @override
  State<BasicProfile> createState() => _BasicProfileState();
}

const String lblBirthDate =  'Birth Date';
const String lblNext = 'Next';
const String lblGender =  'Gender';
const String lblGivenName =  'First Name';
const String lblFamilyName =  'Last Name';
const String msgEnterGender = 'Please select gender';
const String msgUpdateAge = 'Please update age';
const String msgEnterDob = 'Please select birth date';
const String msgEnterFirstName = 'Please enter first name';
const String msgEnterLastName = 'Please enter last name';
const String msgEnterValidPhone = 'Please enter valid phone number';

class _BasicProfileState extends State<BasicProfile> {

  final _basicProfileFormKey = GlobalKey<FormState>();
  String? _firstName = '', _lastName = '', _gender = '', _phoneNumber = '';
  DateTime? _birthDate;
  TextEditingController dobController = TextEditingController();
  bool showAgePicker = false;
  late List<String> _abdmIdentifierNames;
  final Map<String, String> _identifierValues = {};
  final List<OmrsIdentifierType> _assignableIdentifierTypes = [];


  @override
  void initState() {
    super.initState();
    _firstName = widget.basicDetails?.firstName ?? '';
    _lastName = widget.basicDetails?.lastName ?? '';
    _gender = widget.basicDetails?.gender?.name ?? '';
    _birthDate = widget.basicDetails?.dateOfBirth;
    _phoneNumber = widget.phoneNumber;
    _abdmIdentifierNames = dotenv.get('abdm.identifiers', fallback: '').split(',');

    var metaProvider = Provider.of<MetaProvider>(context, listen: false);
    var idNames = dotenv.get('app.additionalIdentifiers', fallback: '').split(',');
    idNames.where((name) => name.trim().isNotEmpty).forEach((name) {
      metaProvider.patientIdentifierTypes?.where((idType) {
        if (_isPrimaryIdenfier(idType)) return false;
        return idType.name == name.trim();
      }).forEach((idType) {
        _assignableIdentifierTypes.add(idType);
      });
    });

    for (var idType in _assignableIdentifierTypes) {
      widget.identifiers?.where((id) => id.typeUuid == idType.uuid).forEach((id) {
        _identifierValues[idType.uuid!] = id.value;
      });
    }
  }

  bool _isPrimaryIdenfier(OmrsIdentifierType idType) => idType.primary != null && idType.primary == true;


  @override
  void dispose() {
    dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _basicDetails();
  }

  Widget _basicDetails() {
    return Form(
      key: _basicProfileFormKey,
      child: ListView(
        children: [
          Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceVariant,
              // shape: RoundedRectangleBorder(
              //   side: BorderSide(
              //     color: Theme.of(context).colorScheme.outline,
              //   ),
              //   borderRadius: const BorderRadius.all(Radius.circular(12)),
              // ),
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
          ),
          ...identifierFields(),
          ..._firstNameField(),
          ..._lastNameField(),
          ...genderField(),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(lblBirthDate),
              ),
              Switch(value: showAgePicker,
                onChanged:(value) {
                  setState(() {
                    showAgePicker=value;
                  });
                },
                activeTrackColor: Colors.lightBlueAccent,
                activeColor: Colors.blueGrey,
              ),
            ],
          ),
          birthDateDisplay(),
          if (!showAgePicker) displayDobAgeInText(),
          //_dobPickerFormField(currentDate),
          _phoneNumberField(),
          // const SizedBox(
          //   height: 5.0,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  if (showAgePicker) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(msgUpdateAge)),
                    );
                    return;
                  }
                  if (_basicProfileFormKey.currentState?.validate() ?? false) {
                    _basicProfileFormKey.currentState?.save();
                    updateDetails();
                  }
                },
                child: const Text(lblNext),
              )
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> genderField() {
    return [
      const SizedBox(height: 5.0),
      const SizedBox(height: 5.0),
      const Text(lblGender),
      GenderFormField(
        initialValue: _gender ?? Gender.male.name,
        validator: (value) {
          return value != null && value.isEmpty ? msgEnterGender : null;
        },
        onSaved: (value) {
          _gender = value;
        },
      )
    ];
  }

  List<Widget> identifierFields() {
    if (_assignableIdentifierTypes.isEmpty) {
      return [];
    }
    return _assignableIdentifierTypes.map((identifierType) {
      bool allowABHALinkage = _abdmIdentifierNames.isEmpty ? false : _abdmIdentifierNames.contains(identifierType.name!.trim());
      return Container(
        padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.all(Radius.circular(20)),
          // boxShadow: const [
          //   BoxShadow(blurRadius: 2.0, spreadRadius: 1, color: Colors.grey),
          // ],
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x39000000),
              offset: Offset(0, -1),
            )
          ],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: Row(
          children: [
            Text(identifierType.name!,),
            SizedBox(width: 5.0),
            Expanded(
              child: TextFormField(
                autofocus: false,
                readOnly: allowABHALinkage,
                initialValue: _identifierValues[identifierType.uuid!] ?? '',
                validator: (value) {
                  return null;
                  //return value != null && value.isEmpty ? msgEnterFirstName : null;
                },
                onSaved: (value) {
                  _identifierValues[identifierType.uuid!] = value ?? '';
                },
                decoration: InputDecoration( hintText: _identifierHint(),),
              ),
              // child: TextField(
              //   readOnly: allowABHALinkage,
              // ),
            ),
            SizedBox(width: 5.0),
            if (allowABHALinkage)
              IconButton(
                icon: const Icon(Icons.link_outlined),
                highlightColor: Colors.pink,
                onPressed: () {
                },
              ),
            // OutlinedButton(
            //   onPressed: () {},
            //   child: Text("Edit"),
            // )
          ],
        ),
      );
    }).toList();
  }

  String _identifierHint() {
    return '';
  }

  Widget birthDateDisplay() {
    if (showAgePicker) {
      return AgeDisplayWidget(initialValue: _birthDate, editMode: true, onCancel: _closeAgeWidget, onSet: _ageUpdated,);
    }
    if (dobController.text.isEmpty && _birthDate != null) {
      dobController.text = DateFormat("dd-MM-yyyy").format(_birthDate ?? DateTime.now());
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: TextFormField(
              controller: dobController,
              validator: (value) {
                return value != null && value.isEmpty ? msgEnterDob : null;
              },
              onTap: () async {
                //FocusScope.of(context).requestFocus(FocusNode());
                DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: _birthDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now());
                if (date != null) {
                  dobController.text = DateFormat("dd-MM-yyyy").format(date);
                  setState(() {
                    _birthDate = date;
                  });
                }
              }
          ),
        ),
      ],
    );
  }

  InputDatePickerFormField _dobPickerFormField(DateTime currentDate) {
    return InputDatePickerFormField(
        initialDate: _birthDate,
        fieldLabelText: 'Birth Date',
        firstDate:  DateTime(currentDate.year-100, 1, 1) ,
        lastDate: currentDate,
        onDateSaved: (value) {
          _birthDate = value;
        }
    );
  }

  void updateDetails() {
    var model = Provider.of<ProfileModel?>(context, listen: false);
    List<ProfileIdentifier> identifiers = [];
    for (var element in _identifierValues.entries) {
      if (element.value.isNotEmpty) {
        var identifier = _assignableIdentifierTypes.where((id) => id.uuid! == element.key).first;
        var profileIdentifier = ProfileIdentifier(typeUuid: element.key, value: element.value, name: identifier.name!);
        identifiers.add(profileIdentifier);
      }
    }
    if (identifiers.isNotEmpty) {
      model?.updateIdentifiers(identifiers);
    }
    model?.updatePhone(_phoneNumber);
    model?.updateBasicDetails(ProfileBasics(_firstName, _lastName, toGenderType(_gender), _birthDate));
    model?.nextSection();
  }

  List<Widget> _firstNameField() {
    return [
      SizedBox(height: 5.0),
      const SizedBox(height: 5.0),
      const SizedBox(height: 5.0),
      const Text(lblGivenName),
      TextFormField(
        autofocus: false,
        initialValue: _firstName,
        validator: (value) {
          return value != null && value.isEmpty ? msgEnterFirstName : null;
        },
        onSaved: (value) => _firstName = value,
        decoration: const InputDecoration( hintText: lblGivenName,),
      )];
  }

  List<Widget> _lastNameField() {
    return [
      const SizedBox(height: 5.0),
      const SizedBox(height: 5.0),
      const Text(lblFamilyName),
      TextFormField(
        autofocus: false,
        initialValue: _lastName,
        validator: (value) {
          return value != null && value.isEmpty ? msgEnterLastName : null;
        },
        onSaved: (value) => _lastName = value,
        decoration: const InputDecoration( hintText: lblFamilyName,),
      )];
  }

  Widget _phoneNumberField() {
    return TextFormField(
      autofocus: false,
      initialValue: _phoneNumber,
      decoration: InputDecoration(
        hintText: 'Phone',
        prefixIcon: Icon(Icons.phone),
        // focusedBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(25.0),
        //     borderSide: const BorderSide(
        //         color: Colors.green,
        //         width: 1.5
        //     )
        // ),
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(25.0),
        //     borderSide:const  BorderSide(
        //         color: Colors.blue,
        //         width: 1.5
        //     )
        // ),
        // enabledBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(25.0),
        //     borderSide:const  BorderSide(
        //         color: Colors.blue,
        //         width: 1.5
        //     )
        // ),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return msgEnterValidPhone;
        }
        var regExpr = r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$';
        if(!RegExp(regExpr).hasMatch(value)){
          return msgEnterValidPhone;
        }
        return null;
      },
      onSaved: (value) => _phoneNumber = value,
      //decoration: const InputDecoration( hintText: lblPhoneNumber,),
    );
  }

  Widget displayDobAgeInText() {
    var personAge = _birthDate != null ? calculateAge(_birthDate!) : PersonAge(0, 0);
    return Text(showAgePicker ? '(DOB: $_birthDate)' : '(Age: ${personAge.year}y ${personAge.month}m ${personAge.days}d)');
  }


  void _closeAgeWidget() {
    setState(() {
      showAgePicker = false;
    });
  }

  void _ageUpdated(DateTime value) {
    dobController.text = DateFormat("dd-MM-yyyy").format(value);
    setState(() {
      _birthDate = value;
      showAgePicker = false;
    });
  }
}
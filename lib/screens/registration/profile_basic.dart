import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'profile_age.dart';
import 'profile_controller.dart';
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
  final GlobalKey<FormState>? formKey;
  final ProfileController<ProfileBasics>? controller;

  const BasicProfile({Key? key, this.phoneNumber, this.basicDetails, this.identifiers, this.formKey, this.controller}) : super(key: key);

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
const String msgEnterIdentifier = 'Please enter a valid identifier';
const String msgEnterLastName = 'Please enter last name';
const String msgEnterValidPhone = 'Please enter valid phone number';

class _BasicProfileState extends State<BasicProfile> {

  final _basicProfileFormKey = GlobalKey<FormState>();
  String? _firstName = '', _lastName = '', _gender = '';
  DateTime? _birthDate;
  TextEditingController dobController = TextEditingController();
  bool showAgePicker = false;
  late List<String> _abdmIdentifierNames;
  final Map<String, String> _identifierValues = {};
  final List<OmrsIdentifierType> _assignableIdentifierTypes = [];


  @override
  void initState() {
    debugPrint('BasicProfile: initState. firstName - ${widget.basicDetails?.firstName}, lastName = ${widget.basicDetails?.lastName}');
    _firstName = widget.basicDetails?.firstName ?? '';
    _lastName = widget.basicDetails?.lastName ?? '';
    _gender = widget.basicDetails?.gender?.name ?? '';
    _birthDate = widget.basicDetails?.dateOfBirth;
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
    super.initState();
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
    debugPrint('BasicProfile: build. firstName - ${widget.basicDetails?.firstName}, lastName = ${widget.basicDetails?.lastName}');
    return Form(
      key: widget.formKey ?? _basicProfileFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          //_phoneNumberField(),
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
        onSaved: _updateGender,
      )
    ];
  }

  void _updateGender(String? value) {
      _gender = value;
      widget.controller?.getData()?.gender = toGenderType(value);
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
                  if (identifierType.required != null && identifierType.required!) {
                    return value != null && value.isEmpty ? msgEnterIdentifier : null;
                  }
                  return null;
                },
                onSaved: (value) {
                  _identifierValues[identifierType.uuid!] = value ?? '';
                  _updateIdentifier(identifierType, value);
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


  void _updateIdentifier(OmrsIdentifierType identifierType, String? value) {
    Iterable<ProfileIdentifier>? iterator = widget.controller?.getData()?.identifiers?.where((element) => element.typeUuid == identifierType.uuid);
    if (iterator != null && iterator.isNotEmpty) {
      iterator.first.value = value!;
    } else if (value != null && value.isNotEmpty) {
      widget.controller?.getData()?.identifiers?.add(ProfileIdentifier(
          typeUuid: identifierType.uuid,
          value: value,
          name: identifierType.name!,
          preferred: identifierType.primary));
    }
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
              },
              onSaved: _updateDob,
          ),
        ),
      ],
    );
  }

  // InputDatePickerFormField _dobPickerFormField(DateTime currentDate) {
  //   return InputDatePickerFormField(
  //       initialDate: _birthDate,
  //       fieldLabelText: 'Birth Date',
  //       firstDate:  DateTime(currentDate.year-100, 1, 1) ,
  //       lastDate: currentDate,
  //       onDateSaved: (value) {
  //         _birthDate = value;
  //       }
  //   );
  // }

  void _updateDob(String? value) {
    var dob = DateFormat("dd-MM-yyyy").parse(value!);
    _birthDate = dob;
    widget.controller?.getData()?.dateOfBirth = dob;
  }

  List<Widget> _firstNameField() {
    return [
      const SizedBox(height: 15.0),
      const Text(lblGivenName),
      TextFormField(
        autofocus: false,
        initialValue: _firstName,
        validator: (value) {
          return value != null && value.isEmpty ? msgEnterFirstName : null;
        },
        onSaved: _updateFirstName,
        decoration: const InputDecoration( hintText: lblGivenName,),
      )];
  }

  void _updateFirstName(String? value) {
    _firstName = value;
    widget.controller?.getData()?.firstName = value;
  }

  List<Widget> _lastNameField() {
    return [
      const SizedBox(height: 10.0),
      const Text(lblFamilyName),
      TextFormField(
        autofocus: false,
        initialValue: _lastName,
        validator: (value) {
          return value != null && value.isEmpty ? msgEnterLastName : null;
        },
        onSaved: _updateLastName,
        decoration: const InputDecoration( hintText: lblFamilyName,),
      )];
  }

  void _updateLastName(String? value) {
    _lastName = value;
    widget.controller?.getData()?.lastName = value;
  }

  // Widget _phoneNumberField() {
  //   return TextFormField(
  //     autofocus: false,
  //     initialValue: _phoneNumber,
  //     decoration: InputDecoration(
  //       hintText: 'Phone',
  //       prefixIcon: Icon(Icons.phone),
  //       // focusedBorder: OutlineInputBorder(
  //       //     borderRadius: BorderRadius.circular(25.0),
  //       //     borderSide: const BorderSide(
  //       //         color: Colors.green,
  //       //         width: 1.5
  //       //     )
  //       // ),
  //       // border: OutlineInputBorder(
  //       //     borderRadius: BorderRadius.circular(25.0),
  //       //     borderSide:const  BorderSide(
  //       //         color: Colors.blue,
  //       //         width: 1.5
  //       //     )
  //       // ),
  //       // enabledBorder: OutlineInputBorder(
  //       //     borderRadius: BorderRadius.circular(25.0),
  //       //     borderSide:const  BorderSide(
  //       //         color: Colors.blue,
  //       //         width: 1.5
  //       //     )
  //       // ),
  //     ),
  //     keyboardType: TextInputType.phone,
  //     validator: (value) {
  //       if (value == null || value.isEmpty) {
  //         return msgEnterValidPhone;
  //       }
  //       var regExpr = r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$';
  //       if(!RegExp(regExpr).hasMatch(value)){
  //         return msgEnterValidPhone;
  //       }
  //       return null;
  //     },
  //     onSaved: (value) => _phoneNumber = value,
  //     //decoration: const InputDecoration( hintText: lblPhoneNumber,),
  //   );
  // }

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
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import '../../providers/meta_provider.dart';
import '../models/profile_model.dart';
import 'patient_registration.dart';

class ProfileAttributes extends StatefulWidget {
  final List<ProfileAttribute>? attributes;
  final GlobalKey<FormState>? formKey;
  const ProfileAttributes({Key? key, this.attributes, this.formKey}) : super(key: key);

  @override
  State<ProfileAttributes> createState() => _ProfileAttributesState();
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
const regExprPhoneNumber = r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$';
const regExprEmail = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

class _ProfileAttributesState extends State<ProfileAttributes> {

  List<ProfileAttributeType> attributeTypes = [];
  Map<String, String?> attributeValues = {};


  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    var metaProvider = Provider.of<MetaProvider>(context, listen: false);
    List<String> attributes = dotenv.get('app.patientAttributes', fallback: '').split(',');
    attributes.where((name) => name.trim().isNotEmpty).forEach((name) {
      name = name.trim();
      var mandatory = false;
      if (name.endsWith('*')) {
        name = name.substring(0,name.length-1);
        mandatory = true;
      }
      metaProvider.personAttrTypes?.where((element) => element.name == name).forEach((element) {
        var profileAttributeType = ProfileAttributeType.fromPersonAttributeType(element);
        profileAttributeType.mandatory = mandatory;
        attributeTypes.add(profileAttributeType);
      });
    });
    for (var attrType in attributeTypes) {
      widget.attributes?.where((attr) => attr.typeUuid == attrType.uuid).forEach((attr) {
        attributeValues[attrType.uuid!] = attr.value;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildForm();
  }

  Widget _buildForm() {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...attributeFields(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  if (widget.formKey?.currentState?.validate() ?? false) {
                    widget.formKey?.currentState?.save();
                    moveToPreviousSection();
                  }
                },
                child: const Text(lblPrevious),
              ),
              OutlinedButton(
                onPressed: () {
                  if (widget.formKey?.currentState?.validate() ?? false) {
                    widget.formKey?.currentState?.save();
                    moveToNextSection();
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

  void moveToPreviousSection() {
    var model = Provider.of<ProfileModel?>(context, listen: false);
    updateAttributes(model);
    model?.previousSection();
  }

  void updateAttributes(ProfileModel? model) {
    List<ProfileAttribute> attributes = [];
    for (var element in attributeValues.entries) {
      if (element.value != null) {
        if (element.value!.isEmpty) continue;
        var attrType = attributeTypes.where((id) => id.uuid! == element.key).first;
        attributes.add(ProfileAttribute(typeUuid: element.key, value: element.value, name: attrType.name, description: attrType.description));
      }
    }
    model?.updateAttributes(attributes);
  }

  List<Widget> attributeFields() {
    var fields = <Widget>[];
    for (var attributeType in attributeTypes) {
      var field = _attributeField(attributeType);
      if (field != null) {
        fields.add(const SizedBox(height: 5.0));
        fields.add(Text(attributeType.description ?? attributeType.name!));
        fields.add(field);
      }
    }
    return fields;
  }

  Widget _phoneNumberField(ProfileAttributeType attributeType) {
    var mandatory = attributeType.mandatory != null && attributeType.mandatory!;
    var label = attributeType.description ?? attributeType.name!;
    return TextFormField(
      autofocus: false,
      initialValue: attributeValues[attributeType.uuid!] ?? '',
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: Icon(Icons.phone),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return mandatory ? msgEnterValidPhone : null;
        }
        if(!RegExp(regExprPhoneNumber).hasMatch(value)) {
          return msgEnterValidPhone;
        }
        return null;
      },
      onSaved: (value) => attributeValues[attributeType.uuid!] = value,
    );
  }

  Widget? _attributeField(ProfileAttributeType attributeType) {
    if (attributeType.name!.toLowerCase().contains("phone")) {
      return _phoneNumberField(attributeType);
    }
    var mandatory = attributeType.mandatory != null && attributeType.mandatory!;
    var label = attributeType.description ?? attributeType.name!;
    return TextFormField(
      autofocus: false,
      initialValue: attributeValues[attributeType.uuid!] ?? '',
      decoration: InputDecoration(
        hintText: label,
      ),
      //keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return mandatory ? 'Please enter ${attributeType.name}' : null;
        }

        if (attributeType.name!.toLowerCase().contains("email")) {
          final bool emailValid = RegExp(regExprEmail).hasMatch(value);
          if (!emailValid) {
            return 'Please enter valid email';
          }
        }
        return null;
      },
      onSaved: (value) => attributeValues[attributeType.uuid!] = value,
    );
  }

  void moveToNextSection() {
    var model = Provider.of<ProfileModel?>(context, listen: false);
    updateAttributes(model);
    model?.nextSection();
  }



}
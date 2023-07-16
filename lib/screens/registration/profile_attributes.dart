import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import '../../providers/meta_provider.dart';
import '../models/profile_model.dart';
import 'profile_controller.dart';

class ProfileAttributes extends StatefulWidget {
  final List<ProfileAttribute>? attributes;
  final GlobalKey<FormState>? formKey;
  final ProfileController<List<ProfileAttribute>>? controller;
  final bool readOnly;
  const ProfileAttributes({Key? key, this.attributes, this.formKey, this.controller, this.readOnly = false}) : super(key: key);

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
  final _attributesFormKey = GlobalKey<FormState>();


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
      List<ProfileAttribute>? attributes = widget.attributes ?? widget.controller?.getData();
      attributes?.where((attr) => attr.typeUuid == attrType.uuid).forEach((attr) {
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
      key: widget.formKey ?? _attributesFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...attributeFields(),
        ],
      ),
    );
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
      enabled: !widget.readOnly,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return mandatory ? msgEnterValidPhone : null;
        }
        if(!RegExp(regExprPhoneNumber).hasMatch(value)) {
          return msgEnterValidPhone;
        }
        return null;
      },
      onSaved: (value) {
        attributeValues[attributeType.uuid!] = value;
        updateAttribute(attributeType, value);
      },
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
      enabled: !widget.readOnly,
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
      onSaved: (value) {
        attributeValues[attributeType.uuid!] = value;
        updateAttribute(attributeType, value);
      },
    );
  }

  void updateAttribute(ProfileAttributeType attributeType, String? value) {
    if (widget.controller != null) {
      var attributes = widget.controller?.getData();
      if (attributes == null || attributes.isEmpty) {
        widget.controller?.setData([ProfileAttribute(
                typeUuid: attributeType.uuid,
                value: value,
                name: attributeType.name,
                description: attributeType.description)
        ]);
        return;
      }
      var iterator = attributes.where((element) => element.typeUuid == attributeType.uuid);
      if (iterator.isEmpty) {
        attributes.add(ProfileAttribute(
            typeUuid: attributeType.uuid,
            value: value,
            name: attributeType.name,
            description: attributeType.description)
        );
        return;
      }
      iterator.first.value = value;
    }
  }

}
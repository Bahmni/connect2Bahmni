import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../screens/models/profile_model.dart';
import '../screens/registration/profile_controller.dart';
import '../domain/models/address_entry.dart';

class AddressScreen extends StatefulWidget {
  final ProfileAddress? address;
  final GlobalKey<FormState>? formKey;
  final ProfileController<ProfileAddress>? controller;
  final bool readOnly;
  final OnAddressSearch? onSearch;
  const AddressScreen({Key? key, this.address, this.controller, this.formKey, this.readOnly = false, this.onSearch}) : super(key: key);
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _addressFormKey = GlobalKey<FormState>();

  static const lblSelectAddress = 'Select Address';
  static const lblSubDistrict = "Sub-district";
  static const lblDistrict = "District";
  static const lblState = "State";
  static const lblVillage = "Village";
  //static const msgNoMatchFound = 'No match found';
  static const msgSelect = 'Select';

  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _subDistrictController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();


  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _stateController.text = widget.address?.stateProvince ?? '';
      _districtController.text = widget.address?.countyDistrict ?? '';
      _subDistrictController.text = widget.address?.subDistrict ?? '';
      _villageController.text = widget.address?.cityVillage ?? '';
    }
  }


  @override
  void dispose() {
    _villageController.dispose();
    _subDistrictController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return Form(
        key: widget.formKey ?? _addressFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lblSelectAddress),
            _buildStateProvinceField(context),
            SizedBox(height: 5.0),
            _buildDistrictField(context),
            SizedBox(height: 5.0),
            _buildSubDistrictField(context),
            SizedBox(height: 5.0),
            _buildVillageField(context),
          ],
        ),
      );
  }

  TypeAheadFormField<String> _buildStateProvinceField(BuildContext context) {
    return
      TypeAheadFormField<String>(
          enabled: !widget.readOnly,
          textFieldConfiguration: TextFieldConfiguration(
              //autofocus: true,
              decoration: InputDecoration(
                  hintText: lblState
              ),
              enabled: !widget.readOnly,
              controller: _stateController
          ),
          noItemsFoundBuilder: (context) {
            return SizedBox();
          },
          suggestionsCallback: (pattern) async {
            // if (pattern.isEmpty) {
            //   return districts;
            // }
            if (widget.onSearch != null) {
              var addressPattern = pattern;
              List<AddressEntry> matches = await widget.onSearch!(addressPattern);
              return matches.map((e) => e.name).toList();
            }
            //return districts.where((element) => element.toLowerCase().contains(pattern.toLowerCase()));
            return [];
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion.toString()),
              subtitle: Text(suggestion),
            );
          },
          onSuggestionSelected: (suggestion) {
            _stateController.text = suggestion;
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$msgSelect $lblState';
            }
            return null;
          },
          onSaved: (value) {
            _updateAddress();
          }
      );
  }

  TypeAheadFormField<String> _buildDistrictField(BuildContext context) {
    return
      TypeAheadFormField<String>(
          enabled: !widget.readOnly,
          //initialValue: selectedDistrict,
          textFieldConfiguration: TextFieldConfiguration(
              autofocus: true,
              // style: DefaultTextStyle.of(context).style.copyWith(
              //     fontStyle: FontStyle.italic
              // ),
              decoration: InputDecoration(
                  hintText: lblDistrict
              ),
              enabled: !widget.readOnly,
              controller: _districtController
          ),
          noItemsFoundBuilder: (context) {
            return SizedBox();
          },
          suggestionsCallback: (pattern) async {
            if (widget.onSearch != null) {
              var addressPattern = '${_stateController.text}|$pattern';
              List<AddressEntry> matches = await widget.onSearch!(addressPattern);
              return matches.map((e) => e.name).toList();
            }
            return [];
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion.toString()),
              subtitle: Text(suggestion),
            );
          },
          onSuggestionSelected: (suggestion) {
            _districtController.text = suggestion;
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$msgSelect $lblDistrict';
            }
            return null;
          },
          onSaved: (value) {
            _updateAddress();
          }
      );
  }

  TypeAheadFormField<String> _buildSubDistrictField(BuildContext context) {
    return TypeAheadFormField(
        enabled: !widget.readOnly,
        textFieldConfiguration: TextFieldConfiguration(
            autofocus: true,
            decoration: InputDecoration(
                hintText: lblSubDistrict
            ),
            enabled: !widget.readOnly,
            controller: _subDistrictController
        ),
        noItemsFoundBuilder: (context) {
          return SizedBox();
        },
        suggestionsCallback: (pattern) async {
          if (widget.onSearch != null) {
            var addressPattern = '${_stateController.text}|${_districtController.text}|$pattern';
            List<AddressEntry> matches = await widget.onSearch!(addressPattern);
            return matches.map((e) => e.name).toList();
          }
          return [];
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion.toString()),
            subtitle: Text(suggestion),
          );
        },
        onSuggestionSelected: (suggestion) {
          _subDistrictController.text = suggestion;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$msgSelect $lblSubDistrict';
          }
          return null;
        },
        onSaved: (value) {
          _updateAddress();
        }
    );
  }

  TypeAheadFormField<String> _buildVillageField(BuildContext context) {
    return TypeAheadFormField(
        enabled: !widget.readOnly,
        textFieldConfiguration: TextFieldConfiguration(
            autofocus: true,
            decoration: InputDecoration(
                hintText: lblVillage
            ),
            enabled: !widget.readOnly,
            controller: _villageController
        ),
        noItemsFoundBuilder: (context) {
          return SizedBox();
        },
        suggestionsCallback: (pattern) async {
          if (widget.onSearch != null) {
            var addressPattern = '${_stateController.text}|${_districtController.text}|${_subDistrictController.text}|$pattern';
            List<AddressEntry> matches = await widget.onSearch!(addressPattern);
            return matches.map((e) => e.name).toList();
          }
          return [];
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion.toString()),
            subtitle: Text(suggestion),
          );
        },
        onSuggestionSelected: (suggestion) {
          _villageController.text = suggestion;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$msgSelect $lblVillage';
          }
          return null;
        },
        onSaved: (value) {
          _updateAddress();
        }
    );
  }

  void _updateAddress() {
    debugPrint('updating address: district = ${_districtController.text}, subDistrict = ${_subDistrictController.text}, village = ${_villageController.text}');
    if (widget.controller != null) {
       ProfileAddress? address = widget.controller?.getData();
       if (address != null) {
         address.stateProvince = _stateController.text.trim();
         address.countyDistrict = _districtController.text.trim();
         address.subDistrict = _subDistrictController.text.trim();
         address.cityVillage = _villageController.text.trim();
       } else {
         widget.controller?.setData(
             ProfileAddress(
               stateProvince: _stateController.text.trim(),
               cityVillage: _villageController.text.trim(),
               subDistrict: _subDistrictController.text.trim(),
               countyDistrict: _districtController.text.trim()));
       }
    }
  }
}

typedef OnAddressSearch = Future<List<AddressEntry>> Function(String pattern);
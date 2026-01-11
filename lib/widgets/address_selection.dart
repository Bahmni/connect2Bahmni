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
  const AddressScreen({super.key, this.address, this.controller, this.formKey, this.readOnly = false, this.onSearch});
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
  //static const msgSelect = 'Select';

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
    return SingleChildScrollView(
      reverse: true,
      child: Form(
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
      )
    );
  }

  TypeAheadField<String> _buildStateProvinceField(BuildContext context) {
    return
      TypeAheadField<String>(
          builder: (context, controller, focusNode) {
            return TextField(
                controller: _stateController,
                focusNode: focusNode,
                autofocus: true,
                enabled: !widget.readOnly,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: lblState,
                )
            );
          },
          suggestionsCallback: (pattern) async {
            if (widget.onSearch != null) {
              var addressPattern = pattern;
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
          // validator: (value) {
          //   if (value == null || value.isEmpty) {
          //     return '$msgSelect $lblState';
          //   }
          //   return null;
          // },
          onSelected: (value) {
            _stateController.text = value;
            _updateAddress();
          }
      );
  }

  TypeAheadField<String> _buildDistrictField(BuildContext context) {
    return
      TypeAheadField<String>(
          builder: (context, controller, focusNode) {
            return TextField(
                controller: _districtController,
                focusNode: focusNode,
                autofocus: true,
                enabled: !widget.readOnly,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: lblDistrict,
                )
            );
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
          // validator: (value) {
          //   if (value == null || value.isEmpty) {
          //     return '$msgSelect $lblDistrict';
          //   }
          //   return null;
          // },
          onSelected: (value) {
            _districtController.text = value;
            _updateAddress();
          }
      );
  }

  TypeAheadField<String> _buildSubDistrictField(BuildContext context) {
    return TypeAheadField(
        builder: (context, controller, focusNode) {
          return TextField(
              controller: _subDistrictController,
              focusNode: focusNode,
              autofocus: true,
              enabled: !widget.readOnly,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: lblSubDistrict,
              )
          );
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
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return '$msgSelect $lblSubDistrict';
        //   }
        //   return null;
        // },
        onSelected: (value) {
          _subDistrictController.text = value;
          _updateAddress();
        }
    );
  }

  TypeAheadField<String> _buildVillageField(BuildContext context) {
    return TypeAheadField(
        //enabled: !widget.readOnly,
        builder: (context, controller, focusNode) {
          return TextField(
              controller: _villageController,
              focusNode: focusNode,
              autofocus: true,
              enabled: !widget.readOnly,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: lblVillage,
              )
          );
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
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return '$msgSelect $lblVillage';
        //   }
        //   return null;
        // },
        onSelected: (value) {
          _villageController.text = value;
          _updateAddress();
        }
    );
  }

  void _updateAddress() {
    if (widget.controller != null) {
       ProfileAddress? address = widget.controller?.getData();
       if (address != null) {
         address.stateProvince = _stateController.text.trim();
         address.countyDistrict = _districtController.text.trim();
         address.subDistrict = _subDistrictController.text.trim();
         address.cityVillage = _villageController.text.trim();
       }
    }
  }
}

typedef OnAddressSearch = Future<List<AddressEntry>> Function(String pattern);

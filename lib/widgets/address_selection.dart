import 'package:flutter/material.dart';

import '../screens/models/profile_model.dart';
import 'form_fields.dart';
import '../screens/registration/profile_controller.dart';

class AddressScreen extends StatefulWidget {
  final ProfileAddress? address;
  final GlobalKey<FormState>? formKey;
  final ProfileController<ProfileAddress>? controller;
  const AddressScreen({Key? key, this.address, this.controller, this.formKey}) : super(key: key);
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _addressFormKey = GlobalKey<FormState>();

  static const lblSelectAddress = 'Select Address';
  static const lblSubDistrict = "Sub District";
  static const lblDistrict = "District";
  static const lblVillage = "Village";
  static const msgPleaseSelectValue = 'Please select a value';

  String? selectedDistrict;
  String? selectedSubDistrict;
  String? selectedVillage;

  List<String> states = ['Karnataka'];
  List<String> districts = ['District A', 'District B', 'District C'];
  Map<String, List<String>> subDistricts = {
    'District A': ['Subdistrict A1', 'Subdistrict A2', 'Subdistrict A3'],
    'District B': ['Subdistrict B1', 'Subdistrict B2'],
    'District C': ['Subdistrict C1', 'Subdistrict C2', 'Subdistrict C3']
  };
  Map<String, List<String>> villages = {
    'Subdistrict A1': ['Village A1', 'Village A2', 'Village A3'],
    'Subdistrict A2': ['Village A4', 'Village A5'],
    'Subdistrict A3': ['Village A6', 'Village A7', 'Village A8'],
    'Subdistrict B1': ['Village B1', 'Village B2'],
    'Subdistrict B2': ['Village B3', 'Village B4'],
    'Subdistrict C1': ['Village C1', 'Village C2'],
    'Subdistrict C2': ['Village C3', 'Village C4', 'Village C5'],
    'Subdistrict C3': ['Village C6', 'Village C7']
  };


  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      selectedDistrict = widget.address!.countyDistrict;
      selectedSubDistrict = widget.address!.subDistrict;
      selectedVillage = widget.address!.cityVillage;
    }
  }

  @override
  Widget build(BuildContext context) {
      debugPrint('Address.build(). Widget District = ${widget.address?.countyDistrict}. Local district = $selectedDistrict formkey = ${widget.formKey}');
      return Form(
        key: widget.formKey ?? _addressFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lblSelectAddress),
            DropDownSearchFormField<String>(
              label: lblDistrict,
              initialValue: selectedDistrict,
              items: districts,
              onChanged: onDistrictSelected,
              onSaved: (value) {
                selectedDistrict = value;
                _updateAddress();
              },
              validator: (value) {
                return value == null ? msgPleaseSelectValue : null;
              },
            ),
            SizedBox(height: 5.0),
            DropDownSearchFormField<String>(
              label: lblSubDistrict,
              initialValue: selectedSubDistrict,
              items: selectedDistrict != null ? subDistricts[selectedDistrict] ?? [] : [],
              onChanged: onSubDistrictSelected,
              onSaved: (value) {
                selectedSubDistrict = value;
                _updateAddress();
              },
              validator: (value) {
                return value == null ? msgPleaseSelectValue : null;
              },
            ),
            SizedBox(height: 5.0),
            DropDownSearchFormField<String>(
              label: lblVillage,
              initialValue: selectedVillage,
              items: selectedSubDistrict != null ? villages[selectedSubDistrict] ?? [] : [],
              onChanged: onVillageSelected,
              onSaved: (value) {
                selectedVillage = value;
                _updateAddress();
              },
              validator: (value) {
                return value == null ? msgPleaseSelectValue : null;
              },
            ),
            SizedBox(height: 5.0),
            SizedBox(height: 5.0),
            const SizedBox(height: 12.0,),
          ],
        ),
      );
  }

  void onDistrictSelected(String? district) {
    debugPrint('updating district: $district');
    setState(() {
      selectedDistrict = district;
      selectedSubDistrict = null;
      selectedVillage = null;
    });
  }

  void _updateAddress() {
    if (widget.controller != null) {
       ProfileAddress? address = widget.controller?.getData();
       if (address != null) {
         address.countyDistrict = selectedDistrict;
         address.subDistrict = selectedSubDistrict;
         address.cityVillage = selectedVillage;
       } else {
         widget.controller?.setData(ProfileAddress(cityVillage: selectedVillage, countyDistrict: selectedDistrict, subDistrict: selectedSubDistrict));
       }
    }
  }

  void onSubDistrictSelected(String? subDistrict) {
    setState(() {
      selectedSubDistrict = subDistrict;
      selectedVillage = null;
    });
  }


  void onVillageSelected(String? village) {
    setState(() {
      selectedVillage = village;
    });
  }

}
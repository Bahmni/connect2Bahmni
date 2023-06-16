import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/models/profile_model.dart';
import 'form_fields.dart';

class AddressScreen extends StatefulWidget {
  final ProfileAddress? address;
  const AddressScreen({Key? key, this.address}) : super(key: key);
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _addressFormKey = GlobalKey<FormState>();

  static const lblSelectAddress = 'Select Address';
  static const lblSubDistrict = "Sub District";
  static const lblDistrict = "District";
  static const lblVillage = "Village";
  static const lblPrevious = "Previous";
  static const lblNext = "Next";
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
      return Form(
        key: _addressFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lblSelectAddress),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(showSelectedItems: true, showSearchBox: true,),
              filterFn: (item, filter) => item.toLowerCase().contains(filter.toLowerCase()),
              items: districts,
              dropdownDecoratorProps: DropDownDecoratorProps(dropdownSearchDecoration: InputDecoration(hintText: lblDistrict)),
              onChanged: onDistrictSelected,
              selectedItem: selectedDistrict,
            ),
            SizedBox(height: 5.0),
            DropDownSearchFormField<String>(
              items: selectedDistrict != null ? subDistricts[selectedDistrict] ?? [] : [],
              label: lblSubDistrict,
              initialValue: selectedSubDistrict,
              onChanged: onSubDistrictSelected,
              onSaved: (value) {
                selectedSubDistrict = value;
              },
              validator: (value) {
                return value == null ? msgPleaseSelectValue : null;
              },
            ),
            SizedBox(height: 5.0),
            DropDownSearchFormField<String>(
              items: selectedSubDistrict != null ? villages[selectedSubDistrict] ?? [] : [],
              label: lblVillage,
              initialValue: selectedVillage,
              onChanged: onVillageSelected,
              onSaved: (value) {
                selectedVillage = value;
              },
              validator: (value) {
                return value == null ? msgPleaseSelectValue : null;
              },
            ),
            // if (selectedSubDistrict != null)
            //   DropdownSearch<String>(
            //     popupProps: PopupProps.menu(showSelectedItems: true, showSearchBox: true,),
            //     filterFn: (item, filter) => item.toLowerCase().contains(filter.toLowerCase()),
            //     items: villages[selectedSubDistrict]!,
            //     dropdownDecoratorProps: DropDownDecoratorProps(dropdownSearchDecoration: InputDecoration(hintText: lblVillage,),),
            //     onChanged: onVillageSelected,
            //     selectedItem: selectedVillage,
            //   ),
            SizedBox(height: 5.0),
            SizedBox(height: 5.0),
            const SizedBox(height: 12.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    if (updateAddress()) {
                      moveToPreviousSection();
                    }
                  },
                  child: const Text(lblPrevious),
                ),
                OutlinedButton(
                  onPressed: () {
                    if (updateAddress()) {
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
    model?.previousSection();
  }

  bool updateAddress() {
    var validated = _addressFormKey.currentState!.validate();
    if (!validated) return false;
    if (validated) {
      _addressFormKey.currentState!.save();
    }
    if (selectedDistrict != null && selectedSubDistrict != null && selectedVillage != null) {
      var model = Provider.of<ProfileModel?>(context, listen: false);
      model?.updateProfileAddress(
          ProfileAddress(cityVillage: selectedVillage,
            countyDistrict: selectedDistrict,
            subDistrict: selectedSubDistrict));
    }
    return true;
  }

  // List<String> getDistricts() {
  //   return districts;
  // }

  void onDistrictSelected(String? district) {
    setState(() {
      selectedDistrict = district;
      selectedSubDistrict = null;
      selectedVillage = null;
    });
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

  void moveToNextSection() {
    Provider.of<ProfileModel?>(context, listen: false)?.nextSection();
  }
}
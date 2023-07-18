import 'dart:convert';

import 'package:connect2bahmni/domain/models/address_entry.dart';
import 'package:flutter/material.dart';

class AddressHierarchy {

  Future<List<AddressEntry>> loadAddressHierarchy(BuildContext context) async {
    return DefaultAssetBundle.of(context).loadString("assets/addressHierarchy.json")
        .then((json) {
      var entries = jsonDecode(json) ?? [];
      return List<AddressEntry>.from(entries.map((model) {
        return AddressEntry.fromJson(model);
      }));
    });
  }

}
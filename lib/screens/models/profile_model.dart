import 'package:connect2bahmni/domain/models/omrs_identifier_type.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../domain/models/omrs_person_attribute.dart';

class ProfileModel extends ChangeNotifier {
  String? uuid;
  ProfileBasics? basicDetails;
  List<ProfileIdentifier>? identifiers;
  ProfileAddress? address;
  String? phoneNumber;
  List<ProfileAttribute>? attributes;
  OmrsIdentifierType? primaryPatientIdentifierType;

  ProfileModel({
    this.uuid,
    this.basicDetails,
    this.identifiers,
    this.address,
    this.phoneNumber,
    this.attributes,
    this.primaryPatientIdentifierType,
  });

  bool get isNewPatient => uuid == null;

  updateBasicDetails(ProfileBasics basics) {
    debugPrint('Updating profile basics - ${basics.firstName} ${basics.lastName}');
    basicDetails = ProfileBasics(
      firstName: basics.firstName,
      lastName: basics.lastName,
      gender: basics.gender,
      dateOfBirth: basics.dateOfBirth,
    );
  }

  void updateProfileAddress(ProfileAddress profileAddress) {
    address = ProfileAddress(
      cityVillage: profileAddress.cityVillage,
      subDistrict: profileAddress.subDistrict,
      countyDistrict: profileAddress.countyDistrict,
      stateProvince: profileAddress.stateProvince,
    );
  }

  void updateIdentifiers(List<ProfileIdentifier> identifiers) {
    if (this.identifiers == null) {
      this.identifiers = [];
    }
    for (var id in identifiers) {
      var iterable = this.identifiers?.where((element) {
        return element.typeUuid == id.typeUuid;
      });
      if (iterable !=null && iterable.isNotEmpty) {
        var existing = iterable.first;
        existing.value = id.value;
      } else {
        this.identifiers?.add(id);
      }
    }
  }

  void updatePhone(String? phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  void updateAttributes(List<ProfileAttribute> attributes) {
      if (this.attributes == null) {
        this.attributes = [];
      }
      for (var attr in attributes) {
        var iterable = this.attributes?.where((element) {
          return element.typeUuid == attr.typeUuid;
        });
        if (iterable !=null && iterable.isNotEmpty) {
          var existing = iterable.first;
          existing.value = attr.value;
        } else {
          this.attributes?.add(attr);
        }
      }
  }

  Map<String, Object?> toProfileJson() {
    return {
      "patient": {
        if (uuid != null)
          "uuid": uuid,
        "identifiers": _identifiersJson(),
        "person" : {
          "gender": toGenderPrefix(basicDetails!.gender!),
          "birthdate": DateFormat("yyyy-MM-dd").format(basicDetails!.dateOfBirth!),
          "names": _profileNamesJson(),
          "addresses": _profileAddressesJson(),
          if (attributes != null && attributes!.isNotEmpty)
            "attributes": _profileAttributesJson(),
        },
      },
      "relationships" : [],
    };
  }

  List<dynamic> _identifiersJson() {
    if (primaryPatientIdentifierType == null) {
      throw 'Can not identify primary identifier type';
    }
    List<dynamic> identifiersJson = [];
    var iterator = identifiers?.where((element) => element.typeUuid == primaryPatientIdentifierType!.uuid);
    ProfileIdentifier? primaryId = iterator != null && iterator.isNotEmpty ? iterator.first : null;
    if (primaryId == null) {
      identifiersJson.add({
        "identifierType": primaryPatientIdentifierType!.uuid,
        "identifierSourceUuid": primaryPatientIdentifierType!.identifierSources!.first.uuid,
        "identifierPrefix": primaryPatientIdentifierType!.identifierSources!.first.prefix,
      });
    }
    identifiers?.forEach((identifier) {
      identifiersJson.add({
        "identifierType": identifier.typeUuid,
        "identifier": identifier.value,
      });
    });
    return identifiersJson;
  }

  List<Map<String, Object?>>? _profileAttributesJson() {
    return attributes?.map((attr) {
      return {
        "attributeType": {
          "uuid" : attr.typeUuid,
        },
        "value": attr.value
      };
    }).toList();
  }

  List<Map<String, Object?>> _profileNamesJson() {
    return [
      {
        "givenName": basicDetails!.firstName,
        "familyName": basicDetails!.lastName,
        "preferred": true,
      }
    ];
  }

  List<Map<String, String?>> _profileAddressesJson() {
    return [
      {
        if (address?.cityVillage != null)
          "cityVillage": address?.cityVillage,
        if (address?.subDistrict != null)
          "address4": address?.subDistrict,
        if (address?.countyDistrict != null)
          "countyDistrict": address?.countyDistrict,
        if (address?.stateProvince != null)
          "stateProvince": address?.stateProvince,
      }
    ];
  }

  factory ProfileModel.fromProfileJson(Map<String, dynamic> json) {
    var patientJson = json['patient'];
    var profile = ProfileModel();
    profile.uuid = patientJson["uuid"];
    var personJson = patientJson["person"];
    profile.basicDetails = ProfileBasics(
        firstName : personJson["names"][0]["givenName"],
        lastName : personJson["names"][0]["familyName"],
        gender: fromGenderPrefix(personJson["gender"]),
        dateOfBirth: DateTime.parse(personJson["birthdate"])
    );
    profile.identifiers = patientJson["identifiers"].map<ProfileIdentifier>((identifier) {
      return ProfileIdentifier(
        uuid: identifier["uuid"],
        value: identifier["identifier"],
        name: identifier["identifierType"]["display"],
        preferred: identifier["preferred"],
        typeUuid: identifier["identifierType"]["uuid"],
      );
    }).toList();
    if (personJson["attributes"] != null) {
      profile.attributes = personJson["attributes"].map<ProfileAttribute>((attribute) {
        return ProfileAttribute(
          uuid: attribute["uuid"],
          value: attribute["value"],
          typeUuid: attribute["attributeType"]["uuid"],
          name: attribute["attributeType"]["display"],
        );
      }).toList();
    }
    if (personJson["preferredAddress"] != null) {
      profile.address = ProfileAddress(
          cityVillage: personJson["preferredAddress"]["cityVillage"],
          subDistrict: personJson["preferredAddress"]["address4"],
          countyDistrict: personJson["preferredAddress"]["countyDistrict"],
          stateProvince: personJson["preferredAddress"]["stateProvince"],
        );
    }
    return profile;
  }

  void updateFrom(ProfileModel serverResponse) {
    uuid = serverResponse.uuid;
    identifiers = serverResponse.identifiers;
    attributes = serverResponse.attributes;
  }

  bool validate() {
    if (basicDetails == null) {
      return false;
    }
    //TODO drive through config
    if (address == null) {
      return false;
    }

    if (uuid != null) {
      if (identifiers == null || identifiers!.isEmpty) {
        return false;
      }
    }
    debugPrint('validated model');
    return true;
  }

}

enum Gender {
  male,
  female,
  other,
  unknown,
}

class ProfileIdentifier {
  String name;
  String value;
  String? uuid;
  String? typeUuid;
  bool? preferred;

  ProfileIdentifier({this.uuid, required this.name, required this.value, this.typeUuid, this.preferred});
}

class ProfileBasics {
  String? firstName;
  String? lastName;
  Gender? gender;
  DateTime? dateOfBirth;
  List<ProfileIdentifier>? identifiers;
  List<ProfileAttribute>? attributes;

  ProfileBasics({this.firstName, this.lastName, this.gender, this.dateOfBirth, this.identifiers, this.attributes});
}

class ProfileAddress {
  String? stateProvince;
  String? countyDistrict;
  String? subDistrict;
  String? cityVillage;

  ProfileAddress({
    this.stateProvince,
    this.countyDistrict,
    this.subDistrict,
    this.cityVillage,
  });
}

class ProfileAttribute {
  String? uuid;
  String? name;
  String? value;
  String? typeUuid;
  String? description;

  ProfileAttribute({
    this.uuid,
    this.value,
    this.typeUuid,
    this.name,
    this.description,
  });

  factory ProfileAttribute.fromPersonAttribute(OmrsPersonAttribute attribute) {
    return ProfileAttribute(
      uuid: attribute.uuid,
      value: attribute.value,
      typeUuid: attribute.attributeType?.uuid,
      name: attribute.attributeType?.name,
      description: attribute.attributeType?.description,
    );
  }
}

class ProfileAttributeType {
  String? uuid;
  String? name;
  String? description;
  Type? dataType;
  bool? mandatory;

  ProfileAttributeType({
    this.uuid,
    this.name,
    this.description,
    this.dataType,
    this.mandatory,
  });

  factory ProfileAttributeType.fromPersonAttributeType(OmrsPersonAttributeType attributeType) {
    return ProfileAttributeType(
      uuid: attributeType.uuid,
      name: attributeType.name,
      description: attributeType.description,
      dataType: OmrsPersonAttributeType.dataType(attributeType.format)
    );
  }
}


Gender? toGenderType(String? gender) {
  var where = Gender.values.where((element) => element.name == gender!.toLowerCase());
  return where.isEmpty ? null : where.first;
}

String toGenderPrefix(Gender gender) {
  return gender.name.substring(0,1).toUpperCase();
}

Gender? fromGenderPrefix(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  var genderPrefix = value.substring(0,1).toUpperCase();
  switch (genderPrefix) {
    case 'M':
      return Gender.male;
    case 'F':
      return Gender.female;
    case 'O':
      return Gender.other;
    default:
      return Gender.unknown;
  }
}


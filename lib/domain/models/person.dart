import 'package:fhir/r4.dart';
import 'package:json_annotation/json_annotation.dart';
part 'person.g.dart';

@JsonSerializable()
class Person {
  final String uuid;
  final String display;
  final String? gender;
  final DateTime? birthdate;
  final PersonName? preferredName;
  final PersonAddress? preferredAddress;

  Person({required this.uuid, required this.display, this.gender, this.birthdate, this.preferredName, this.preferredAddress});
  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);

  HumanName get humanName {
    if (preferredName == null) {
      return HumanName(
        text: display
      );
    }
    return preferredName!.humanName;
  }

  Address? get address {
    return preferredAddress?.address;
  }
}

@JsonSerializable()
class PersonName {
  final String? display;
  final String? uuid;
  final String? givenName;
  final String? middleName;
  final String? familyName;

  PersonName({this.display, this.uuid, this.givenName, this.middleName, this.familyName});
  factory PersonName.fromJson(Map<String, dynamic> json) => _$PersonNameFromJson(json);
  Map<String, dynamic> toJson() => _$PersonNameToJson(this);

  HumanName get humanName {
    List<String> givenNames = [];
    if (givenName != null ) {
      givenNames.add(givenName!);
    }
    if (middleName != null ) {
      givenNames.add(middleName!);
    }

    return HumanName(
          id: uuid,
          given: givenNames.isNotEmpty ? givenNames : null,
          text: display,
          family: familyName
      );
  }
}
@JsonSerializable()
class PersonAddress {
   final String? uuid;
   final String? cityVillage;
   final String? stateProvince;
   final String? country;
   final String? postalCode;
   final String? countyDistrict;

   PersonAddress({this.uuid, this.cityVillage, this.stateProvince, this.country,
      this.postalCode, this.countyDistrict});
   factory PersonAddress.fromJson(Map<String, dynamic> json) => _$PersonAddressFromJson(json);
   Map<String, dynamic> toJson() => _$PersonAddressToJson(this);

   Address get address {
    return Address(
      id: uuid,
      city:  cityVillage,
      country: country,
      state: stateProvince,
      postalCode: postalCode,
      district: countyDistrict
    );
  }
}
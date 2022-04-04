// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
      uuid: json['uuid'] as String,
      display: json['display'] as String,
      gender: json['gender'] as String?,
      birthdate: json['birthdate'] == null
          ? null
          : DateTime.parse(json['birthdate'] as String),
      preferredName: json['preferredName'] == null
          ? null
          : PersonName.fromJson(json['preferredName'] as Map<String, dynamic>),
      preferredAddress: json['preferredAddress'] == null
          ? null
          : PersonAddress.fromJson(
              json['preferredAddress'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'display': instance.display,
      'gender': instance.gender,
      'birthdate': instance.birthdate?.toIso8601String(),
      'preferredName': instance.preferredName,
      'preferredAddress': instance.preferredAddress,
    };

PersonName _$PersonNameFromJson(Map<String, dynamic> json) => PersonName(
      display: json['display'] as String?,
      uuid: json['uuid'] as String?,
      givenName: json['givenName'] as String?,
      middleName: json['middleName'] as String?,
      familyName: json['familyName'] as String?,
    );

Map<String, dynamic> _$PersonNameToJson(PersonName instance) =>
    <String, dynamic>{
      'display': instance.display,
      'uuid': instance.uuid,
      'givenName': instance.givenName,
      'middleName': instance.middleName,
      'familyName': instance.familyName,
    };

PersonAddress _$PersonAddressFromJson(Map<String, dynamic> json) =>
    PersonAddress(
      uuid: json['uuid'] as String?,
      cityVillage: json['cityVillage'] as String?,
      stateProvince: json['stateProvince'] as String?,
      country: json['country'] as String?,
      postalCode: json['postalCode'] as String?,
      countyDistrict: json['countyDistrict'] as String?,
    );

Map<String, dynamic> _$PersonAddressToJson(PersonAddress instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'cityVillage': instance.cityVillage,
      'stateProvince': instance.stateProvince,
      'country': instance.country,
      'postalCode': instance.postalCode,
      'countyDistrict': instance.countyDistrict,
    };

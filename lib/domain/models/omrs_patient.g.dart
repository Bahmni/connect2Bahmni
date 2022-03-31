// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'omrs_patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OmrsPatient _$OmrsPatientFromJson(Map<String, dynamic> json) => OmrsPatient(
      uuid: json['uuid'] as String?,
      display: json['display'] as String?,
      identifiers: (json['identifiers'] as List<dynamic>?)
          ?.map((e) => OmrsIdentifier.fromJson(e as Map<String, dynamic>))
          .toList(),
      person: json['person'] == null
          ? null
          : Person.fromJson(json['person'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OmrsPatientToJson(OmrsPatient instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'display': instance.display,
      'identifiers': instance.identifiers,
      'person': instance.person,
    };

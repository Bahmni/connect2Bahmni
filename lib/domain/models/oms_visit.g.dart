// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oms_visit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OmrsVisit _$OmrsVisitFromJson(Map<String, dynamic> json) => OmrsVisit(
      uuid: json['uuid'] as String?,
      display: json['display'] as String?,
      visitType: json['visitType'] == null
          ? null
          : OmrsVisitType.fromJson(json['visitType'] as Map<String, dynamic>),
      location: json['location'] == null
          ? null
          : OmrsLocation.fromJson(json['location'] as Map<String, dynamic>),
      patient: json['patient'] == null
          ? null
          : OmrsPatient.fromJson(json['patient'] as Map<String, dynamic>),
      startDatetime: json['startDatetime'] == null
          ? null
          : DateTime.parse(json['startDatetime'] as String),
      stopDatetime: json['stopDatetime'] == null
          ? null
          : DateTime.parse(json['stopDatetime'] as String),
      voided: json['voided'] as bool?,
      attributes: (json['attributes'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      encounters: (json['encounters'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$OmrsVisitToJson(OmrsVisit instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'display': instance.display,
      'visitType': instance.visitType,
      'location': instance.location,
      'patient': instance.patient,
      'startDatetime': instance.startDatetime?.toIso8601String(),
      'stopDatetime': instance.stopDatetime?.toIso8601String(),
      'voided': instance.voided,
      'attributes': instance.attributes,
      'encounters': instance.encounters,
    };

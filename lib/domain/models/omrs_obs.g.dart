// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'omrs_obs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OmrsObs _$OmrsObsFromJson(Map<String, dynamic> json) => OmrsObs(
      uuid: json['uuid'] as String?,
      display: json['display'] as String?,
      concept: OmrsConcept.fromJson(json['concept'] as Map<String, dynamic>),
      obsDatetime: json['obsDatetime'] == null
          ? null
          : DateTime.parse(json['obsDatetime'] as String),
      comment: json['comment'] as String?,
      encounter: json['encounter'] == null
          ? null
          : OmrsEncounter.fromJson(json['encounter'] as Map<String, dynamic>),
      value: json['value'],
      groupMembers: (json['groupMembers'] as List<dynamic>?)
          ?.map((e) => OmrsObs.fromJson(e as Map<String, dynamic>))
          .toList(),
      formFieldPath: json['formFieldPath'] as String?,
    );

Map<String, dynamic> _$OmrsObsToJson(OmrsObs instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'display': instance.display,
      'concept': instance.concept,
      'obsDatetime': instance.obsDatetime?.toIso8601String(),
      'comment': instance.comment,
      'encounter': instance.encounter,
      'value': instance.value,
      'groupMembers': instance.groupMembers,
      'formFieldPath': instance.formFieldPath,
    };

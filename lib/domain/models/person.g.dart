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
    );

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'display': instance.display,
      'gender': instance.gender,
      'birthdate': instance.birthdate?.toIso8601String(),
    };

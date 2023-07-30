// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'omrs_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OmrsProvider _$OmrsProviderFromJson(Map<String, dynamic> json) => OmrsProvider(
      uuid: json['uuid'] as String,
      identifier: json['identifier'] as String?,
      display: json['display'] as String?,
      name: json['name'] as String?,
      attributes: (json['attributes'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$OmrsProviderToJson(OmrsProvider instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'identifier': instance.identifier,
      'display': instance.display,
      'name': instance.name,
      'attributes': instance.attributes,
    };

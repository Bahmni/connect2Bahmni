// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormDefinition _$FormDefinitionFromJson(Map<String, dynamic> json) =>
    FormDefinition(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      controls: (json['controls'] as List<dynamic>?)
          ?.map((e) => ControlDefinition.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FormDefinitionToJson(FormDefinition instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'controls': instance.controls,
    };

ControlDefinition _$ControlDefinitionFromJson(Map<String, dynamic> json) =>
    ControlDefinition(
      id: json['id'] as String,
      type: json['type'] as String,
      translationKey: json['translationKey'] as String?,
      value: json['value'],
      properties: json['properties'] as Map<String, dynamic>?,
      label: json['label'] == null
          ? null
          : ControlDefinition.fromJson(json['label'] as Map<String, dynamic>),
      controls: (json['controls'] as List<dynamic>?)
          ?.map((e) => ControlDefinition.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ControlDefinitionToJson(ControlDefinition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'translationKey': instance.translationKey,
      'value': instance.value,
      'properties': instance.properties,
      'label': instance.label,
      'controls': instance.controls,
    };

ConceptDefinition _$ConceptDefinitionFromJson(Map<String, dynamic> json) =>
    ConceptDefinition(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      datatype: json['datatype'] as String?,
      conceptClass: json['conceptClass'] as String?,
      description: json['description'] as String?,
      setMembers: (json['setMembers'] as List<dynamic>?)
          ?.map((e) => ConceptDefinition.fromJson(e as Map<String, dynamic>))
          .toList(),
      conceptHandler: json['conceptHandler'] as String?,
      answers: (json['answers'] as List<dynamic>?)
          ?.map((e) =>
              ConceptAnswerDefinition.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConceptDefinitionToJson(ConceptDefinition instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'datatype': instance.datatype,
      'conceptClass': instance.conceptClass,
      'description': instance.description,
      'setMembers': instance.setMembers,
      'answers': instance.answers,
      'conceptHandler': instance.conceptHandler,
    };

ConceptAnswerDefinition _$ConceptAnswerDefinitionFromJson(
        Map<String, dynamic> json) =>
    ConceptAnswerDefinition(
      displayString: json['displayString'] as String?,
      uuid: json['uuid'] as String,
      translationKey: json['translationKey'] as String?,
    );

Map<String, dynamic> _$ConceptAnswerDefinitionToJson(
        ConceptAnswerDefinition instance) =>
    <String, dynamic>{
      'displayString': instance.displayString,
      'uuid': instance.uuid,
      'translationKey': instance.translationKey,
    };

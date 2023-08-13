// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormResource _$FormResourceFromJson(Map<String, dynamic> json) => FormResource(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      version: json['version'] as String,
      resources: (json['resources'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      privileges: (json['privileges'] as List<dynamic>?)
          ?.map((e) => FormPrivilege.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FormResourceToJson(FormResource instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'version': instance.version,
      'resources': instance.resources,
      'privileges': instance.privileges,
    };

FormDefinition _$FormDefinitionFromJson(Map<String, dynamic> json) =>
    FormDefinition(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      referenceVersion: json['referenceVersion'] as String?,
      controls: (json['controls'] as List<dynamic>?)
          ?.map((e) => ControlDefinition.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FormDefinitionToJson(FormDefinition instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'referenceVersion': instance.referenceVersion,
      'controls': instance.controls,
    };

ControlDefinition _$ControlDefinitionFromJson(Map<String, dynamic> json) =>
    ControlDefinition(
      id: json['id'] as String,
      type: json['type'] as String,
      translationKey: json['translationKey'] as String?,
      value: json['value'],
      properties: json['properties'] == null
          ? null
          : ControlProperties.fromJson(
              json['properties'] as Map<String, dynamic>),
      label: json['label'] == null
          ? null
          : ControlDefinition.fromJson(json['label'] as Map<String, dynamic>),
      controls: (json['controls'] as List<dynamic>?)
          ?.map((e) => ControlDefinition.fromJson(e as Map<String, dynamic>))
          .toList(),
      concept: json['concept'] == null
          ? null
          : ConceptDefinition.fromJson(json['concept'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ControlDefinitionToJson(ControlDefinition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'translationKey': instance.translationKey,
      'value': instance.value,
      'properties': instance.properties,
      'label': instance.label,
      'concept': instance.concept,
      'controls': instance.controls,
    };

ConceptDefinition _$ConceptDefinitionFromJson(Map<String, dynamic> json) =>
    ConceptDefinition(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      datatype: json['datatype'] as String?,
      conceptClass: json['conceptClass'] as String?,
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
      'setMembers': instance.setMembers,
      'answers': instance.answers,
      'conceptHandler': instance.conceptHandler,
    };

ControlPosition _$ControlPositionFromJson(Map<String, dynamic> json) =>
    ControlPosition(
      row: json['row'] as int,
      column: json['column'] as int,
    );

Map<String, dynamic> _$ControlPositionToJson(ControlPosition instance) =>
    <String, dynamic>{
      'row': instance.row,
      'column': instance.column,
    };

ControlProperties _$ControlPropertiesFromJson(Map<String, dynamic> json) =>
    ControlProperties(
      location: json['location'] == null
          ? null
          : ControlPosition.fromJson(json['location'] as Map<String, dynamic>),
      mandatory: json['mandatory'] as bool?,
      notes: json['notes'] as bool?,
      addMore: json['addMore'] as bool?,
      dropDown: json['dropDown'] as bool?,
      multiSelect: json['multiSelect'] as bool?,
      autoComplete: json['autoComplete'] as bool?,
      hideLabel: json['hideLabel'] as bool?,
    );

Map<String, dynamic> _$ControlPropertiesToJson(ControlProperties instance) =>
    <String, dynamic>{
      'location': instance.location,
      'mandatory': instance.mandatory,
      'notes': instance.notes,
      'addMore': instance.addMore,
      'dropDown': instance.dropDown,
      'multiSelect': instance.multiSelect,
      'autoComplete': instance.autoComplete,
      'hideLabel': instance.hideLabel,
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

FormPrivilege _$FormPrivilegeFromJson(Map<String, dynamic> json) =>
    FormPrivilege(
      privilegeName: json['privilegeName'] as String,
      editable: json['editable'] as bool?,
      viewable: json['viewable'] as bool?,
    );

Map<String, dynamic> _$FormPrivilegeToJson(FormPrivilege instance) =>
    <String, dynamic>{
      'privilegeName': instance.privilegeName,
      'editable': instance.editable,
      'viewable': instance.viewable,
    };

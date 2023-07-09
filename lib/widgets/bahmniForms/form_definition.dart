import 'package:json_annotation/json_annotation.dart';

part 'form_definition.g.dart';

@JsonSerializable()
class FormDefinition {
  final String uuid;
  final String name;
  final List<ControlDefinition>? controls;
  const FormDefinition({required this.uuid, required this.name, this.controls});

  factory FormDefinition.fromJson(Map<String, dynamic> json) => _$FormDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$FormDefinitionToJson(this);
}

@JsonSerializable()
class ControlDefinition {
  final String id;
  final String type;
  final String? translationKey;
  final dynamic value;
  final Map<String, dynamic>? properties;
  final ControlDefinition? label;
  final List<ControlDefinition>? controls;

  ControlDefinition({required this.id, required this.type, this.translationKey, this.value, this.properties, this.label, this.controls});
  factory ControlDefinition.fromJson(Map<String, dynamic> json) => _$ControlDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$ControlDefinitionToJson(this);
}

@JsonSerializable()
class ConceptDefinition {
  final String uuid;
  final String name;
  final String? datatype;
  final String? conceptClass;
  final String? description;
  final List<ConceptDefinition>? setMembers;
  final List<ConceptAnswerDefinition>? answers;
  final String? conceptHandler;

  const ConceptDefinition(
      {required this.uuid, required this.name, this.datatype, this.conceptClass, this.description, this.setMembers, this.conceptHandler, this.answers});
  factory ConceptDefinition.fromJson(Map<String, dynamic> json) => _$ConceptDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$ConceptDefinitionToJson(this);
}

@JsonSerializable()
class ConceptAnswerDefinition {
  final String? displayString;
  final String uuid;
  final String? translationKey;

  const ConceptAnswerDefinition({this.displayString, required this.uuid, this.translationKey});
  factory ConceptAnswerDefinition.fromJson(Map<String, dynamic> json) => _$ConceptAnswerDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$ConceptAnswerDefinitionToJson(this);
}
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import '../../domain/models/omrs_concept.dart';
part 'form_definition.g.dart';


@JsonSerializable()
class FormResource {
  final String uuid;
  final String name;
  final String version;
  final List<Map<String, dynamic>>? resources;
  final List<FormPrivilege>? privileges;
  FormDefinition? _definition;
  FormResource({
    required this.uuid,
    required this.name,
    required this.version,
    this.resources,
    this.privileges,
  });

  FormDefinition? get definition {
    if (_definition != null) {
      return _definition;
    }
    var raw = resources?[0]['value']?.toString();
    if (raw == null) {
      return null;
    }
    _definition = FormDefinition.fromJson(jsonDecode(raw));
    return _definition;
  }

  factory FormResource.fromJson(Map<String, dynamic> json) => _$FormResourceFromJson(json);
  Map<String, dynamic> toJson() => _$FormResourceToJson(this);
}

@JsonSerializable()
class FormDefinition {
  final String uuid;
  final String name;
  final String? referenceVersion;
  final List<ControlDefinition>? controls;
  const FormDefinition({required this.uuid, required this.name, this.referenceVersion, this.controls});

  factory FormDefinition.fromJson(Map<String, dynamic> json) => _$FormDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$FormDefinitionToJson(this);
}

@JsonSerializable()
class ControlDefinition {
  final String id;
  final String type;
  final String? translationKey;
  final dynamic value;
  final ControlProperties? properties;
  final ControlDefinition? label;
  final ConceptDefinition? concept;
  final List<ControlDefinition>? controls;

  ConceptDataType? get dataType {
    var conceptDataType = concept?.datatype;
    if (conceptDataType == null) {
      return null;
    }
    if (conceptDataType.toLowerCase() == 'n/a') {
      return ConceptDataType.na;
    }

    if (ConceptDataType.values.asNameMap().containsKey(conceptDataType.toLowerCase())) {
      return ConceptDataType.values.asNameMap()[conceptDataType.toLowerCase()];
    }
    return null;
  }

  bool get isComposite {
    return controls != null && controls!.isNotEmpty;
  }


  ControlPosition? get position {
    if (properties == null) {
      return null;
    }
    return properties!.location;
  }

  ControlDefinition({required this.id, required this.type, this.translationKey, this.value, this.properties, this.label, this.controls, this.concept});
  factory ControlDefinition.fromJson(Map<String, dynamic> json) => _$ControlDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$ControlDefinitionToJson(this);
}

@JsonSerializable()
class ConceptDefinition {
  final String uuid;
  final String name;
  final String? datatype;
  final String? conceptClass;
  final List<ConceptDefinition>? setMembers;
  final List<ConceptAnswerDefinition>? answers;
  final String? conceptHandler;

  const ConceptDefinition(
      {required this.uuid, required this.name, this.datatype, this.conceptClass, this.setMembers, this.conceptHandler, this.answers});
  factory ConceptDefinition.fromJson(Map<String, dynamic> json) => _$ConceptDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$ConceptDefinitionToJson(this);
}

@JsonSerializable()
class ControlPosition {
  final int row;
  final int column;
  ControlPosition({required this.row, required this.column});
  factory ControlPosition.fromJson(Map<String, dynamic> json) => _$ControlPositionFromJson(json);
  Map<String, dynamic> toJson() => _$ControlPositionToJson(this);
}

@JsonSerializable()
class ControlProperties {
  ControlPosition? location;
  bool? mandatory;
  bool? notes;
  bool? addMore;
  bool? dropDown;
  bool? multiSelect;
  bool? autoComplete;
  bool? hideLabel;

  ControlProperties({this.location, this.mandatory, this.notes, this.addMore, this.dropDown, this.multiSelect, this.autoComplete, this.hideLabel});
  factory ControlProperties.fromJson(Map<String, dynamic> json) => _$ControlPropertiesFromJson(json);
  Map<String, dynamic> toJson() => _$ControlPropertiesToJson(this);
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

@JsonSerializable()
class FormPrivilege {
  final String privilegeName;
  final bool? editable;
  final bool? viewable;

  FormPrivilege({required this.privilegeName, this.editable, this.viewable});
  factory FormPrivilege.fromJson(Map<String, dynamic> json) => _$FormPrivilegeFromJson(json);
  Map<String, dynamic> toJson() => _$FormPrivilegeToJson(this);
}
import 'omrs_concept_description.dart';

class OmrsConcept {
  String? uuid;
  String? display;
  List<OmrsConceptDescription>? descriptions;
  List<OmrsConcept>? answers;
  List<OmrsConcept>? setMembers;
  List<Map<String, dynamic>>? attributes;
  OmrsConceptName? name;
  List<OmrsConceptName>? names;
  OmrsConceptClass? conceptClass;
  OmrsConceptDataType? datatype;


  OmrsConcept({
      this.uuid,
      this.display,
      this.descriptions,
      this.answers,
      this.setMembers,
      this.attributes,
      this.name,
      this.names,
      this.conceptClass,
      this.datatype});

  String? get coding {
    //TODO
    return null;
  }

  String? get description {
    if ((descriptions != null) && descriptions!.isNotEmpty) {
      return descriptions?.first.display;
    }
    return null;
  }

  OmrsConcept.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'] ?? json['conceptUuid'],
        display = json['display'] ?? json['conceptName'],
        descriptions = (json['descriptions'] as List<dynamic>?)?.map((e) => OmrsConceptDescription.fromJson(e as Map<String, dynamic>)).toList(),
        answers = (json['answers'] as List<dynamic>?)?.map((e) => OmrsConcept.fromJson(e as Map<String, dynamic>)).toList(),
        setMembers = (json['setMembers'] as List<dynamic>?)?.map((e) => OmrsConcept.fromJson(e as Map<String, dynamic>)).toList(),
        attributes = (json['attributes'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList(),
        name = json['name'] == null ? null : OmrsConceptName.fromJson(json['name'] as Map<String, dynamic>),
        names = (json['names'] as List<dynamic>?)?.map((e) => OmrsConceptName.fromJson(e as Map<String, dynamic>)).toList(),
        conceptClass = json['conceptClass'] == null ? null : OmrsConceptClass.fromJson(json['conceptClass'] as Map<String, dynamic>),
        datatype = json['datatype'] == null ? null : OmrsConceptDataType.fromJson(json['datatype'] as Map<String, dynamic>);




  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'display': display,
    'descriptions': descriptions
  };
}

class OmrsConceptName {
  String? uuid;
  String? name;
  String? display;
  String? locale;
  bool? localePreferred;
  String? conceptNameType;

  OmrsConceptName({this.uuid, this.name, this.display, this.locale,
      this.localePreferred, this.conceptNameType});

  OmrsConceptName.fromJson(Map<String, dynamic> json)
    : uuid = json['uuid'],
      name = json['name'],
      display = json['display'],
      locale = json['locale'],
      conceptNameType = json['conceptNameType'],
      localePreferred = json['localePreferred'];

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': display
  };
}

class OmrsConceptDataType {
  String? uuid;
  String? name;

  OmrsConceptDataType({this.uuid, this.name});
  OmrsConceptDataType.fromJson(Map<String, dynamic> json): uuid = json['uuid'], name = json['name'];
  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name
  };
}

class OmrsConceptClass {
  String? uuid;
  String? name;

  OmrsConceptClass({this.uuid, this.name});
  OmrsConceptClass.fromJson(Map<String, dynamic> json): uuid = json['uuid'], name = json['name'];
  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name
  };
}

enum ConceptDataType {
  text,
  numeric,
  date,
  datetime,
  boolean,
  complex,
  coded,
  na,
}
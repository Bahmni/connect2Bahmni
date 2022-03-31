import 'omrs_concept_description.dart';

class OmrsConcept {
  String? uuid;
  String? display;
  List<OmrsConceptDescription>? descriptions;

  OmrsConcept({this.uuid, this.display, this.descriptions});
  String? get coding {
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
        descriptions = (json['descriptions'] as List<dynamic>?)?.map((e) => OmrsConceptDescription.fromJson(e as Map<String, dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'display': display,
    'descriptions': descriptions
  };
}


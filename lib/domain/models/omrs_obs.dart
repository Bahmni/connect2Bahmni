
import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/omrs_concept.dart';
import '../../domain/models/oms_visit.dart';
part 'omrs_obs.g.dart';

@JsonSerializable()
class OmrsObs {
  final String? uuid;
  final String? display;
  final OmrsConcept concept;

  final DateTime? obsDatetime;
  final String? comment;
  final OmrsEncounter? encounter;
  final dynamic value;

  OmrsObs({this.uuid, this.display, required this.concept, this.obsDatetime, this.comment,
      this.encounter, this.value});
  factory OmrsObs.fromJson(Map<String, dynamic> json) => _$OmrsObsFromJson(json);
  Map<String, dynamic> toJson() => _$OmrsObsToJson(this);

  String? get valueAsString {
    if (value == null) return null;
    if (value is Map) {
      //coded concept value
      if (value['name'] != null) {
        var name = value['name']['name'] ?? value['name']['display'];
        return name ?? value['display'];
      }
      return value['display'];
    }
    //can be more complicated with concept datatype being complex, Document etc
    return value.toString();
  }
}
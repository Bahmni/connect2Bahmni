
import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/omrs_location.dart';
import '../../domain/models/omrs_patient.dart';
import '../../domain/models/omrs_visit_type.dart';
part 'oms_visit.g.dart';

@JsonSerializable()
class OmrsVisit {
  String? uuid;
  String? display;
  OmrsVisitType? visitType;
  OmrsLocation? location;
  OmrsPatient? patient;
  DateTime? startDatetime;
  DateTime? stopDatetime;
  bool? voided;
  List<Map<String, dynamic>>? attributes;
  List<Map<String, dynamic>>? encounters;

  OmrsVisit({this.uuid, this.display, this.visitType, this.location,
    this.patient, this.startDatetime, this.stopDatetime,
    this.voided, this.attributes, this.encounters
  });
  factory OmrsVisit.fromJson(Map<String, dynamic> json) => _$OmrsVisitFromJson(json);
  Map<String, dynamic> toJson() => _$OmrsVisitToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/omrs_provider.dart';
import '../../domain/models/omrs_location.dart';
import '../../domain/models/omrs_patient.dart';
import '../../domain/models/omrs_visit_type.dart';
import 'omrs_encounter_type.dart';
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

@JsonSerializable()
class OmrsEncounter {
  final String? uuid;
  final DateTime? encounterDatetime;
  final OmrsEncounterType? encounterType;
  final OmrsPatient? patient;
  final OmrsLocation? location;
  final List<OmrsEncounterProvider>? encounterProviders;

  OmrsEncounter({this.uuid, this.encounterDatetime, this.encounterType,
      this.patient, this.location, this.encounterProviders});
  factory OmrsEncounter.fromJson(Map<String, dynamic> json) => _$OmrsEncounterFromJson(json);
  Map<String, dynamic> toJson() => _$OmrsEncounterToJson(this);
}

@JsonSerializable()
class OmrsEncounterProvider {
  final String? uuid;
  final OmrsProvider? provider;
  final Map<String, dynamic>? encounterRole;

  OmrsEncounterProvider({this.uuid, this.provider, this.encounterRole});
  factory OmrsEncounterProvider.fromJson(Map<String, dynamic> json) => _$OmrsEncounterProviderFromJson(json);
  Map<String, dynamic> toJson() => _$OmrsEncounterProviderToJson(this);
}
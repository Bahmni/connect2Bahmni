
import 'package:json_annotation/json_annotation.dart';
import '../../domain/models/omrs_provider.dart';
import '../../domain/models/oms_visit.dart';
part 'bahmni_drug_order.g.dart';

@JsonSerializable()
class BahmniDrugOrder {
  String? uuid;
  String? orderNumber;
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  DateTime? effectiveStartDate;
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  DateTime? effectiveStopDate;
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  DateTime? autoExpireDate;
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  DateTime? dateActivated;
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  DateTime? scheduledDate;
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  DateTime? dateStopped;
  int? duration;
  String? durationUnits;
  String? commentToFulfiller;
  String? instructions;
  String? orderType;
  String? careSetting;
  String? dosingInstructionsType;
  String? encounterUuid;
  bool? retired;
  String? action;
  OmrsProvider? provider;
  OmrsVisit? visit;
  DrugInfo? drug;
  DrugConcept? concept;
  DosingInstructions? dosingInstructions;

  BahmniDrugOrder({
      this.uuid,
      this.orderNumber,
      this.effectiveStartDate,
      this.effectiveStopDate,
      this.autoExpireDate,
      this.dateActivated,
      this.scheduledDate,
      this.dateStopped,
      this.duration,
      this.durationUnits,
      this.commentToFulfiller,
      this.instructions,
      this.orderType,
      this.careSetting,
      this.dosingInstructionsType,
      this.encounterUuid,
      this.retired,
      this.action,
      this.provider,
      this.visit,
      this.drug,
      this.dosingInstructions,
      this.concept
  });

  factory BahmniDrugOrder.fromJson(Map<String, dynamic> json) => _$BahmniDrugOrderFromJson(json);
  Map<String, dynamic> toJson() => _$BahmniDrugOrderToJson(this);

  static DateTime? _dateFromJson(int? timestamp) {
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
  static int? _dateToJson(DateTime? time) {
    if (time == null) return null;
    return time.millisecondsSinceEpoch;
  }
}

@JsonSerializable()
class DrugInfo {
  String? uuid;
  String? name;
  String? form;
  String? strength;

  DrugInfo({this.uuid, this.name, this.form, this.strength});
  factory DrugInfo.fromJson(Map<String, dynamic> json) => _$DrugInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DrugInfoToJson(this);
}

@JsonSerializable()
class DosingInstructions {
  double? dose;
  String? doseUnits;
  String? route;
  String? frequency;
  bool? asNeeded;
  double? quantity;
  String? quantityUnits;
  String? administrationInstructions;

  DosingInstructions({
      this.dose,
      this.doseUnits,
      this.route,
      this.frequency,
      this.asNeeded,
      this.quantity,
      this.quantityUnits,
      this.administrationInstructions});

  factory DosingInstructions.fromJson(Map<String, dynamic> json) => _$DosingInstructionsFromJson(json);
  Map<String, dynamic> toJson() => _$DosingInstructionsToJson(this);
}

@JsonSerializable()
class DrugConcept {
  String? uuid;
  String? name;
  String? shortName;
  String? conceptClass;

  DrugConcept({this.uuid, this.name, this.shortName, this.conceptClass});

  factory DrugConcept.fromJson(Map<String, dynamic> json) => _$DrugConceptFromJson(json);
  Map<String, dynamic> toJson() => _$DrugConceptToJson(this);
}
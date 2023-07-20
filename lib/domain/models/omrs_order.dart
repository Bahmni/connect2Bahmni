import 'package:json_annotation/json_annotation.dart';

import 'omrs_patient.dart';
import 'oms_visit.dart';
import 'omrs_concept.dart';
import 'omrs_provider.dart';
part 'omrs_order.g.dart';


@JsonSerializable()
class OmrsOrder {
  String? uuid;
  String? orderNumber;
  OmrsConcept? concept;
  String? action;
  DateTime? dateActivated;
  DateTime? scheduledDate;
  DateTime? dateStopped;
  DateTime? autoExpireDate;
  OmrsEncounter? encounter;
  String? urgency;
  String? instructions;
  String? commentToFulfiller;
  String? display;
  OmrsPatient? patient;
  OmrsProvider? orderer;
  OmrsOrderType? orderType;

  OmrsOrder({this.uuid, this.orderNumber, this.concept, this.action, this.dateActivated, this.scheduledDate, this.dateStopped, this.autoExpireDate, this.encounter, this.urgency, this.instructions, this.commentToFulfiller, this.display, this.patient, this.orderer, this.orderType});
  factory OmrsOrder.fromJson(Map<String, dynamic> json) => _$OmrsOrderFromJson(json);
  Map<String, dynamic> toJson() => _$OmrsOrderToJson(this);

}

@JsonSerializable()
class OmrsOrderType {
  String uuid;
  String? display;
  String? name;
  bool? retired;
  List<OmrsConceptClass>? conceptClasses;

  OmrsOrderType({required this.uuid, this.display, this.conceptClasses, this.name, this.retired});
  factory OmrsOrderType.fromJson(Map<String, dynamic> json) => _$OmrsOrderTypeFromJson(json);
  Map<String, dynamic> toJson() => _$OmrsOrderTypeToJson(this);
}
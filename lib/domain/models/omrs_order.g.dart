// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'omrs_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OmrsOrder _$OmrsOrderFromJson(Map<String, dynamic> json) => OmrsOrder(
      uuid: json['uuid'] as String?,
      orderNumber: json['orderNumber'] as String?,
      concept: json['concept'] == null
          ? null
          : OmrsConcept.fromJson(json['concept'] as Map<String, dynamic>),
      action: json['action'] as String?,
      dateActivated: json['dateActivated'] == null
          ? null
          : DateTime.parse(json['dateActivated'] as String),
      scheduledDate: json['scheduledDate'] == null
          ? null
          : DateTime.parse(json['scheduledDate'] as String),
      dateStopped: json['dateStopped'] == null
          ? null
          : DateTime.parse(json['dateStopped'] as String),
      autoExpireDate: json['autoExpireDate'] == null
          ? null
          : DateTime.parse(json['autoExpireDate'] as String),
      encounter: json['encounter'] == null
          ? null
          : OmrsEncounter.fromJson(json['encounter'] as Map<String, dynamic>),
      urgency: json['urgency'] as String?,
      instructions: json['instructions'] as String?,
      commentToFulfiller: json['commentToFulfiller'] as String?,
      display: json['display'] as String?,
      patient: json['patient'] == null
          ? null
          : OmrsPatient.fromJson(json['patient'] as Map<String, dynamic>),
      orderer: json['orderer'] == null
          ? null
          : OmrsProvider.fromJson(json['orderer'] as Map<String, dynamic>),
      orderType: json['orderType'] == null
          ? null
          : OmrsOrderType.fromJson(json['orderType'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OmrsOrderToJson(OmrsOrder instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'orderNumber': instance.orderNumber,
      'concept': instance.concept,
      'action': instance.action,
      'dateActivated': instance.dateActivated?.toIso8601String(),
      'scheduledDate': instance.scheduledDate?.toIso8601String(),
      'dateStopped': instance.dateStopped?.toIso8601String(),
      'autoExpireDate': instance.autoExpireDate?.toIso8601String(),
      'encounter': instance.encounter,
      'urgency': instance.urgency,
      'instructions': instance.instructions,
      'commentToFulfiller': instance.commentToFulfiller,
      'display': instance.display,
      'patient': instance.patient,
      'orderer': instance.orderer,
      'orderType': instance.orderType,
    };

OmrsOrderType _$OmrsOrderTypeFromJson(Map<String, dynamic> json) =>
    OmrsOrderType(
      uuid: json['uuid'] as String,
      display: json['display'] as String?,
      conceptClasses: (json['conceptClasses'] as List<dynamic>?)
          ?.map((e) => OmrsConceptClass.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String?,
      retired: json['retired'] as bool?,
    );

Map<String, dynamic> _$OmrsOrderTypeToJson(OmrsOrderType instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'display': instance.display,
      'name': instance.name,
      'retired': instance.retired,
      'conceptClasses': instance.conceptClasses,
    };

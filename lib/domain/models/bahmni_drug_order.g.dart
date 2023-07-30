// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bahmni_drug_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BahmniDrugOrder _$BahmniDrugOrderFromJson(Map<String, dynamic> json) =>
    BahmniDrugOrder(
      uuid: json['uuid'] as String?,
      orderNumber: json['orderNumber'] as String?,
      effectiveStartDate:
          BahmniDrugOrder._dateFromJson(json['effectiveStartDate'] as int?),
      effectiveStopDate:
          BahmniDrugOrder._dateFromJson(json['effectiveStopDate'] as int?),
      autoExpireDate:
          BahmniDrugOrder._dateFromJson(json['autoExpireDate'] as int?),
      dateActivated:
          BahmniDrugOrder._dateFromJson(json['dateActivated'] as int?),
      scheduledDate:
          BahmniDrugOrder._dateFromJson(json['scheduledDate'] as int?),
      dateStopped: BahmniDrugOrder._dateFromJson(json['dateStopped'] as int?),
      duration: json['duration'] as int?,
      durationUnits: json['durationUnits'] as String?,
      commentToFulfiller: json['commentToFulfiller'] as String?,
      instructions: json['instructions'] as String?,
      orderType: json['orderType'] as String?,
      careSetting: json['careSetting'] as String?,
      dosingInstructionsType: json['dosingInstructionsType'] as String?,
      encounterUuid: json['encounterUuid'] as String?,
      retired: json['retired'] as bool?,
      action: json['action'] as String?,
      provider: json['provider'] == null
          ? null
          : OmrsProvider.fromJson(json['provider'] as Map<String, dynamic>),
      visit: json['visit'] == null
          ? null
          : OmrsVisit.fromJson(json['visit'] as Map<String, dynamic>),
      drug: json['drug'] == null
          ? null
          : DrugInfo.fromJson(json['drug'] as Map<String, dynamic>),
      dosingInstructions: json['dosingInstructions'] == null
          ? null
          : DosingInstructions.fromJson(
              json['dosingInstructions'] as Map<String, dynamic>),
      concept: json['concept'] == null
          ? null
          : DrugConcept.fromJson(json['concept'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BahmniDrugOrderToJson(BahmniDrugOrder instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'orderNumber': instance.orderNumber,
      'effectiveStartDate':
          BahmniDrugOrder._dateToJson(instance.effectiveStartDate),
      'effectiveStopDate':
          BahmniDrugOrder._dateToJson(instance.effectiveStopDate),
      'autoExpireDate': BahmniDrugOrder._dateToJson(instance.autoExpireDate),
      'dateActivated': BahmniDrugOrder._dateToJson(instance.dateActivated),
      'scheduledDate': BahmniDrugOrder._dateToJson(instance.scheduledDate),
      'dateStopped': BahmniDrugOrder._dateToJson(instance.dateStopped),
      'duration': instance.duration,
      'durationUnits': instance.durationUnits,
      'commentToFulfiller': instance.commentToFulfiller,
      'instructions': instance.instructions,
      'orderType': instance.orderType,
      'careSetting': instance.careSetting,
      'dosingInstructionsType': instance.dosingInstructionsType,
      'encounterUuid': instance.encounterUuid,
      'retired': instance.retired,
      'action': instance.action,
      'provider': instance.provider,
      'visit': instance.visit,
      'drug': instance.drug,
      'concept': instance.concept,
      'dosingInstructions': instance.dosingInstructions,
    };

DrugInfo _$DrugInfoFromJson(Map<String, dynamic> json) => DrugInfo(
      uuid: json['uuid'] as String?,
      name: json['name'] as String?,
      form: json['form'] as String?,
      strength: json['strength'] as String?,
    );

Map<String, dynamic> _$DrugInfoToJson(DrugInfo instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'form': instance.form,
      'strength': instance.strength,
    };

DosingInstructions _$DosingInstructionsFromJson(Map<String, dynamic> json) =>
    DosingInstructions(
      dose: (json['dose'] as num?)?.toDouble(),
      doseUnits: json['doseUnits'] as String?,
      route: json['route'] as String?,
      frequency: json['frequency'] as String?,
      asNeeded: json['asNeeded'] as bool?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      quantityUnits: json['quantityUnits'] as String?,
      administrationInstructions: json['administrationInstructions'] as String?,
    );

Map<String, dynamic> _$DosingInstructionsToJson(DosingInstructions instance) =>
    <String, dynamic>{
      'dose': instance.dose,
      'doseUnits': instance.doseUnits,
      'route': instance.route,
      'frequency': instance.frequency,
      'asNeeded': instance.asNeeded,
      'quantity': instance.quantity,
      'quantityUnits': instance.quantityUnits,
      'administrationInstructions': instance.administrationInstructions,
    };

DrugConcept _$DrugConceptFromJson(Map<String, dynamic> json) => DrugConcept(
      uuid: json['uuid'] as String?,
      name: json['name'] as String?,
      shortName: json['shortName'] as String?,
      conceptClass: json['conceptClass'] as String?,
    );

Map<String, dynamic> _$DrugConceptToJson(DrugConcept instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'shortName': instance.shortName,
      'conceptClass': instance.conceptClass,
    };

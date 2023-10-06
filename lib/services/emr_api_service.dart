import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../domain/models/omrs_concept.dart';
import '../domain/models/omrs_obs.dart';
import '../domain/models/omrs_order.dart';
import '../domain/models/omrs_patient.dart';
import '../domain/condition_model.dart';
import '../utils/app_failures.dart';
import '../utils/app_urls.dart';
import '../utils/shared_preference.dart';
import '../screens/models/consultation_model.dart';
import '../services/domain_service.dart';

class EmrApiService extends DomainService {
  static const errLocationRequired = 'Location is required';
  static const errVisitTypeRequired = 'Visit type is required';
  static const errEncTypeRequired = 'Encounter type is required';
  static const errConsultationPatientRequired = 'Patient not specified';
  static const errConsultationPractitionerRequired = 'Practitioner not specified';
  static const errEmptyConsultationCannotBeSaved = 'Consultation is empty';

  Future<List<ConditionModel>> searchCondition(OmrsPatient patient) async {
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
      throw 'Authentication Failure';
    }
    String url = '${AppUrls.bahmni.diagnosis}?patientUuid=${patient.uuid}';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': 'JSESSIONID=$sessionId',
      },
    );

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      return List<ConditionModel>.from(responseJson.map((v) => ConditionModel.fromPatientDiagnosis(patient, v)));
    } else {
      throw handleErrorResponse(response);
    }
  }

  Future<bool> saveConsultation(ConsultationModel consultation) {
    DateTime encounterDateTime = consultation.lastUpdateAt ?? DateTime.now();
    //var encounterTime =  encounterDateTime.isUtc ? encounterDateTime.toLocal() :  encounterDateTime;
    return UserPreferences().getSessionId()
      .then((sessionId) {
        var payload = jsonEncode(_encounterTxPayload(consultation, encounterDateTime));
        _debugInfo(payload);
        return http.post(
          Uri.parse(AppUrls.bahmni.bahmniEncounter),
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Accept": "application/json",
            'Cookie': 'JSESSIONID=$sessionId',
          },
          body: payload,
        );
      }).then((response) {
        debugPrint('response : ${response.statusCode}');
        _debugInfo(response.body);
        switch (response.statusCode) {
          case 200:
          case 201:
          case 202:
          case 204:
                return true;
          default:
              //TODO, log error
              handleErrorResponse(response);
              return false;
        }
    });
  }

  void _debugInfo(String info) {
    debugPrint("******************");
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(info).forEach((RegExpMatch match) =>   debugPrint(match.group(0)));
    debugPrint("******************");
  }

  Map<String, Object?> _encounterTxPayload(ConsultationModel consultation, DateTime encounterDateTime) {
    return {
        'patientUuid': consultation.patient?.uuid,
        'locationUuid': consultation.location?.uuid,
        'visitTypeUuid': consultation.visitType?.uuid,
        'encounterTypeUuid': consultation.encounterType?.uuid,
        'encounterDateTime': encounterDateTime.millisecondsSinceEpoch,
        'providers': [{
          'uuid': consultation.user.provider?.uuid
        }],
        'bahmniDiagnoses': _diagnosesPayload(consultation, encounterDateTime),
        'observations': [..._obsPayload(consultation, encounterDateTime), ..._formObservations(consultation, encounterDateTime)],
        'orders': _txOrders(consultation, encounterDateTime),
        'drugOrders': _txDrugOrders(consultation, encounterDateTime),
      };
  }

  List<Failure> validate(ConsultationModel consultation) {
    List<Failure> validationResults = [];
    consultation.patient ?? validationResults.add(Failure(errConsultationPatientRequired));
    consultation.user.provider ?? validationResults.add(Failure(errConsultationPractitionerRequired));
    consultation.location ?? validationResults.add(Failure(errLocationRequired));
    consultation.visitType ?? validationResults.add(Failure(errVisitTypeRequired));
    consultation.encounterType ?? validationResults.add(Failure(errEncTypeRequired));

    var isEmptyConsultation = consultation.diagnosisList.isEmpty && consultation.observationForms.isEmpty
      && consultation.medicationList.isEmpty && consultation.investigationList.isEmpty
      && consultation.consultNote == null;
    if (isEmptyConsultation) {
      validationResults.add(Failure(errEmptyConsultationCannotBeSaved));
    }
    // if (consultation.consultNote?.concept.uuid == null) {
    //   validationResults.add(Failure(errConsultationNoteRequired));
    // }
    return validationResults;
  }

  List<Map<String, dynamic>> _diagnosesPayload(ConsultationModel consultation, DateTime encounterTime) {
    return consultation.diagnosisList.map((dia) {
      var recordedDate = dia.recordedDate ?? encounterTime;
      return {
        'order': dia.order?.name.toUpperCase(),
        'certainty': dia.verificationStatus?.display?.toUpperCase(),
        'comments' : dia.note,
        'diagnosisDateTime': recordedDate.millisecondsSinceEpoch,
        'providers': [{
          'uuid': consultation.user.provider?.uuid
        }],
        'codedAnswer': {
          'uuid': dia.code?.uuid
        }
      };
    }
    ).toList();
  }

  List<Map<String, dynamic>> _obsPayload(ConsultationModel consultation, DateTime encounterDateTime) {
    List<Map<String, dynamic>> obsList = [];
    if (consultation.consultNote != null) {
      obsList.add({
        'concept': {
          'uuid': consultation.consultNote?.concept.uuid,
        },
        'value': consultation.consultNote?.valueAsString,
      });
    }
    return obsList;
  }

  List<Map<String, dynamic>> _formObservations(ConsultationModel consultation, DateTime encounterDateTime) {
    List<Map<String, dynamic>> obsList = [];
    if (consultation.observationForms.isNotEmpty) {
      consultation.observationForms.forEach((form, values) {
        if (values.isNotEmpty) {
          for (var obs in values) {
            obsList.add(_getObservation(obs));
          }
        }
      });
    }
    return obsList;
  }

  Map<String, dynamic> _getObservation(OmrsObs obs) {
    bool isObsGroup = (obs.groupMembers != null && obs.groupMembers!.isNotEmpty);
    if (!isObsGroup) {
      return {
        'concept': {
          'uuid': obs.concept.uuid,
        },
        'value': _getObservationValue(obs),
      };
    } else {
      return {
        'concept': {
          'uuid': obs.concept.uuid,
        },
        'groupMembers': obs.groupMembers!.map((e) => _getObservation(e)).toList(),
        'value': null,
      };
    }
  }

  Object _getObservationValue(OmrsObs obs) {
    if (obs.value is OmrsConcept) {
      return {
        'uuid': (obs.value as OmrsConcept).uuid,
      };
    }
    return obs.value;
  }

  Future<List<OmrsOrderType>> orderTypes() {
    return UserPreferences().getSessionId()
    .then((sessionId) {
      if (sessionId == null) {
        throw 'Authentication Failure';
      }
      return http.get(
        Uri.parse(AppUrls.omrs.orderType),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': 'JSESSIONID=$sessionId',
        },
      );
    }).then((response) {
      switch (response.statusCode) {
        case 200:
        case 304:
          var responseJson = jsonDecode(response.body);
          var resultList = responseJson['results'] ?? [];
          return List<OmrsOrderType>.from(resultList.map((ot) {
            return OmrsOrderType.fromJson(ot);
          }));
        default:
          throw handleErrorResponse(response);
      }
    });
  }

  List<Map<String, dynamic>> _txOrders(ConsultationModel consultation, DateTime encounterDateTime) {
    List<Map<String, dynamic>> orders = [];
    for (var investigation in consultation.investigationList) {
      orders.add({
        'action': investigation.action,
        'commentToFulfiller': investigation.commentToFulfiller,
        'urgency': investigation.urgency,
        'concept': {
          'uuid': investigation.concept?.uuid,
        } //TODO 'previousOrderUuid': investigation.previousOrderUuid
      });
    }
    return orders;
  }

  List<Map<String, dynamic>> _txDrugOrders(ConsultationModel consultation, DateTime encounterDateTime) {
    return consultation.medicationList.map((drugOrder) {
      var administrationInstructions = drugOrder.dosingInstructions?.administrationInstructions ?? '';
      var note = drugOrder.commentToFulfiller ?? '';
      return {
        'careSetting': drugOrder.careSetting,
        'orderType': 'Drug Order',
        'dosingInstructionType': 'org.openmrs.module.bahmniemrapi.drugorder.dosinginstructions.FlexibleDosingInstructions',
        'drug': {
          'uuid': drugOrder.drug?.uuid,
        },
        'dosingInstructions': {
          'dose': drugOrder.dosingInstructions?.dose,
          'doseUnits': drugOrder.dosingInstructions?.doseUnits,
          'route': drugOrder.dosingInstructions?.route,
          'frequency': drugOrder.dosingInstructions?.frequency,
          'asNeeded': drugOrder.dosingInstructions?.asNeeded ?? false,
          'administrationInstructions': "{\"instructions\":\"$administrationInstructions\",\"additionalInstructions\":\"$note\"}",
          'quantity': drugOrder.dosingInstructions?.quantity,
          'quantityUnits': drugOrder.dosingInstructions?.quantityUnits,
          'numberOfRefills': 0,
        },
        "duration": drugOrder.duration,
        "durationUnits": drugOrder.durationUnits,
        "scheduledDate": drugOrder.scheduledDate?.toUtc().toIso8601String(),
        "autoExpireDate": null,
        "dateStopped": null,
      };
    }).toList();
  }

}


import 'dart:convert';
import 'package:connect2bahmni/services/domain_service.dart';
import 'package:connect2bahmni/utils/app_failures.dart';
import 'package:http/http.dart' as http;
import '../utils/app_urls.dart';
import '../utils/shared_preference.dart';
import '../domain/models/omrs_patient.dart';
import '../domain/condition_model.dart';
import '../screens/models/consultation_model.dart';

class EmrApiService extends DomainService {
  static const errLocationRequired = 'Location is required';
  static const errVisitTypeRequired = 'Visit type is required';
  static const errEncTypeRequired = 'Encounter type is required';
  static const errConsultationNoteRequired = 'Consultation note is required';

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
      throw 'Failed to fetch Diagnoses';
    }
  }

  Future<bool> saveConsultation(ConsultationModel consultation) {
    DateTime encounterDateTime = consultation.lastUpdateAt ?? DateTime.now();
    //var encounterTime =  encounterDateTime.isUtc ? encounterDateTime.toLocal() :  encounterDateTime;
    return UserPreferences().getSessionId()
      .then((sessionId) {
        var payload = jsonEncode(_encounterTxPayload(consultation, encounterDateTime));
        //print('posting consultation: $payload');
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
        'observations': _obsPayload(consultation, encounterDateTime),
      };
  }

  List<Failure> validate(ConsultationModel consultation) {
    List<Failure> validationResults = [];
    consultation.location ?? validationResults.add(Failure(errLocationRequired));
    consultation.visitType ?? validationResults.add(Failure(errVisitTypeRequired));
    consultation.encounterType ?? validationResults.add(Failure(errEncTypeRequired));
    if (consultation.consultNote?.concept.uuid == null) {
      validationResults.add(Failure(errConsultationNoteRequired));
    }
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

}
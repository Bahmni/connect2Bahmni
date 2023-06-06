

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/app_urls.dart';
import '../utils/shared_preference.dart';
import '../domain/models/omrs_patient.dart';
import '../domain/condition_model.dart';
import '../screens/models/consultation_model.dart';

class EmrApiService {
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
    var validationResult = _validate(consultation);
    if (validationResult.isNotEmpty) {
      return Future.value(false);
    }

    DateTime encounterDateTime = consultation.lastUpdateAt ?? DateTime.now();
    //var encounterTime =  encounterDateTime.isUtc ? encounterDateTime.toLocal() :  encounterDateTime;
    return UserPreferences().getSessionId()
      .then((sessionId) {
        var payload = jsonEncode({
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
        });
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
        // print('response code: ${response.statusCode}');
        // print('response : ${response.body}');
        switch (response.statusCode) {
          case 200:
          case 201:
          case 202:
          case 204:
            {
                return true;
            }
          default:
            {
              //TODO, log error
              //print('consultation save error: response  ${response.body}');
              return false;
            }
        }
    });
  }

  List<String> _validate(ConsultationModel consultation) {
    List<String> validationResults = [];
    consultation.location ?? validationResults.add("required:location");
    consultation.visitType ?? validationResults.add("required:visit type");
    consultation.encounterType ?? validationResults.add("required:encounter type");
    if (consultation.consultNote?.concept.uuid == null) {
      validationResults.add("required:consult notes concept");
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
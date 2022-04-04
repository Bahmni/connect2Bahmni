import 'dart:convert';

import 'package:http/http.dart' as http;
import '../services/fhir_service.dart';
import 'package:fhir/r4.dart';

import '../utils/app_urls.dart';
import '../domain/models/omrs_encounter_type.dart';
import '../domain/models/omrs_visit_type.dart';
import '../utils/shared_preference.dart';

class Encounters {
  Future<Bundle> byPatientUuid(String uuid, Future<String?> Function() fetchSessionId) async {
    String url = AppUrls.fhir.encounter + '?patient=$uuid';
    return FhirInterface().fetch(url);
  }

  Future<List<OmrsVisitType>> visitTypes() {
    return _fetch(AppUrls.omrs.visitType)
      .then((response) {
          if (response.statusCode != 200) {
            throw response.statusCode;
          }
          var responseJson = jsonDecode(response.body);
          var resultList = responseJson['results'] ?? [];
          return List<OmrsVisitType>.from(resultList.map((v) => OmrsVisitType.fromJson(v)));
      });
  }

  Future<http.Response> _fetch(String url) {
    return UserPreferences().getSessionId().then((sessionId) {
      if (sessionId == null) {
        throw 'Authentication Failure';
      }
      return http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': 'JSESSIONID=$sessionId',
        },
      );
    });
  }


  Future<List<OmrsEncounterType>> encTypes() {
    return _fetch(AppUrls.omrs.encType)
        .then((response) {
      if (response.statusCode != 200) {
        throw response.statusCode;
      }
      var responseJson = jsonDecode(response.body);
      var resultList = responseJson['results'] ?? [];
      return List<OmrsEncounterType>.from(resultList.map((v) => OmrsEncounterType.fromJson(v)));
    });
  }

}
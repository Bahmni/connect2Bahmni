import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fhir/r4.dart';

import '../domain/models/omrs_patient.dart';

import '../utils/app_urls.dart';
import '../utils/app_config.dart';
import 'fhir_service.dart';
import '../utils/shared_preference.dart';

class Patients {
  Future<Bundle> searchByName(String name) async {
    String url = AppUrls.fhir.patient + '?name=$name';
    return FhirInterface().fetch(url);
  }

  Future<List<OmrsPatient>?> searchOmrsByName(String name) async {
    //TODO
    //v=custom:(uuid,identifiers:(uuid,identifier,identifierType:(uuid,name),location),person:(display,gender,birthdate))
    if (!AppConfig.fhirSupport) {

    }
    return Future.value(null);
  }

  Future<OmrsPatient?> withUuid(String uuid) async {
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
      throw 'Authentication Failure';
    }
    String url = AppUrls.omrs.patient + '/$uuid?v=full';
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
      return OmrsPatient.fromJson(responseJson);
    } else {
      return null;
    }
  }
}
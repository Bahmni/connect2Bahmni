import 'package:http/http.dart';
import 'package:fhir/r4.dart';
import 'dart:convert';

import '../utils/app_urls.dart';
import 'fhir_service.dart';

class Patients {
  Future<Map<String, dynamic>> searchByName(String name, Future<String?> Function() fetchSessionId) async {
    String? sessionId = await fetchSessionId();
    String url = AppUrls.fhir.patientUrl + '?name=$name';
    return FhirInterface().getRequest(fetchSessionId, url);
  }
}
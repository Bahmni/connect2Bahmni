import 'package:http/http.dart';
import 'package:fhir/r4.dart';
import 'dart:convert';

import '../utils/app_urls.dart';
import 'fhir_service.dart';

class Patients {
  Future<Map<String, dynamic>> searchByName(String name) async {
    String url = AppUrls.fhir.patient + '?name=$name';
    return FhirInterface().fetch(url);
  }
}
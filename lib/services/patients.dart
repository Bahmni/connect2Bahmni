import 'package:fhir/r4.dart';

import '../utils/app_urls.dart';
import 'fhir_service.dart';

class Patients {
  Future<Bundle> searchByName(String name) async {
    String url = AppUrls.fhir.patient + '?name=$name';
    return FhirInterface().fetch(url);
  }
}
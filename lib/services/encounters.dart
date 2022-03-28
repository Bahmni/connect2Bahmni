import '../services/fhir_service.dart';
import 'package:fhir/r4.dart';

import '../utils/app_urls.dart';

class Encounters {
  Future<Bundle> byPatientUuid(String uuid, Future<String?> Function() fetchSessionId) async {
    String url = AppUrls.fhir.encounter + '?patient=$uuid';
    return FhirInterface().fetch(url);
  }

}
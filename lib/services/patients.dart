
import '../domain/models/omrs_patient.dart';
import 'package:fhir/r4.dart';

import '../utils/app_urls.dart';
import '../utils/app_config.dart';
import 'fhir_service.dart';

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

}
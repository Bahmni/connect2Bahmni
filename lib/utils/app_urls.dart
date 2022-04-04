import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUrls {
  // static const String defaultServer = 'https://qa-02.hip.bahmni-covid19.in';
  static const String defaultServer = 'https://next.mybahmni.org';
  static String baseUrl = dotenv.get('bahmni.server', fallback: defaultServer);
  static OMRSRestUrls omrs = const OMRSRestUrls();
  static FHIRUrls fhir = const FHIRUrls();
  static BahmniRestUrls bahmni = const BahmniRestUrls();
  static EmrApiUrls emrApi = const EmrApiUrls();
}

class OMRSRestUrls {
  const OMRSRestUrls();
  String get base => '${AppUrls.baseUrl}/openmrs/ws/rest/v1';
  String get session => '$base/session';
  String get provider => '$base/provider';
  String get location => '$base/location';
  String get patient => '$base/patient';
  String get visit => '$base/visit';
  String get concept => '$base/concept';
  String get visitType => '$base/visittype';
  String get encType => '$base/encountertype';
}

class FHIRUrls {
  const FHIRUrls();
  String get base => '${AppUrls.baseUrl}/openmrs/ws/fhir2/R4';
  String get patient => '$base/Patient';
  String get encounter => '$base/Encounter';
  String get location => '$base/Location';
}

class BahmniRestUrls {
  const BahmniRestUrls();
  String get base => '${AppUrls.baseUrl}/openmrs/ws/rest/v1';
  String get appointments => '$base/appointments';
  String get appointment => '$base/appointment';
  String get diagnosis => '$base/bahmnicore/diagnosis/search';
  String get bahmniEncounter => '$base/bahmnicore/bahmniencounter';
}

class EmrApiUrls {
  const EmrApiUrls();
  String get base => '${AppUrls.baseUrl}/openmrs/ws/rest/emrapi/';
  String get concept => '$base/concept';
}
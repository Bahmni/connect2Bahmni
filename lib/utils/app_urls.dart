import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUrls {
  static const String defaultServer = 'https://dev.lite.mybahmni.in';
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
  String get obs => '$base/obs';
  String get patientIdentifierTypes => '$base/idgen/identifiertype';
  String get personAttrTypes => '$base/personattributetype?v=custom:(uuid,name,format,description)';
  String get forms => '$base/form';
  String get orderType => '$base/ordertype?v=custom:(uuid,display,conceptClasses:(uuid,display,name))';
}

class FHIRUrls {
  const FHIRUrls();
  String get base => '${AppUrls.baseUrl}/openmrs/ws/fhir2/R4';
  String get patient => '$base/Patient';
  String get encounter => '$base/Encounter';
  String get location => '$base/Location';
  String get observation => '$base/Observation';
}

class BahmniRestUrls {
  const BahmniRestUrls();
  String get base => '${AppUrls.baseUrl}/openmrs/ws/rest/v1';
  String get profile => '$base/bahmnicore/patientprofile';
  String get fetchProfile => '$base/patientprofile';
  String get appointments => '$base/appointments';
  String get appointment => '$base/appointment';
  String get diagnosis => '$base/bahmnicore/diagnosis/search';
  String get bahmniEncounter => '$base/bahmnicore/bahmniencounter';
  String get activePatients => '$base/bahmnicore/sql?q=${dotenv.get('bahmni.list.activePatients', fallback: 'emrapi.sqlSearch.activePatients')}&location_uuid=VISIT_LOCATION';
  String get dispensingPatients => '$base/bahmnicore/sql?q=${dotenv.get('bahmni.list.patientsToDispenseMeds', fallback: 'emrapi.sqlSearch.activePatients')}&location_uuid=VISIT_LOCATION';
  String get publishedForms => '$base/bahmniie/form/latestPublishedForms';
  String get drugOrders => '$base/bahmnicore/drugOrders';

}

class EmrApiUrls {
  const EmrApiUrls();
  String get base => '${AppUrls.baseUrl}/openmrs/ws/rest/emrapi/';
  String get concept => '$base/concept';
}
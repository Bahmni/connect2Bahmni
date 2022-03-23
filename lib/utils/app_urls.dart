class AppUrls {
  //static const String baseUrl = 'https://qa-02.hip.bahmni-covid19.in';
  static const String baseUrl = 'https://next.mybahmni.org';
  static OMRSRestUrls omrs = const OMRSRestUrls();
  static FHIRUrls fhir = const FHIRUrls();
  static BahmniRestUrls bahmni = const BahmniRestUrls();
}

class OMRSRestUrls {
  const OMRSRestUrls();
  String get base => '${AppUrls.baseUrl}/openmrs/ws/rest/v1';
  String get session => '$base/session';
  String get provider => '$base/provider';
  String get location => '$base/location';
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
}
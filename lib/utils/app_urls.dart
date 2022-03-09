class AppUrls {
  static const String baseUrl = 'https://qa-02.hip.bahmni-covid19.in';
  static OMRSRestUrls omrs = const OMRSRestUrls();
  static FHIRUrls fhir = const FHIRUrls();
  static BahmniRestUrls bahmni = const BahmniRestUrls();
}

class OMRSRestUrls {
  const OMRSRestUrls();
  String get baseUrl => '${AppUrls.baseUrl}/openmrs/ws/rest/v1';
  String get sessionUrl => '$baseUrl/session';
  String get providerUrl => '$baseUrl/provider';
}

class FHIRUrls {
  const FHIRUrls();
  String get baseUrl => '${AppUrls.baseUrl}/openmrs/ws/fhir2/R4';
  String get patientUrl => '$baseUrl/Patient';
  String get encounterUrl => '$baseUrl/Encounter';
}

class BahmniRestUrls {
  const BahmniRestUrls();
  String get baseUrl => '${AppUrls.baseUrl}/openmrs/ws/rest/v1';
  String get appointmentsUrl => '$baseUrl/appointments';
  String get appointmentUrl => '$baseUrl/appointment';
}
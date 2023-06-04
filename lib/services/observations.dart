
import 'package:fhir/r4.dart';
import 'package:http/http.dart' as http;
import '../utils/app_urls.dart';
import '../utils/shared_preference.dart';
import 'fhir_service.dart';

class Observations {
  Future<Bundle> forConcept(String patientUuid, String conceptUuid) async {
    String url = AppUrls.fhir.observation + '?subject=$patientUuid&code=$conceptUuid';
    return FhirInterface().fetch(url);
  }


  Future<http.Response> _fetch(String url) {
    return UserPreferences().getSessionId().then((sessionId) {
      if (sessionId == null) {
        throw 'Authentication Failure';
      }
      return http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': 'JSESSIONID=$sessionId',
        },
      );
    });
  }

}
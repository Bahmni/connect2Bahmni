
import 'package:http/http.dart';
import 'package:fhir/r4.dart';
import 'dart:convert';

import '../utils/shared_preference.dart';
import '../utils/app_urls.dart';
import '../utils/app_failures.dart';

class FhirInterface {
  Future<Bundle> fetch(String url, [Map<String, String> params = const {}]) async {
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
      throw Failure('Session expired.', 401);
    }

    Response response = await get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': 'JSESSIONID=$sessionId',
      },
    );

    if (response.statusCode == 200) {
      try {
        return Bundle.fromJson(jsonDecode(response.body));
      } catch(err, stacktrace) {
        print('Error: $err');
        print('stacktrace: $stacktrace');
        throw Failure('Error occurred during deserialization', 1500);
      }
    }
    throw Failure('Error on server', response.statusCode);
  }

  Future<Bundle> searchByPatientName(String name) async {
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
      throw Failure('Session expired.', 401);
    }
    String url = AppUrls.fhir.patient + '?name=$name';
    Response response = await get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': 'JSESSIONID=$sessionId',
      },
    );
    if (response.statusCode == 200) {
      return Bundle.fromJson(jsonDecode(response.body));
    }
    throw Failure('Error on server', response.statusCode);
  }
}
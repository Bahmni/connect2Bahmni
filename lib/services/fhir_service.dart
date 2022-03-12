
import 'package:http/http.dart';
import 'package:fhir/r4.dart';
import 'dart:convert';

import '../utils/shared_preference.dart';
import '../utils/app_urls.dart';

class FhirInterface {
  Future<Map<String, dynamic>> getRequest(String url, [Map<String, String> params = const {}]) async {
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
      return {
        'status': false,
        'result': null,
        'message': 'session expired',
      };
    }

    Response response = await get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': 'JSESSIONID=$sessionId',
      },
    );

    if (response.statusCode == 200) {
      Bundle bundle = Bundle.fromJson(jsonDecode(response.body));
      //final Map<String, dynamic> responseData = json.decode(response.body);
      return {
        'status': true,
        'result': bundle,
        'message': 'success',
      };
    }

    return {
      'status': false,
      'result': null,
      'message': 'error on server',
    };
  }

  Future<Map<String, dynamic>> searchByName(String name) async {
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
      return {
        'status': false,
        'result': null,
        'message': 'session expired',
      };
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
      Bundle bundle = Bundle.fromJson(jsonDecode(response.body));
      //final Map<String, dynamic> responseData = json.decode(response.body);
      return {
        'status': true,
        'result': bundle,
        'message': 'success',
      };
    }

    return {
      'status': false,
      'result': null,
      'message': 'error on server',
    };

  }


}
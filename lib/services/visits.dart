
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import '../utils/app_urls.dart';
import '../utils/shared_preference.dart';
import '../../domain/models/oms_visit.dart';

class Visits {
  Future<List<OmrsVisit>> visitsForPatient(String patientUuid) async {
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
      throw 'Authentication Failure';
    }
    String url = AppUrls.omrs.visit + '?patient=$patientUuid&v=full';
    Response response = await get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': 'JSESSIONID=$sessionId',
      },
    );

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      var resultList = responseJson['results'] ?? [];
      return List<OmrsVisit>.from(resultList.map((v) => OmrsVisit.fromJson(v)));
    } else {
      throw 'Failed to fetch Visits';
    }
  }
}
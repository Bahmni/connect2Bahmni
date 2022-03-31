import 'dart:convert';

import 'package:http/http.dart';

import '../domain/models/omrs_concept.dart';
import '../utils/app_urls.dart';
import '../utils/shared_preference.dart';

class ConceptDictionary {
  Future<List<OmrsConcept>> searchCondition(String term) async {
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
      throw 'Authentication Failure';
    }
    String url = AppUrls.emrApi.concept + '?limit=20&term=$term';
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
      var resultList = responseJson ?? [];
      return List<OmrsConcept>.from(resultList.map((v) => OmrsConcept.fromJson(v)));
    } else {
      throw 'Failed to fetch Conditions';
    }
  }
}
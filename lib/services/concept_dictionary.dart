import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/models/omrs_concept.dart';
import '../utils/app_urls.dart';
import '../utils/shared_preference.dart';

class ConceptDictionary {
  Future<List<OmrsConcept>> searchCondition(String term) async {
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
      throw 'Authentication Failure';
    }
    String url = '${AppUrls.emrApi.concept}?limit=20&term=$term';
    var response = await http.get(
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

  Future<List<OmrsConcept>> searchConcept(String term) async {
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
      throw 'Authentication Failure';
    }
    String url = '${AppUrls.omrs.concept}?q=$term&v=full';
    var response = await http.get(
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
      return List<OmrsConcept>.from(resultList.map((v) => OmrsConcept.fromJson(v)));
    } else {
      throw 'Failed to fetch Concept';
    }
  }

  Future<List<OmrsConcept>> _conceptsByName(String term) async {
    return UserPreferences().getSessionId().then((sessionId) {
      if (sessionId == null) {
        throw 'Authentication Failure';
      }
      return http.get(
        Uri.parse('${AppUrls.omrs.concept}?q=$term&v=full'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': 'JSESSIONID=$sessionId',
        },
      );
    }).then((response) {
        if (response.statusCode != 200) {
          throw 'Failed to fetch concept';
        }
        var responseJson = jsonDecode(response.body);
        var resultList = responseJson['results'] ?? [];
        return List<OmrsConcept>.from(resultList.map((v) => OmrsConcept.fromJson(v)));
    });
  }

  Future<OmrsConcept?> fetchDiagnosisOrder() async {
    return _findConcept('Diagnosis Order');
  }

  Future<OmrsConcept?> fetchDiagnosisCertainty() async {
    return _findConcept('Diagnosis Certainty');
  }

  Future<OmrsConcept?> _findConcept(String term) async {
    return _conceptsByName(term).then((list) {
      return list.isNotEmpty ? list[0] : null;
    });
  }

  Future<OmrsConcept?> fetchConceptByUuid(String uuid) {
    return UserPreferences().getSessionId().then((sessionId) {
      if (sessionId == null) {
        throw 'Authentication Failure';
      }
      return http.get(
        Uri.parse('${AppUrls.omrs.concept}/$uuid'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': 'JSESSIONID=$sessionId',
        },
      );
    }).then((response) {
      if (response.statusCode != 200) {
        throw 'Failed to fetch concept';
      }
      var responseJson = jsonDecode(response.body);
      return OmrsConcept.fromJson(responseJson);
    });
  }

}
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
    String url = AppUrls.emrApi.concept + '?limit=20&term=$term';
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
    String url = AppUrls.omrs.concept + '?q=$term&v=full';
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
    var completer = Completer<List<OmrsConcept>>();
    UserPreferences().getSessionId().then((sessionId) {
      if (sessionId == null) {
        completer.completeError('Authentication Failure');
      } else {
        String url = AppUrls.omrs.concept + '?q=$term&v=full';
        http.get(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Cookie': 'JSESSIONID=$sessionId',
          },
        ).then((response) {
          if (response.statusCode == 200) {
            var responseJson = jsonDecode(response.body);
            var resultList = responseJson['results'] ?? [];
            completer.complete(List<OmrsConcept>.from(
                resultList.map((v) => OmrsConcept.fromJson(v))));
          } else {
            completer.completeError('Failed to fetch concept');
          }
        });
      }
    });
    return completer.future;
  }

  Future<OmrsConcept?> getDiagnosisOrder() async {
    return _findConcept('Diagnosis Order');
  }

  Future<OmrsConcept?> getDiagnosisCertainty() async {
    return _findConcept('Diagnosis Certainty');
  }

  Future<OmrsConcept?> _findConcept(String term) async {
    var completer = Completer<OmrsConcept?>();
    _conceptsByName(term).then((list) {
      list.isNotEmpty ? completer.complete(list[0]) : completer.complete(null);
    });
    return completer.future;
  }

}
import 'dart:async';
import 'dart:convert';

import 'package:connect2bahmni/domain/models/dosage_instruction.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/bahmni_drug_order.dart';
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
  Future<List<OmrsConcept>> searchInvestigation(String term) async {
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
      throw 'Authentication Failure';
    }
    String url = '${AppUrls.omrs.concept}?q=$term&v=custom:(uuid,name,display,conceptClass:(uuid,name)';
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
      List<String> orderType = ['test','labtest','radiology','labset','procedure'];
      var resultList = responseJson['results'] ?? [];
      var list = List<OmrsConcept>.from(resultList.map((v) => OmrsConcept.fromJson(v)));
      return list.where((element) => orderType.contains(element.conceptClass?.name?.toLowerCase())).toList();
    } else {
      throw 'Failed to fetch Investigation';
    }
  }
  Future<List<DrugConcept>> searchMedication(String term) async {
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
      throw 'Authentication Failure';
    }
    String url = '${AppUrls.omrs.drug}?q=$term&s=ordered&v=custom:(uuid,strength,name,dosageForm,concept:(uuid,name,names:(name)))';
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
      var list = List<DrugConcept>.from(resultList.map((v) => DrugConcept.fromJson(v)));
      return list;
    } else {
      throw 'Failed to fetch Medication';
    }
  }
  Future<DoseAttributes> dosageInstruction() async{
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
      throw 'Authentication Failure';
    }
    String cacheKey = 'dosage_instructions';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(cacheKey)) {
      String? cachedData = prefs.getString(cacheKey);
      Map<String,dynamic>? resultList = jsonDecode(cachedData!) as Map<String,dynamic>;
      return DoseAttributes(details: resultList);
    }
    String url = AppUrls.omrs.dosageInstructions;
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
      var doseUnits = responseJson['doseUnits'];
      var routes = responseJson['routes'];
      var durationUnits = responseJson['durationUnits'];
      var dosingInstructions = responseJson['dosingInstructions'];
      var frequencies = responseJson['frequencies'];
      Map<String,dynamic> details = {};
      details.addAll({'doseUnits':doseUnits,'routes':routes,'durationUnits':durationUnits,'dosingInstructions':dosingInstructions,'frequencies':frequencies});
      await prefs.setString(cacheKey, jsonEncode(details));
      return DoseAttributes(details: details);
    } else {
      throw 'Failed to fetch Dosing Instructions';
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

import 'dart:convert';

import 'package:http/http.dart';
import '../utils/app_urls.dart';
import '../utils/shared_preference.dart';
import '../domain/models/bahmni_drug_order.dart';
import 'domain_service.dart';

class DrugOrders extends DomainService {
  Future<List<BahmniDrugOrder>> fetch(String patientUuid) {
    return UserPreferences().getSessionId().then((sessionId) {
      if (sessionId == null) {
        throw 'Authentication Failure';
      }
      String url = '${AppUrls.bahmni
          .drugOrders}?includeActiveVisit=true&numberOfVisits=10&patientUuid=$patientUuid';
      return get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': 'JSESSIONID=$sessionId',
      });
    }).then((response) {
        if (response.statusCode == 200) {
          var responseJson = jsonDecode(response.body);
          if (responseJson is List) {
            return responseJson.map((e) => BahmniDrugOrder.fromJson(e)).toList();
          } else {
            return [];
          }
        } else {
          throw handleErrorResponse(response);
        }
    });
  }

}
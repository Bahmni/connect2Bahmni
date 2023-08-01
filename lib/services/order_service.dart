import 'dart:convert';

import 'package:http/http.dart';
import '../domain/models/lab_result.dart';
import '../services/domain_service.dart';
import '../utils/app_urls.dart';
import '../utils/shared_preference.dart';

class OrderService extends DomainService {
  Future<List<LabResult>> fetch(String patientUuid) {
    return UserPreferences().getSessionId().then((sessionId) {
      if (sessionId == null) {
        throw 'Authentication Failure';
      }
      String url = '${AppUrls.bahmni.labOrderResults}?numberOfVisits=10&patientUuid=$patientUuid';
      return get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': 'JSESSIONID=$sessionId',
      });
    }).then((response) {
      if (response.statusCode == 200) {
        var responseJson = jsonDecode(response.body);
        var orders = responseJson['tabularResult']['orders'];
        var values = responseJson['tabularResult']['values'];
        var dateGroups = responseJson['tabularResult']['dates'];

        List<LabResult> labResults = (orders as List).map((json) {
          return LabResult(
            index: json['index'],
            name: json['testName'],
            uom: json['testUnitOfMeasurement'],
            minNormal: json['minNormal'],
            maxNormal: json['maxNormal'],
          );
        }).toList();

        for (var value in (values as List)) {
          var testOrderIndex = value['testOrderIndex'] as int;
          var orderResult = labResults.firstWhere((element) => element.index == testOrderIndex);
          orderResult.abnormal = value['abnormal'];
          orderResult.referredOut = value['referredOut'];
          orderResult.accessionDateTime = _dateFromInt(value['accessionDateTime'] as int?);
          orderResult.result = value['result'];
          orderResult.uploadedFileName = value['uploadedFileName'];
          var dateIndex = value['dateIndex'] as int;
          var dateGrp = (dateGroups as List).firstWhere((element) => element['index'] == dateIndex);
          orderResult.orderDate = dateGrp['date'] as String?;
        }
        return labResults;
      } else {
        throw handleErrorResponse(response);
      }
    });
  }

  static DateTime? _dateFromInt(int? timestamp) {
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
}
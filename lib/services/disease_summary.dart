import 'dart:convert';

import 'package:http/http.dart';

import '../services/domain_service.dart';
import '../utils/app_urls.dart';
import '../utils/shared_preference.dart';


class DiseaseSummaryService extends DomainService {

  Future<ObsFlowSheet> fetch(String patientUuid, List<String> conceptNames) async {
    return UserPreferences().getSessionId().then((sessionId) {
      if (sessionId == null) {
        throw 'Authentication Failure';
      }
      String url = '${AppUrls.bahmni.diseaseSummary}?patientUuid=$patientUuid&groupBy=encounters&numberOfVisits=10${conceptNames.map((e) => 'obsConcepts=${e.trim()}').join('&')}';
      return get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': 'JSESSIONID=$sessionId',
      });
    }).then((response) {
      if (response.statusCode == 200) {
        var responseJson = jsonDecode(response.body);
        var concepts = responseJson['conceptDetails'];
        var dateGroups = responseJson['tabularData'];
        List<DateTime> obsDates = [];
        Map<String, List<ObsData>> conceptsMap = Map.fromEntries((concepts as List).map((json) => MapEntry(json['name'], [])));
        dateGroups.forEach((dateStr, data) {
          var obsDate = DateTime.parse(dateStr as String);
          obsDates.add(obsDate);
          (data as Map).forEach((name, obs) {
            var conceptName = (name as String);
            var values = conceptsMap[conceptName];
            values?.add(ObsData(
              dateTime: obsDate,
              value: obs['value'],
              abnormal: obs['abnormal'],
            ));
          });
        });
        ObsFlowSheet obsFlowSheet = ObsFlowSheet(dates: obsDates, conceptsDataMap: conceptsMap);
        return obsFlowSheet;
      } else {
        throw handleErrorResponse(response);
      }
    });
  }
}

class ObsFlowSheet {
  List<DateTime>? dates;
  Map<String, List<ObsData>>? conceptsDataMap;
  ObsFlowSheet({this.dates, this.conceptsDataMap});
}

class ObsData {
  dynamic value;
  bool? abnormal;
  DateTime? dateTime;
  ObsData({this.value, this.abnormal, this.dateTime});
}


import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import '../utils/app_urls.dart';
import '../utils/shared_preference.dart';
import '../../domain/models/oms_visit.dart';

class Visits {
  Future<List<OmrsVisit>> visitsForPatient(String patientUuid, [bool includeInactive = true]) async {
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
      throw 'Authentication Failure';
    }
    String url = '${AppUrls.omrs.visit}?patient=$patientUuid&includeInactive=$includeInactive&v=full';
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

  Future<OmrsVisit> startVisit(String patientUuid, String visitTypeUuid) async {
    var session = await UserPreferences().getSession();
    if (session?.sessionId == null) {
      throw 'Authentication Failure';
    }
    if (session?.sessionLocation == null) {
      throw 'Can not identify current location';
    }
    Response response = await post(
      Uri.parse(AppUrls.omrs.visit),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': 'JSESSIONID=${session!.sessionId}',
      },
      body: jsonEncode(<String, String>{
        'patient': patientUuid,
        'visitType': visitTypeUuid,
        'location': session.sessionLocation!.uuid,
      }),
    );

    if ([200, 201].contains (response.statusCode)){
      return OmrsVisit.fromJson(jsonDecode(response.body));
    } else {
      throw 'Failed to start Visit';
    }
  }
}
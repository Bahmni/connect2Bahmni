
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../domain/models/omrs_obs.dart';
import '../utils/shared_preference.dart';
import '../utils/app_urls.dart';

class PatientObs {

  Future<List<OmrsObs>> patientObservations(String patientUuid, String conceptUuid) async {
    String? _sessionId = await UserPreferences().getSessionId();
    _sessionId ?? { throw 'Authentication Failure' };
    String _customRep =
        'custom:(uuid,display,concept,obsDatetime,comment,location:(uuid,name),value,encounter:(uuid,encounterDatetime,encounterType,encounterProviders,location:(uuid,name),patient:(uuid,display))';
    String url = '${AppUrls.omrs.obs}/obs?patient=$patientUuid&concept=$conceptUuid&v=$_customRep';
    var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': 'JSESSIONID=$_sessionId',
        },
    );

    if (response.statusCode != 200) {
      throw response.statusCode;
    }
    var responseJson = jsonDecode(response.body);
    var resultList = responseJson['results'] ?? [];
    return List<OmrsObs>.from(resultList.map((v) => OmrsObs.fromJson(v)));
  }
}
import 'dart:convert';

import 'package:fhir/r4.dart';
import 'package:http/http.dart';
import '../services/fhir_service.dart';
import '../utils/app_urls.dart';
import '../domain/models/omrs_location.dart';
import '../utils/shared_preference.dart';

class Locations {
  /// This currently fails because FHIR module sends provenance resources as well
  /// and  provenance.target which is a mandatory field is not passed
  Future<List<Location>> allLoginLocations() async {
    String url = AppUrls.fhir.location + '?_tag=Login Location';
    var result = await FhirInterface().fetch(url);
    return result.entry != null ? List<Location>.from(result.entry!.map((e) => e.resource)) : [];
  }

  Future<List<OmrsLocation>> allOmrsLoginLocations() async {
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
      throw 'Authentication Failure';
    }
    String url = AppUrls.omrs.location + '?tag=Login Location&v=custom:(uuid,name)';
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
      var locations = List<OmrsLocation>.from(resultList.map((loc) {
        return OmrsLocation.fromJson(loc);
      }));
      return locations;
    } else {
      throw 'Failed to fetch locations';
    }
  }


}
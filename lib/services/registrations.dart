import 'dart:convert';
import 'package:http/http.dart';

import '../screens/models/profile_model.dart';
import '/services/domain_service.dart';
import '../utils/app_urls.dart';
import '../utils/shared_preference.dart';

class Registrations extends DomainService {
  Future<ProfileModel> getPatientProfile(String patientUuid) async {
    return UserPreferences().getSessionId().then((sessionId) {
      if (sessionId == null) {
        throw 'Authentication Failure';
      }
      return get(
        Uri.parse('${AppUrls.bahmni.fetchProfile}/$patientUuid?v=full'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': 'JSESSIONID=$sessionId',
        },
      );
    }).then((response) {
      if (response.statusCode != 200) {
        throw handleErrorResponse(response);
      }
      var responseJson = jsonDecode(response.body);
      return responseJson;
    }).then((value) => ProfileModel.fromProfileJson(value));
  }

  Future<ProfileModel> createPatient(ProfileModel profile) async {
    var profileJson = profile.toProfileJson();
    return UserPreferences().getSessionId().then((sessionId) {
      if (sessionId == null) {
        throw 'Authentication Failure';
      }
      return post(
        Uri.parse(AppUrls.bahmni.profile),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': 'JSESSIONID=$sessionId',
        },
        body: jsonEncode(profileJson),
      );
    }).then((response) {
      if (response.statusCode != 200) {
        throw handleErrorResponse(response);
      }
      var responseJson = jsonDecode(response.body);
      return ProfileModel.fromProfileJson(responseJson);
    });
  }
}
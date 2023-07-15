import 'dart:convert';

import 'package:connect2bahmni/domain/models/form_definition.dart';
import 'package:http/http.dart';

import '../utils/app_urls.dart';
import '../utils/shared_preference.dart';
import 'domain_service.dart';

class BahmniForms extends DomainService {
  Future<FormResource> fetch(String formUuid) {
    return UserPreferences().getSessionId().then((sessionId) {
      if (sessionId == null) {
        throw 'Authentication Failure';
      }
      String url = '${AppUrls.omrs.forms}/$formUuid?v=custom:(id,uuid,name,version,published,resources:(value,uuid))';
      return get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': 'JSESSIONID=$sessionId',
      }).then((response) {
        if (response.statusCode == 200) {
          var responseJson = jsonDecode(response.body);
          return FormResource.fromJson(responseJson);
        } else {
          throw handleErrorResponse(response);
        }
      });
    });
  }

  Future<List<FormResource>> published() {
    return UserPreferences().getSessionId().then((sessionId) {
      if (sessionId == null) {
        throw 'Authentication Failure';
      }
      return get(Uri.parse(AppUrls.bahmni.publishedForms), headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': 'JSESSIONID=$sessionId',
      }).then((response) {
        if (response.statusCode == 200) {
          var responseJson = jsonDecode(response.body);
          if (responseJson is List) {
            return responseJson.map((e) => FormResource.fromJson(e)).toList();
          } else {
            return [];
          }
        } else {
          throw 'Failed to fetch published Forms';
        }
      });
    });
  }
}
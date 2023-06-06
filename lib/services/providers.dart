import 'dart:core';
import 'package:http/http.dart';

import 'package:fhir/r4.dart';
import 'dart:convert';

import '../domain/models/omrs_provider.dart';
import '../utils/app_urls.dart';
import '../utils/app_failures.dart';

class Providers {
  Future<Practitioner?> practitionerByUserId(String uuid, Future<String?> Function() fetchSessionId) async {
    String url = '${AppUrls.omrs.provider}?user=$uuid&v=custom:(uuid,identifier,attributes)';
    String? sessionId = await fetchSessionId();
    if (sessionId == null) {
      throw Failure('Session expired.', 401);
    }

    Response response = await get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': 'JSESSIONID=$sessionId',
      },
    );

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      var resultList = responseJson['results'] ?? [];
      var providerList = List<Practitioner>.from(resultList.map((prov) {
        return fromOmrsProvider(prov);
      }));
      return providerList.isNotEmpty ? providerList.first : null;
    } else {
      throw Failure('Error on server', response.statusCode);
    }
  }

  Future<OmrsProvider?> omrsProviderForUser(String uuid, Future<String?> Function() fetchSessionId) async {
    String url = '${AppUrls.omrs.provider}?user=$uuid&v=custom:(uuid,identifier,attributes)';
    String? sessionId = await fetchSessionId();
    if (sessionId == null) {
      throw Failure('Session expired.', 401);
    }

    Response response = await get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': 'JSESSIONID=$sessionId',
      },
    );

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      var resultList = responseJson['results'] ?? [];
      var providerList = List<OmrsProvider>.from(resultList.map((model) {
        return OmrsProvider.fromJson(model);
      }));
      return providerList.isNotEmpty ? providerList.first : null;
    } else {
      throw Failure('Error on server', response.statusCode);
    }
  }

  Practitioner fromOmrsProvider(providerJson) {
    return Practitioner(fhirId: providerJson['uuid'],
        identifier: [Identifier(system: FhirUri(AppUrls.omrs.provider), value: providerJson['identifier'])],
    );
  }

}
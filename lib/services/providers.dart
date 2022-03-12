import 'dart:core';
import 'package:http/http.dart';

import 'package:fhir/r4.dart';
import 'dart:convert';

import '../domain/models/omrs_provider.dart';
import '../services/fhir_service.dart';
import '../utils/app_urls.dart';

class Providers {
  Future<Map<String, dynamic>> practitionerByUserId(String uuid, Future<String?> Function() fetchSessionId) async {
    String url = AppUrls.omrs.provider + '?user=$uuid&v=custom:(uuid,identifier,attributes)';
    String? sessionId = await fetchSessionId();
    if (sessionId == null) {
      return {
        'status': false,
        'result': null,
        'message': 'session expired',
      };
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
      if (providerList.isNotEmpty) {
        return {
          'status': true,
          'result': providerList.first,
          'message': 'success',
        };
      }
    }

    return {
      'status': false,
      'result': null,
      'message': 'error on server',
    };
  }

  Future<Map<String, dynamic>> omrsProviderbyUserId(String uuid, Future<String?> Function() fetchSessionId) async {
    String url = AppUrls.omrs.provider + '?user=$uuid&v=custom:(uuid,identifier,attributes)';
    String? sessionId = await fetchSessionId();
    if (sessionId == null) {
      return {
        'status': false,
        'result': null,
        'message': 'session expired',
      };
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
      if (providerList.isNotEmpty) {
        return {
          'status': true,
          'result': providerList.first,
          'message': 'success',
        };
      }
    }

    return {
      'status': false,
      'result': null,
      'message': 'error on server',
    };
  }

  Practitioner fromOmrsProvider(providerJson) {
    return Practitioner(id: Id(providerJson['uuid']),
        identifier: [Identifier(system: FhirUri(AppUrls.omrs.provider), value: providerJson['identifier'])],
    );
  }

}
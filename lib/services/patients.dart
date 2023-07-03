import 'dart:convert';
import 'package:connect2bahmni/domain/models/omrs_identifier_type.dart';
import 'package:connect2bahmni/domain/models/omrs_person_attribute.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:fhir/r4.dart';

import '../domain/models/omrs_patient.dart';

import '../utils/app_urls.dart';
import '../utils/app_config.dart';
import '../utils/model_extn.dart';
import 'domain_service.dart';
import 'fhir_service.dart';
import '../utils/shared_preference.dart';

class Patients extends DomainService {
  Future<Bundle> searchByName(String name) async {
    String url = '${AppUrls.fhir.patient}?name=$name';
    return FhirInterface().fetch(url);
  }

  Future<Bundle> getActivePatients() async {
    var session = await UserPreferences().getSession();
    if (session?.sessionId == null) {
      throw 'Authentication Failure';
    }

    if (session?.sessionLocation == null) {
      throw 'Can not identify current location';
    }
    String url = '${AppUrls.bahmni.activePatients.replaceAll("VISIT_LOCATION", session!.sessionLocation!.uuid)}&provider_uuid=${session.currentProvider?.uuid}';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': 'JSESSIONID=${session.sessionId}',
      },
    );

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      if (responseJson != null && responseJson is List) {
        var patients = responseJson.map((p) =>
          Patient(
            name: [HumanName(given:  [p['name']])],
            identifier: [Identifier(value: p['identifier'])],
            birthDate: FhirDate.fromDateTime(DateTime.fromMillisecondsSinceEpoch(p['birthdate'] as int)),
            gender: FhirCode(_getGenderCode(p['gender'])),
          )).toList();
        Bundle bundle = Bundle(
          entry: patients.map((p) => BundleEntry(resource: p)).toList()
        );
        return bundle;
      }
      return Bundle();
    } else {
      throw 'Failed to fetch locations';
    }
  }

  String _getGenderCode(String gender) {
    return gender == 'M' ? 'male' : 'female';
  }

  Future<List<OmrsPatient>?> searchOmrsByName(String name) async {
    //TODO
    //v=custom:(uuid,identifiers:(uuid,identifier,identifierType:(uuid,name),location),person:(display,gender,birthdate))
    if (!AppConfig.fhirSupport) {

    }
    return Future.value(null);
  }

  Future<OmrsPatient?> withUuid(String uuid) async {
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
      throw 'Authentication Failure';
    }
    String url = '${AppUrls.omrs.patient}/$uuid?v=full';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': 'JSESSIONID=$sessionId',
      },
    );
    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      return OmrsPatient.fromJson(responseJson);
    } else {
      throw 'Could not fetch patient information';
    }
  }

  Future<Bundle> getDispensingPatients() async {
    var session = await UserPreferences().getSession();
    if (session?.sessionId == null) {
      throw 'Authentication Failure';
    }

    if (session?.sessionLocation == null) {
      throw 'Can not identify current location';
    }
    String url = AppUrls.bahmni.dispensingPatients.replaceAll("VISIT_LOCATION", session!.sessionLocation!.uuid);
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': 'JSESSIONID=${session.sessionId}',
      },
    );

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      if (responseJson != null && responseJson is List) {
        var patients = responseJson.map((p) {
          return Patient(
              name: [HumanName(given:  [p['name']])],
              identifier: [Identifier(value: p['identifier'])],
              birthDate: FhirDate.fromDateTime(DateTime.fromMillisecondsSinceEpoch(p['birthdate'] as int)),
              gender: FhirCode(_getGenderCode(p['gender'])),
              extension_: p['drugOrderIds'] != null ? [
                FhirExtension(
                  url: FhirUri(ModelExtensions.patientVisitDrugOrderIds),
                  valueString: p['drugOrderIds'],
                )
              ] : [],
            );
        }).toList();
        Bundle bundle = Bundle(
            entry: patients.map((p) => BundleEntry(resource: p)).toList()
        );
        return bundle;
      }
      return Bundle();
    } else {
      throw 'Failed to fetch locations';
    }
  }

  Future<List<OmrsIdentifierType>> identifierTypes() async {
    return UserPreferences().getSessionId().then((sessionId) {
      if (sessionId == null) {
        throw 'Authentication Failure';
      }
      return http.get(
        Uri.parse(AppUrls.omrs.patientIdentifierTypes),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': 'JSESSIONID=$sessionId',
        },
      );
    }).then((response) {
      if (response.statusCode != 200) {
        throw 'Failed to fetch patient identifier types';
      }
      var responseJson = jsonDecode(response.body);
      return List<OmrsIdentifierType>.from(responseJson.map((v) => OmrsIdentifierType.fromJson(v)));
    });
  }

  Future<List<OmrsPersonAttributeType>> attributeTypes() async {
    return UserPreferences().getSessionId().then((sessionId) {
      if (sessionId == null) {
        throw 'Authentication Failure';
      }
      return http.get(
        Uri.parse(AppUrls.omrs.personAttrTypes),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': 'JSESSIONID=$sessionId',
        },
      );
    }).then((response) {
      if (response.statusCode != 200) {
        throw 'Failed to fetch patient identifier types';
      }
      var responseJson = jsonDecode(response.body);
      var resultList = responseJson['results'] ?? [];
      return List<OmrsPersonAttributeType>.from(resultList.map((v) => OmrsPersonAttributeType.fromJson(v)));
    });
  }

  Future<Map<String, dynamic>> createPatient(Map<String, Object?> patientProfileJson) async {
    return UserPreferences().getSessionId().then((sessionId) {
      if (sessionId == null) {
        throw 'Authentication Failure';
      }
      return http.post(
        Uri.parse(AppUrls.bahmni.profile),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': 'JSESSIONID=$sessionId',
        },
        body: jsonEncode(patientProfileJson),
      );
    }).then((response) {
      if (response.statusCode != 200) {
        handleErrorResponse(response);
        throw 'Failed to create patient';
      }
      var responseJson = jsonDecode(response.body);
      return responseJson;
    });
  }

  Future<Map<String, dynamic>> getPatientProfile(String patientUuid) async {
    return UserPreferences().getSessionId().then((sessionId) {
      if (sessionId == null) {
        throw 'Authentication Failure';
      }
      debugPrint('calling - ${AppUrls.bahmni.fetchProfile}/$patientUuid?v=full');
      return http.get(
        Uri.parse('${AppUrls.bahmni.fetchProfile}/$patientUuid?v=full'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': 'JSESSIONID=$sessionId',
        },
      );
    }).then((response) {
      if (response.statusCode != 200) {
        handleErrorResponse(response);
        throw 'Failed to fetch patient profile';
      }
      var responseJson = jsonDecode(response.body);
      return responseJson;
    });
  }

}
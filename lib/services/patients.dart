import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fhir/r4.dart';

import '../domain/models/common.dart';
import '../domain/models/omrs_patient.dart';
import '../domain/models/omrs_identifier_type.dart';
import '../domain/models/omrs_person_attribute.dart';
import '../utils/app_urls.dart';
import '../utils/app_config.dart';
import '../utils/model_extn.dart';
import '../utils/shared_preference.dart';
import 'domain_service.dart';
import 'fhir_service.dart';

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
            fhirId: p['uuid'],
            name: [HumanName(given:  [p['name']])],
            identifier: [Identifier(value: p['identifier'])],
            birthDate: p['birthdate'] != null ? FhirDate.fromDateTime(DateTime.fromMillisecondsSinceEpoch(p['birthdate'] as int)) : null,
            gender: p['gender'] != null ? FhirCode(_getGenderCode(p['gender'])) : null,
          )).toList();
        Bundle bundle = Bundle(
          entry: patients.map((p) => BundleEntry(resource: p)).toList()
        );
        return bundle;
      }
      return Bundle();
    } else {
      throw handleErrorResponse(response);
    }
  }

  String? _getGenderCode(String? gender) {
    if (gender == null) {
      return null;
    }
    return fromGenderPrefix(gender)?.name;
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
      throw handleErrorResponse(response);
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
          int? timestamp = p['birthdate'] as int?;
          FhirDate? dob = timestamp != null ? FhirDate.fromDateTime(DateTime.fromMillisecondsSinceEpoch(timestamp)) : null;
          String? genderCode = _getGenderCode(p['gender'] as String?);
          List<FhirExtension> extensions = [];
          if (p['drugOrderIds'] != null) {
            extensions.add(FhirExtension(
              url: FhirUri(ModelExtensions.patientVisitDrugOrderIds),
              valueString: p['drugOrderIds'],
            ));
          }
          if (p['activeVisitUuid'] != null) {
            extensions.add(FhirExtension(
              url: FhirUri(ModelExtensions.patientActiveVisitId),
              valueString: p['activeVisitUuid'],
            ));
          }
          return Patient(
              fhirId: p['uuid'],
              name: [HumanName(given:  [p['name']])],
              identifier: [Identifier(value: p['identifier'])],
              birthDate: dob,
              gender: genderCode != null ? FhirCode(genderCode) : null,
              extension_: extensions,
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

}
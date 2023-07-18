import 'package:connect2bahmni/utils/model_extn.dart';
import 'package:fhir/r4.dart';
import '../../utils/date_time.dart';
import 'person_age.dart';

class PatientModel {
  Patient _patient = Patient();
  final _genderMap = {
    'male':'M',
    'female':'F'
  };
  PatientModel(Patient patient) {
    _patient = patient;
  }

  String get uuid {
    return _patient.fhirId ?? '';
  }

  String get fullName {
    String fullName = '';
    if (_patient.name != null) {
      List<String>? names = _patient.name?.first.given;
      if (names != null) {
        fullName = names.join(' ');
      }
      String? lastName = _patient.name?.first.family;
      if (lastName != null) {
        fullName = '$fullName $lastName';
      }
    }
    return fullName;
  }

  String get genderAndAge {
    String result = _patient.gender?.value ?? '';
    String strAge = '';
    DateTime? dob = _patient.birthDate?.valueDateTime;
    if (dob != null) {
      PersonAge age = calculateAge(dob);
      strAge = age.year != 0 ? '${age.year}y ${age.month}m' : '${age.month}m ${age.days}d';
    }
    return '${_genderMap[result] ?? ''}, $strAge' ;
  }

  String get location {
    Address address = _patient.address?.first ?? Address();
    return address.city ?? (address.state ?? '');
  }

  String get minimalInfo {
    return '$identifier, $genderAndAge,  $location';
  }

  String? get identifier {
    return _patient.identifier?.first.value;
  }

  Patient toFhirPatient() {
    return _patient;
  }

  String? getVisitDrugIds() {
    var visitDrugOrderIds = _patient.extension_?.where((element) => element.url.toString() == ModelExtensions.patientVisitDrugOrderIds).first;
    return visitDrugOrderIds != null ? (visitDrugOrderIds.valueString ?? '') : '';
  }

}

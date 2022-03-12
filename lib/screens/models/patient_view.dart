import 'package:fhir/r4.dart';
import '../../utils/date_time.dart';
import 'person_age.dart';

class PatientViewModel {
  Patient _patient = Patient();
  final _genderMap = {
    'male':'M',
    'female':'F'
  };
  PatientViewModel(Patient patient) {
    _patient = patient;
  }

  String get uuid {
    return _patient.id?.value ?? '';
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
        fullName = fullName + ' ' + lastName;
      }
    }
    return fullName;
  }

  String get genderAndAge {
    String result = _patient.gender?.name ?? '';
    DateTime dob = _patient.birthDate?.valueDateTime ?? DateTime.now();
    PersonAge age = calculateAge(dob);
    String strAge = age.year != 0 ? '${age.year}y ${age.month}m' : '${age.month}m ${age.days}d';
    return (_genderMap[result] ?? '') + ', $strAge' ;
  }

  String get location {
    Address address = _patient.address?.first ?? Address();
    return address.city ?? (address.state ?? '');
  }

  String get minimalInfo {
    return '$genderAndAge,  $location';
  }

}

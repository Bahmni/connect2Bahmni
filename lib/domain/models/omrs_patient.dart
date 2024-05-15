import 'package:fhir/r4.dart' as fhir;
import 'package:json_annotation/json_annotation.dart';
import '../../domain/models/person.dart';
import '../../domain/models/omrs_identifier.dart';
import '../../utils/date_time.dart';
part 'omrs_patient.g.dart';

@JsonSerializable()
class OmrsPatient {
  String? uuid;
  String? display;
  List<OmrsIdentifier>? identifiers;
  Person? person;

  OmrsPatient({this.uuid, this.display, this.identifiers, this.person});
  factory OmrsPatient.fromJson(Map<String, dynamic> json) => _$OmrsPatientFromJson(json);
  Map<String, dynamic> toJson() => _$OmrsPatientToJson(this);

  fhir.Patient toFhir() {
    return fhir.Patient(
      fhirId: uuid,
      name: _humanName(),
      birthDate: _birthDate(),
      address: _address(),
      identifier: _identifiers()
    );
  }

  List<fhir.HumanName>? _humanName() {
    var name = person?.humanName;
    return name != null ? [name] : null;
  }

  fhir.FhirDate? _birthDate() {
    var dt = person?.birthdate;
    return dt != null ? toFhirDate(dt) : null;
  }

  _address() {
     var prefAdrr = person?.address;
     return prefAdrr != null ? [prefAdrr] : null;
  }

  List<fhir.Identifier>? _identifiers() {
    return identifiers?.map((e) {
      return fhir.Identifier(
        fhirId: e.uuid,
        type: fhir.CodeableConcept(
          text: e.identifierType.name
        ),
        value: e.identifier
      );
    }).toList();
  }
}
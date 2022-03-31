import 'package:json_annotation/json_annotation.dart';
import '../../domain/models/person.dart';
import '../../domain/models/omrs_identifier.dart';
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
}
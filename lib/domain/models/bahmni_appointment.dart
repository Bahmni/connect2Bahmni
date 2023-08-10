import 'package:json_annotation/json_annotation.dart';
part 'bahmni_appointment.g.dart';

@JsonSerializable()
class BahmniAppointment {
  final String? uuid;
  final String? appointmentNumber;
  final Subject patient;
  final ServiceLocation? location;
  final AppointmentService? service;

  final String? status;
  final bool? voided;
  final bool? teleconsultation;
  final bool? recurring;
  final String? teleconsultationLink;
  final String? comments;

  @JsonKey(fromJson: _fromJsonDateTime)
  final DateTime? startDateTime;
  @JsonKey(fromJson: _fromJsonDateTime)
  final DateTime? endDateTime;
  final List<AppointmentProviderDetail>? providers;

  BahmniAppointment({
    this.uuid,
    this.appointmentNumber,
    required this.patient,
    this.service,
    this.location,
    this.status,
    this.voided,
    this.teleconsultation,
    this.recurring,
    this.teleconsultationLink,
    this.comments,
    this.startDateTime,
    this.endDateTime,
    this.providers
  });
  factory BahmniAppointment.fromJson(Map<String, dynamic> json) => _$BahmniAppointmentFromJson(json);
  Map<String, dynamic> toJson() => _$BahmniAppointmentToJson(this);

  static DateTime _fromJsonDateTime(int int) => DateTime.fromMillisecondsSinceEpoch(int);
  // ignore: unused_element
  static int _toJsonDateTime(DateTime time) => time.millisecondsSinceEpoch;
}

@JsonSerializable()
class Subject {
  final String identifier;
  final String name;
  final String uuid;
  Subject({required this.uuid, required this.identifier, required this.name});
  factory Subject.fromJson(Map<String, dynamic> json) => _$SubjectFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectToJson(this);
}

@JsonSerializable()
class AppointmentService {
  final String? uuid;
  final String? name;
  final ServiceSpeciality? speciality;
  final String? startTime;
  final String? endTime;
  AppointmentService({this.uuid, this.name, this.speciality, this.startTime, this.endTime});
  factory AppointmentService.fromJson(Map<String, dynamic> json) => _$AppointmentServiceFromJson(json);
  Map<String, dynamic> toJson() => _$AppointmentServiceToJson(this);

}

@JsonSerializable()
class ServiceSpeciality {
  final String uuid;
  final String name;

  ServiceSpeciality({required this.uuid, required this.name});
  factory ServiceSpeciality.fromJson(Map<String, dynamic> json) => _$ServiceSpecialityFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceSpecialityToJson(this);
}

@JsonSerializable()
class ServiceLocation {
  final String uuid;
  final String? name;
  ServiceLocation({required this.uuid, this.name});
  factory ServiceLocation.fromJson(Map<String, dynamic> json) => _$ServiceLocationFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceLocationToJson(this);
}

@JsonSerializable()
class AppointmentProviderDetail {
  final String? uuid;
  final String? name;
  final String? response;
  final String? comments;

  AppointmentProviderDetail({this.uuid, this.name, this.response, this.comments});
  factory AppointmentProviderDetail.fromJson(Map<String, dynamic> json) => _$AppointmentProviderDetailFromJson(json);
  Map<String, dynamic> toJson() => _$AppointmentProviderDetailToJson(this);
}


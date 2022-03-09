// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bahmni_appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BahmniAppointment _$BahmniAppointmentFromJson(Map<String, dynamic> json) =>
    BahmniAppointment(
      uuid: json['uuid'] as String?,
      appointmentNumber: json['appointmentNumber'] as String?,
      patient: Subject.fromJson(json['patient'] as Map<String, dynamic>),
      service: json['service'] == null
          ? null
          : AppointmentService.fromJson(
              json['service'] as Map<String, dynamic>),
      location: json['location'] == null
          ? null
          : ServiceLocation.fromJson(json['location'] as Map<String, dynamic>),
      status: json['status'] as String?,
      voided: json['voided'] as bool?,
      teleconsultation: json['teleconsultation'] as bool?,
      recurring: json['recurring'] as bool?,
      teleconsultationLink: json['teleconsultationLink'] as String?,
      comments: json['comments'] as String?,
      startDateTime:
          BahmniAppointment._fromJsonDateTime(json['startDateTime'] as int),
      endDateTime:
          BahmniAppointment._fromJsonDateTime(json['endDateTime'] as int),
    );

Map<String, dynamic> _$BahmniAppointmentToJson(BahmniAppointment instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'appointmentNumber': instance.appointmentNumber,
      'patient': instance.patient,
      'location': instance.location,
      'service': instance.service,
      'status': instance.status,
      'voided': instance.voided,
      'teleconsultation': instance.teleconsultation,
      'recurring': instance.recurring,
      'teleconsultationLink': instance.teleconsultationLink,
      'comments': instance.comments,
      'startDateTime': instance.startDateTime?.toIso8601String(),
      'endDateTime': instance.endDateTime?.toIso8601String(),
    };

Subject _$SubjectFromJson(Map<String, dynamic> json) => Subject(
      uuid: json['uuid'] as String,
      identifier: json['identifier'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$SubjectToJson(Subject instance) => <String, dynamic>{
      'identifier': instance.identifier,
      'name': instance.name,
      'uuid': instance.uuid,
    };

AppointmentService _$AppointmentServiceFromJson(Map<String, dynamic> json) =>
    AppointmentService(
      uuid: json['uuid'] as String,
      name: json['name'] as String?,
      speciality: json['speciality'] == null
          ? null
          : ServiceSpeciality.fromJson(
              json['speciality'] as Map<String, dynamic>),
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
    );

Map<String, dynamic> _$AppointmentServiceToJson(AppointmentService instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'speciality': instance.speciality,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };

ServiceSpeciality _$ServiceSpecialityFromJson(Map<String, dynamic> json) =>
    ServiceSpeciality(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ServiceSpecialityToJson(ServiceSpeciality instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
    };

ServiceLocation _$ServiceLocationFromJson(Map<String, dynamic> json) =>
    ServiceLocation(
      uuid: json['uuid'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ServiceLocationToJson(ServiceLocation instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
    };

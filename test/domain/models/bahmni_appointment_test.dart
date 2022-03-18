import 'dart:convert';

import 'package:connect2bahmni/domain/models/bahmni_appointment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Bahmni Appointment model serialization test', () {
    var appointment = BahmniAppointment.fromJson({
      "uuid": "d37f9bb8-f212-4f97-9c3b-ce1ba53b26a6",
      "appointmentNumber": "0000",
      "patient": {
        "identifier": "GAN203007",
        "name": "Anshul test one",
        "uuid": "19afbfba-8508-4ae4-a8d5-526da60be82f"
      },
      "service": {
        "appointmentServiceId": 1,
        "name": "GP",
        "description": null,
        "speciality": {
          "name": "Internal Medicine",
          "uuid": "d7f30e91-5bb0-11eb-a534-025d983c9330"
        },
        "startTime": "09:00:00",
        "endTime": "14:00:00",
        "maxAppointmentsLimit": 30,
        "durationMins": 10,
        "location": {
          "name": "OPD-1",
          "uuid": "c58e12ed-3f12-11e4-adec-0800271c1b75"
        },
        "uuid": "bd857129-49dc-4536-bb87-7133cbcce328",
        "color": "#006400",
        "initialAppointmentStatus": null,
        "creatorName": null
      },
      "serviceType": null,
      "provider": null,
      "location": {
        "name": "OPD-1",
        "uuid": "c58e12ed-3f12-11e4-adec-0800271c1b75"
      },
      "startDateTime": 1646407800000,
      "endDateTime": 1646408400000,
      "appointmentKind": "Scheduled",
      "status": "Scheduled",
      "comments": null,
      "additionalInfo": null,
      "teleconsultation": null,
      "providers": [
        {
          "uuid": "95fc0b16-eb92-4332-a105-ec5aa6df6cc5",
          "comments": null,
          "response": "ACCEPTED",
          "name": "Kishore Jha"
        }
      ],
      "voided": false,
      "extensions": {
        "patientEmailDefined": false
      },
      "teleconsultationLink": null,
      "recurring": false
    });
    //print(jsonEncode(appointment.toJson()));
    expect(appointment.uuid, 'd37f9bb8-f212-4f97-9c3b-ce1ba53b26a6');
    expect(appointment.patient.toJson(), {
      "identifier": "GAN203007",
      "name": "Anshul test one",
      "uuid": "19afbfba-8508-4ae4-a8d5-526da60be82f"
    });
    expect(appointment.location!.toJson(), {
      "uuid": "c58e12ed-3f12-11e4-adec-0800271c1b75",
      "name": "OPD-1"
    });
    expect(jsonEncode(appointment.service!.toJson()), jsonEncode({
      "uuid": "bd857129-49dc-4536-bb87-7133cbcce328",
      "name": "GP",
      "speciality": {
        "uuid": "d7f30e91-5bb0-11eb-a534-025d983c9330",
        "name": "Internal Medicine"
      },
      "startTime": "09:00:00",
      "endTime": "14:00:00"
    }));
    expect(appointment.startDateTime, DateTime.parse("2022-03-04T21:00:00.000"));
    expect(appointment.endDateTime, DateTime.parse("2022-03-04T21:10:00.000"));
  });
}
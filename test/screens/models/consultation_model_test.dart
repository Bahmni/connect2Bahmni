
import 'package:connect2bahmni/domain/models/person.dart';
import 'package:connect2bahmni/domain/models/user.dart';
import 'package:connect2bahmni/screens/models/consultation_model.dart';
import 'package:connect2bahmni/screens/models/patient_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fhir/r4.dart' as r4;

void main() {
  test('adding patient initializes consultation', () {
    var user = User(
      uuid: 'userUuid1',
      username: 'Dr Who',
      person: Person(
        uuid: 'personUuid1',
        display: 'Dr Who'
      ) 
    );
    final consultation = ConsultationModel(user);
    expect(consultation.status, ConsultationStatus.none);
    consultation.initialize(
      PatientModel(
        const r4.Patient(name: [r4.HumanName(family: 'LastName', given: ['FirstName'])])
      ));
    expect(consultation.status, ConsultationStatus.draft);
  });
}


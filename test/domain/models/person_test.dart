import 'package:connect2bahmni/domain/models/person.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Person model serialization test', ()
  {
    final person = Person(
      uuid: '1', display: 'rutgar ragos',
      gender: 'M',
      birthdate: DateTime.parse('2000-02-26T00:00:00.000+0530')
    );
    expect(person.toJson(), {
      'uuid': '1',
      'display': 'rutgar ragos',
      'gender': 'M',
      'birthdate': '2000-02-25T18:30:00.000Z'
    });

    final Person p = Person.fromJson({
      "uuid": "f5f47931-c3b9-4a37-805d-273d97d305dc",
      "display": "Rutgar Ragos",
      "gender": "M",
      "age": 22,
      "birthdate": "2000-02-26T00:00:00.000+0530",
      "birthdateEstimated": false,
      "dead": false,
      "deathDate": null,
      "causeOfDeath": null
    });

    expect(p.toJson(), {
      'uuid': 'f5f47931-c3b9-4a37-805d-273d97d305dc',
      'display': 'Rutgar Ragos',
      'gender': 'M',
      'birthdate': '2000-02-25T18:30:00.000Z'
    });

    expect(p.birthdate, DateTime.parse('2000-02-25T18:30:00.000Z'));
  });
}
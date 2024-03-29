

import 'package:connect2bahmni/domain/models/omrs_patient.dart';
import 'package:connect2bahmni/domain/condition_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Diagnosis should deserialize as Condition', () {
    var condition = ConditionModel.fromPatientDiagnosis(OmrsPatient(uuid: 'test'), {
      "order": "SECONDARY",
      "certainty": "PRESUMED",
      "freeTextAnswer": "FTDT",
      "codedAnswer": null,
      "existingObs": "9eb33c68-1962-4215-abb3-e5618ae37d24",
      "diagnosisDateTime": "2022-04-07T23:17:00.000+0530",
      "voided": false,
      "voidReason": null,
      "comments": "Free text test",
      "providers": [
        {
          "uuid": "c1c26908-3f10-11e4-adec-0800271c1b75",
          "name": "Super Man",
          "encounterRoleUuid": "a0b03050-c99b-11e0-9572-0800200c9a66"
        }
      ],
      "diagnosisStatusConcept": null,
      "firstDiagnosis": {
        "order": "SECONDARY",
        "certainty": "PRESUMED",
        "freeTextAnswer": "FTDT",
        "codedAnswer": null,
        "existingObs": "9eb33c68-1962-4215-abb3-e5618ae37d24",
        "diagnosisDateTime": "2022-04-07T23:17:00.000+0530",
        "voided": false,
        "voidReason": null,
        "comments": "Free text test",
        "providers": [
          {
            "uuid": "c1c26908-3f10-11e4-adec-0800271c1b75",
            "name": "Super Man",
            "encounterRoleUuid": "a0b03050-c99b-11e0-9572-0800200c9a66"
          }
        ],
        "diagnosisStatusConcept": null,
        "firstDiagnosis": null,
        "latestDiagnosis": null,
        "revised": false,
        "previousObs": null,
        "encounterUuid": "a17e51af-4137-4c58-a35b-b47000a16dc8",
        "creatorName": "Super Man"
      },
      "latestDiagnosis": null,
      "revised": false,
      "previousObs": null,
      "encounterUuid": "a17e51af-4137-4c58-a35b-b47000a16dc8",
      "creatorName": "Super Man"
    });
    expect(condition.note, 'Free text test');
    expect(condition.code?.display, 'FTDT');
    expect(condition.code?.uuid, null);
    expect(condition.verificationStatus?.display, 'PRESUMED');
    expect(condition.verificationStatus?.uuid, null);
    expect(condition.order, ConditionOrder.secondary);
    expect(condition.id, '9eb33c68-1962-4215-abb3-e5618ae37d24'); //this is the obs group id
  });

  test('Diagnosis should deserialize as Condition if dateTime is int from epoch', () {
    var condition = ConditionModel.fromPatientDiagnosis(OmrsPatient(uuid: 'test'), {
      "order": "PRIMARY",
      "certainty": "PRESUMED",
      "freeTextAnswer": null,
      "codedAnswer": {
        "uuid": "132860AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
        "name": "Noninfectious Gastroenteritis",
        "dataType": "N/A",
        "shortName": "Noninfectious Gastroenteritis",
        "units": null,
        "conceptClass": "Diagnosis",
        "hiNormal": null,
        "lowNormal": null,
        "set": false,
        "mappings": [
          {
            "code": "K52.8",
            "name": null,
            "source": "ICD-10-WHO"
          },
          {
            "code": "10035218",
            "name": null,
            "source": "3BT"
          },
          {
            "code": "12574004",
            "name": null,
            "source": "SNOMED-CT"
          },
          {
            "code": "D99",
            "name": null,
            "source": "ICPC2"
          },
          {
            "code": "132860",
            "name": null,
            "source": "CIEL"
          },
          {
            "code": "8711",
            "name": null,
            "source": "IMO-ProblemIT"
          }
        ]
      },
      "existingObs": "76da6b2a-f353-4696-b376-fe3b6a669889",
      "diagnosisDateTime": 1673524051000,
      "voided": false,
      "voidReason": null,
      "comments": "",
      "providers": [
        {
          "uuid": "3eee098f-7bbc-11ed-807c-026601bd99d0",
          "name": "Super Man",
          "encounterRoleUuid": "a0b03050-c99b-11e0-9572-0800200c9a66"
        }
      ],
      "diagnosisStatusConcept": null,
      "firstDiagnosis": {
        "order": "PRIMARY",
        "certainty": "PRESUMED",
        "freeTextAnswer": null,
        "codedAnswer": {
          "uuid": "132860AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
          "name": "Noninfectious Gastroenteritis",
          "dataType": "N/A",
          "shortName": "Noninfectious Gastroenteritis",
          "units": null,
          "conceptClass": "Diagnosis",
          "hiNormal": null,
          "lowNormal": null,
          "set": false,
          "mappings": [
            {
              "code": "K52.8",
              "name": null,
              "source": "ICD-10-WHO"
            },
            {
              "code": "10035218",
              "name": null,
              "source": "3BT"
            },
            {
              "code": "12574004",
              "name": null,
              "source": "SNOMED-CT"
            },
            {
              "code": "D99",
              "name": null,
              "source": "ICPC2"
            },
            {
              "code": "132860",
              "name": null,
              "source": "CIEL"
            },
            {
              "code": "8711",
              "name": null,
              "source": "IMO-ProblemIT"
            }
          ]
        },
        "existingObs": "76da6b2a-f353-4696-b376-fe3b6a669889",
        "diagnosisDateTime": 1673524051000,
        "voided": false,
        "voidReason": null,
        "comments": "",
        "providers": [
          {
            "uuid": "3eee098f-7bbc-11ed-807c-026601bd99d0",
            "name": "Super Man",
            "encounterRoleUuid": "a0b03050-c99b-11e0-9572-0800200c9a66"
          }
        ],
        "diagnosisStatusConcept": null,
        "firstDiagnosis": null,
        "latestDiagnosis": null,
        "revised": false,
        "previousObs": null,
        "encounterUuid": "e38e8f35-5ad8-4a7e-949e-58877708d20b",
        "creatorName": "Super Man"
      },
      "latestDiagnosis": null,
      "revised": false,
      "previousObs": null,
      "encounterUuid": "e38e8f35-5ad8-4a7e-949e-58877708d20b",
      "creatorName": "Super Man"
    });
    expect(condition.note, '');
    expect(condition.code?.display, 'Noninfectious Gastroenteritis');
    expect(condition.code?.uuid, "132860AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    expect(condition.verificationStatus?.display, 'PRESUMED');
    expect(condition.verificationStatus?.uuid, null);
    expect(condition.order, ConditionOrder.primary);
    expect(condition.id, '76da6b2a-f353-4696-b376-fe3b6a669889'); //this is the obs group id
  });
}
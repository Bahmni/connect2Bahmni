
import 'package:connect2bahmni/domain/models/omrs_identifier_type.dart';
import 'package:connect2bahmni/domain/models/omrs_patient.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('deserialize primary identifier types with sources', () {
    var identifierType = OmrsIdentifierType.fromJson(
        {
          "uuid": "712c108d-00f2-11ee-bbc6-0242c0a86002",
          "name": "Patient Identifier",
          "description": "New patient identifier type created for use by the Bahmni Registration System",
          "format": null,
          "required": true,
          "primary": true,
          "identifierSources": [
            {
              "uuid": "c5cf4b68-6529-43fc-a644-c775ae73745e",
              "name": "ABC",
              "prefix": "ABC"
            }
          ]
        }
    );
    expect(identifierType.name, 'Patient Identifier');
    expect(identifierType.identifierSources!.length, 1);
  });

  test('deserialize other identifier without source', () {
      var identifierType = OmrsIdentifierType.fromJson(
          {
            "uuid": "77d2dd54-00f2-11ee-bbc6-0242c0a86002",
            "name": "ABHA Address",
            "description": "PHR Address identifier type",
            "format": null,
            "required": false,
            "primary": false,
            "identifierSources": [

            ]
          }
      );
      expect(identifierType.name, 'ABHA Address');
  });

  test('deserialize list of identifier types', () {
    var jsonList = [
      {
        "uuid": "712c108d-00f2-11ee-bbc6-0242c0a86002",
        "name": "Patient Identifier",
        "description": "New patient identifier type created for use by the Bahmni Registration System",
        "format": null,
        "required": true,
        "primary": true,
        "identifierSources": [
          {
            "uuid": "c5cf4b68-6529-43fc-a644-c775ae73745e",
            "name": "ABC",
            "prefix": "ABC"
          }
        ]
      },
      {
        "uuid": "77d2dd54-00f2-11ee-bbc6-0242c0a86002",
        "name": "ABHA Address",
        "description": "PHR Address identifier type",
        "format": null,
        "required": false,
        "primary": false,
        "identifierSources": [

        ]
      },
      {
        "uuid": "77ccbba2-00f2-11ee-bbc6-0242c0a86002",
        "name": "ABHA Number",
        "description": "Health Id identifier type",
        "format": null,
        "required": false,
        "primary": false,
        "identifierSources": [

        ]
      },
      {
        "uuid": "68490aec-35e8-49c8-893b-e7c70b322729",
        "name": "NIKSHAY_ID",
        "description": null,
        "format": null,
        "required": false,
        "primary": false,
        "identifierSources": [

        ]
      },
      {
        "uuid": "69321f53-ad9b-46c8-8b20-a1ec575bc21e",
        "name": "RCH_ID",
        "description": null,
        "format": null,
        "required": false,
        "primary": false,
        "identifierSources": [

        ]
      }
    ];
    var list = List<OmrsIdentifierType>.from(jsonList.map((v) => OmrsIdentifierType.fromJson(v)));
    expect(list.length, 5);
    expect(list.first.identifierSources?.first.prefix, 'ABC');
  });

  test('OMRS Patient model de-serialization test', ()
  {
      var patient = OmrsPatient.fromJson  (
          {
            "uuid": "a6ae62fc-37fd-417c-995a-12ed327997b4",
            "display": "GAN205177 - Rutgar Ragos",
            "identifiers": [
              {
                "uuid": "9d6fa79e-f385-4d81-9bc5-3e2bfc1622ee",
                "identifier": "GAN205177",
                "identifierType": {
                  "name": "Patient Identifier",
                  "uuid": "81433852-3f10-11e4-adec-0800271c1b75"
                }
              },
              {
                "uuid": "73918a45-402f-4491-9779-34a7dd05604f",
                "identifier": "NAT4084",
                "identifierType": {
                  "name": "National ID",
                  "uuid": "0d2ac572-8de3-46c8-9976-1f78899c599f"
                }
              }
            ],
            "person": {
              "uuid": "a6ae62fc-37fd-417c-995a-12ed327997b4",
              "display": "Rutgar Ragos",
              "gender": "M",
              "age": 22,
              "birthdate": "2000-03-03T00:00:00.000+0530",
              "birthdateEstimated": false,
              "dead": false,
              "deathDate": null,
              "causeOfDeath": null,
              "preferredName": {
                "uuid": "7f41db5e-cf12-49b0-aeca-1d765d1cde20",
                "display": "Rutgar Ragos",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/person/a6ae62fc-37fd-417c-995a-12ed327997b4/name/7f41db5e-cf12-49b0-aeca-1d765d1cde20"
                  }
                ]
              },
              "preferredAddress": {
                "uuid": "1bb2da14-3999-46d9-951c-e2e878111a5f",
                "display": null,
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/person/a6ae62fc-37fd-417c-995a-12ed327997b4/address/1bb2da14-3999-46d9-951c-e2e878111a5f"
                  }
                ]
              },
              "attributes": [
                {
                  "uuid": "b7a00d35-28b8-4588-998f-a5398600b0be",
                  "display": "General",
                  "links": [
                    {
                      "rel": "self",
                      "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/person/a6ae62fc-37fd-417c-995a-12ed327997b4/attribute/b7a00d35-28b8-4588-998f-a5398600b0be"
                    }
                  ]
                },
                {
                  "uuid": "b4ebaa9d-2a6d-4cc5-9efa-993dc9865d92",
                  "display": "primaryContact = 919876543210",
                  "links": [
                    {
                      "rel": "self",
                      "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/person/a6ae62fc-37fd-417c-995a-12ed327997b4/attribute/b4ebaa9d-2a6d-4cc5-9efa-993dc9865d92"
                    }
                  ]
                },
                {
                  "uuid": "f4e91210-fee3-4c2a-a981-4486471291e4",
                  "display": "landHolding = 2",
                  "links": [
                    {
                      "rel": "self",
                      "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/person/a6ae62fc-37fd-417c-995a-12ed327997b4/attribute/f4e91210-fee3-4c2a-a981-4486471291e4"
                    }
                  ]
                }
              ],
              "voided": false,
              "deathdateEstimated": false,
              "birthtime": null,
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/person/a6ae62fc-37fd-417c-995a-12ed327997b4"
                },
                {
                  "rel": "full",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/person/a6ae62fc-37fd-417c-995a-12ed327997b4?v=full"
                }
              ],
              "resourceVersion": "1.11"
            }
          }
      );
      expect(patient.identifiers!.length,2);
      expect(patient.identifiers![0].identifierType.name,'Patient Identifier');
      expect(patient.identifiers![0].identifier,'GAN205177');
      expect(patient.identifiers![1].identifierType.name,'National ID');
      expect(patient.identifiers![1].identifier,'NAT4084');
      expect(patient.display,'GAN205177 - Rutgar Ragos');
      expect(patient.uuid,'a6ae62fc-37fd-417c-995a-12ed327997b4');
      expect(patient.person!.display,'Rutgar Ragos');
      expect(patient.person!.birthdate,DateTime.parse('2000-03-02 18:30:00.000Z'));
  });
}
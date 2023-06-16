import 'package:connect2bahmni/screens/models/profile_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should deserialize as Patient Profile', () {
      var profileModel = ProfileModel.fromProfileJson(
          {
            "patient": {
              "uuid": "5994254c-b552-41f6-8fe9-346f9e4cf8b7",
              "display": "ABC200013 - Rahul Shetty",
              "identifiers": [
                {
                  "display": "Patient Identifier = ABC200013",
                  "uuid": "1677272d-6dbf-428a-8447-0dffd5de8e67",
                  "identifier": "ABC200013",
                  "identifierType": {
                    "uuid": "712c108d-00f2-11ee-bbc6-0242c0a86002",
                    "display": "Patient Identifier",
                    "links": [
                      {
                        "rel": "self",
                        "uri": "http://10.0.2.2/openmrs/ws/rest/v1/patientidentifiertype/712c108d-00f2-11ee-bbc6-0242c0a86002",
                        "resourceAlias": "patientidentifiertype"
                      }
                    ]
                  },
                  "location": null,
                  "preferred": true,
                  "voided": false,
                  "links": [
                    {
                      "rel": "self",
                      "uri": "http://10.0.2.2/openmrs/ws/rest/v1/patient/5994254c-b552-41f6-8fe9-346f9e4cf8b7/identifier/1677272d-6dbf-428a-8447-0dffd5de8e67",
                      "resourceAlias": "identifier"
                    },
                    {
                      "rel": "full",
                      "uri": "http://10.0.2.2/openmrs/ws/rest/v1/patient/5994254c-b552-41f6-8fe9-346f9e4cf8b7/identifier/1677272d-6dbf-428a-8447-0dffd5de8e67?v=full",
                      "resourceAlias": "identifier"
                    }
                  ],
                  "resourceVersion": "1.8"
                },
                {
                  "display": "RCH_ID = RCH-Rahul103",
                  "uuid": "6df831d1-3eab-4d24-a1a3-ce855a2d6b90",
                  "identifier": "RCH-Rahul103",
                  "identifierType": {
                    "uuid": "69321f53-ad9b-46c8-8b20-a1ec575bc21e",
                    "display": "RCH_ID",
                    "links": [
                      {
                        "rel": "self",
                        "uri": "http://10.0.2.2/openmrs/ws/rest/v1/patientidentifiertype/69321f53-ad9b-46c8-8b20-a1ec575bc21e",
                        "resourceAlias": "patientidentifiertype"
                      }
                    ]
                  },
                  "location": null,
                  "preferred": false,
                  "voided": false,
                  "links": [
                    {
                      "rel": "self",
                      "uri": "http://10.0.2.2/openmrs/ws/rest/v1/patient/5994254c-b552-41f6-8fe9-346f9e4cf8b7/identifier/6df831d1-3eab-4d24-a1a3-ce855a2d6b90",
                      "resourceAlias": "identifier"
                    },
                    {
                      "rel": "full",
                      "uri": "http://10.0.2.2/openmrs/ws/rest/v1/patient/5994254c-b552-41f6-8fe9-346f9e4cf8b7/identifier/6df831d1-3eab-4d24-a1a3-ce855a2d6b90?v=full",
                      "resourceAlias": "identifier"
                    }
                  ],
                  "resourceVersion": "1.8"
                }
              ],
              "person": {
                "uuid": "5994254c-b552-41f6-8fe9-346f9e4cf8b7",
                "display": "Rahul Shetty",
                "gender": "M",
                "age": 28,
                "birthdate": "1995-06-30T00:00:00.000+0000",
                "birthdateEstimated": false,
                "dead": false,
                "deathDate": null,
                "causeOfDeath": null,
                "preferredName": {
                  "display": "Rahul Shetty",
                  "uuid": "3f0a547f-a147-4070-af17-8f330ff2ca65",
                  "givenName": "Rahul",
                  "middleName": null,
                  "familyName": "Shetty",
                  "familyName2": null,
                  "voided": false,
                  "links": [
                    {
                      "rel": "self",
                      "uri": "http://10.0.2.2/openmrs/ws/rest/v1/person/5994254c-b552-41f6-8fe9-346f9e4cf8b7/name/3f0a547f-a147-4070-af17-8f330ff2ca65",
                      "resourceAlias": "name"
                    },
                    {
                      "rel": "full",
                      "uri": "http://10.0.2.2/openmrs/ws/rest/v1/person/5994254c-b552-41f6-8fe9-346f9e4cf8b7/name/3f0a547f-a147-4070-af17-8f330ff2ca65?v=full",
                      "resourceAlias": "name"
                    }
                  ],
                  "resourceVersion": "1.8"
                },
                "preferredAddress": {
                  "display": null,
                  "uuid": "82c58ac2-643d-4c03-b924-0a0181ec0053",
                  "preferred": true,
                  "address1": null,
                  "address2": null,
                  "cityVillage": "ANUPAHALLI",
                  "stateProvince": "KARNATAKA",
                  "country": null,
                  "postalCode": null,
                  "countyDistrict": "BENGALURU RURAL",
                  "address3": null,
                  "address4": "HOSAKOTE",
                  "address5": null,
                  "address6": null,
                  "startDate": null,
                  "endDate": null,
                  "latitude": null,
                  "longitude": null,
                  "voided": false,
                  "address7": null,
                  "address8": null,
                  "address9": null,
                  "address10": null,
                  "address11": null,
                  "address12": null,
                  "address13": null,
                  "address14": null,
                  "address15": null,
                  "links": [
                    {
                      "rel": "self",
                      "uri": "http://10.0.2.2/openmrs/ws/rest/v1/person/5994254c-b552-41f6-8fe9-346f9e4cf8b7/address/82c58ac2-643d-4c03-b924-0a0181ec0053",
                      "resourceAlias": "address"
                    },
                    {
                      "rel": "full",
                      "uri": "http://10.0.2.2/openmrs/ws/rest/v1/person/5994254c-b552-41f6-8fe9-346f9e4cf8b7/address/82c58ac2-643d-4c03-b924-0a0181ec0053?v=full",
                      "resourceAlias": "address"
                    }
                  ],
                  "resourceVersion": "2.0"
                },
                "names": [
                  {
                    "display": "Rahul Shetty",
                    "uuid": "3f0a547f-a147-4070-af17-8f330ff2ca65",
                    "givenName": "Rahul",
                    "middleName": null,
                    "familyName": "Shetty",
                    "familyName2": null,
                    "voided": false,
                    "links": [
                      {
                        "rel": "self",
                        "uri": "http://10.0.2.2/openmrs/ws/rest/v1/person/5994254c-b552-41f6-8fe9-346f9e4cf8b7/name/3f0a547f-a147-4070-af17-8f330ff2ca65",
                        "resourceAlias": "name"
                      },
                      {
                        "rel": "full",
                        "uri": "http://10.0.2.2/openmrs/ws/rest/v1/person/5994254c-b552-41f6-8fe9-346f9e4cf8b7/name/3f0a547f-a147-4070-af17-8f330ff2ca65?v=full",
                        "resourceAlias": "name"
                      }
                    ],
                    "resourceVersion": "1.8"
                  }
                ],
                "addresses": [
                  {
                    "display": null,
                    "uuid": "82c58ac2-643d-4c03-b924-0a0181ec0053",
                    "preferred": true,
                    "address1": null,
                    "address2": null,
                    "cityVillage": "ANUPAHALLI",
                    "stateProvince": "KARNATAKA",
                    "country": null,
                    "postalCode": null,
                    "countyDistrict": "BENGALURU RURAL",
                    "address3": null,
                    "address4": "HOSAKOTE",
                    "address5": null,
                    "address6": null,
                    "startDate": null,
                    "endDate": null,
                    "latitude": null,
                    "longitude": null,
                    "voided": false,
                    "address7": null,
                    "address8": null,
                    "address9": null,
                    "address10": null,
                    "address11": null,
                    "address12": null,
                    "address13": null,
                    "address14": null,
                    "address15": null,
                    "links": [
                      {
                        "rel": "self",
                        "uri": "http://10.0.2.2/openmrs/ws/rest/v1/person/5994254c-b552-41f6-8fe9-346f9e4cf8b7/address/82c58ac2-643d-4c03-b924-0a0181ec0053",
                        "resourceAlias": "address"
                      },
                      {
                        "rel": "full",
                        "uri": "http://10.0.2.2/openmrs/ws/rest/v1/person/5994254c-b552-41f6-8fe9-346f9e4cf8b7/address/82c58ac2-643d-4c03-b924-0a0181ec0053?v=full",
                        "resourceAlias": "address"
                      }
                    ],
                    "resourceVersion": "2.0"
                  }
                ],
                "attributes": [
                  {
                    "display": "email = test@gmail.com",
                    "uuid": "72405fa3-0927-4647-8ad3-22cd6d2a87ad",
                    "value": "test@gmail.com",
                    "attributeType": {
                      "uuid": "79afb096-00f2-11ee-bbc6-0242c0a86002",
                      "display": "email",
                      "links": [
                        {
                          "rel": "self",
                          "uri": "http://10.0.2.2/openmrs/ws/rest/v1/personattributetype/79afb096-00f2-11ee-bbc6-0242c0a86002",
                          "resourceAlias": "personattributetype"
                        }
                      ]
                    },
                    "voided": false,
                    "links": [
                      {
                        "rel": "self",
                        "uri": "http://10.0.2.2/openmrs/ws/rest/v1/person/5994254c-b552-41f6-8fe9-346f9e4cf8b7/attribute/72405fa3-0927-4647-8ad3-22cd6d2a87ad",
                        "resourceAlias": "attribute"
                      },
                      {
                        "rel": "full",
                        "uri": "http://10.0.2.2/openmrs/ws/rest/v1/person/5994254c-b552-41f6-8fe9-346f9e4cf8b7/attribute/72405fa3-0927-4647-8ad3-22cd6d2a87ad?v=full",
                        "resourceAlias": "attribute"
                      }
                    ],
                    "resourceVersion": "1.8"
                  },
                  {
                    "display": "phoneNumber = +919731562803",
                    "uuid": "56e6c393-171e-4daf-986c-c144e4625795",
                    "value": "+919731562803",
                    "attributeType": {
                      "uuid": "d214a633-e756-41b0-89c5-cd5ec3ef1dbd",
                      "display": "phoneNumber",
                      "links": [
                        {
                          "rel": "self",
                          "uri": "http://10.0.2.2/openmrs/ws/rest/v1/personattributetype/d214a633-e756-41b0-89c5-cd5ec3ef1dbd",
                          "resourceAlias": "personattributetype"
                        }
                      ]
                    },
                    "voided": false,
                    "links": [
                      {
                        "rel": "self",
                        "uri": "http://10.0.2.2/openmrs/ws/rest/v1/person/5994254c-b552-41f6-8fe9-346f9e4cf8b7/attribute/56e6c393-171e-4daf-986c-c144e4625795",
                        "resourceAlias": "attribute"
                      },
                      {
                        "rel": "full",
                        "uri": "http://10.0.2.2/openmrs/ws/rest/v1/person/5994254c-b552-41f6-8fe9-346f9e4cf8b7/attribute/56e6c393-171e-4daf-986c-c144e4625795?v=full",
                        "resourceAlias": "attribute"
                      }
                    ],
                    "resourceVersion": "1.8"
                  }
                ],
                "voided": false,
                "auditInfo": {
                  "creator": {
                    "uuid": "758f5ab8-00f2-11ee-bbc6-0242c0a86002",
                    "display": "superman",
                    "links": [
                      {
                        "rel": "self",
                        "uri": "http://10.0.2.2/openmrs/ws/rest/v1/user/758f5ab8-00f2-11ee-bbc6-0242c0a86002",
                        "resourceAlias": "user"
                      }
                    ]
                  },
                  "dateCreated": "2023-06-30T16:20:39.000+0000",
                  "changedBy": null,
                  "dateChanged": null
                },
                "birthtime": null,
                "deathdateEstimated": false,
                "causeOfDeathNonCoded": null,
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://10.0.2.2/openmrs/ws/rest/v1/person/5994254c-b552-41f6-8fe9-346f9e4cf8b7",
                    "resourceAlias": "person"
                  }
                ],
                "resourceVersion": "1.11"
              },
              "voided": false,
              "auditInfo": {
                "creator": {
                  "uuid": "758f5ab8-00f2-11ee-bbc6-0242c0a86002",
                  "display": "superman",
                  "links": [
                    {
                      "rel": "self",
                      "uri": "http://10.0.2.2/openmrs/ws/rest/v1/user/758f5ab8-00f2-11ee-bbc6-0242c0a86002",
                      "resourceAlias": "user"
                    }
                  ]
                },
                "dateCreated": "2023-06-30T16:20:39.000+0000",
                "changedBy": null,
                "dateChanged": null
              },
              "links": [
                {
                  "rel": "self",
                  "uri": "http://10.0.2.2/openmrs/ws/rest/v1/patient/5994254c-b552-41f6-8fe9-346f9e4cf8b7",
                  "resourceAlias": "patient"
                }
              ],
              "resourceVersion": "1.8"
            },
            "image": null,
            "relationships": [

            ],
            "resourceVersion": "1.8"
          },
      );
      expect(profileModel.uuid, '5994254c-b552-41f6-8fe9-346f9e4cf8b7');
      expect(profileModel.basicDetails?.firstName, 'Rahul');
      expect(profileModel.basicDetails?.lastName, 'Shetty');
      expect(profileModel.basicDetails?.gender, Gender.male);
      expect(profileModel.basicDetails?.dateOfBirth, DateTime.parse("1995-06-30 00:00:00.000Z"));
      expect(profileModel.identifiers?.length, 2);
      expect(profileModel.identifiers?.first.uuid, '1677272d-6dbf-428a-8447-0dffd5de8e67');
      expect(profileModel.identifiers?.first.value, 'ABC200013');
      expect(profileModel.identifiers?.first.name, 'Patient Identifier');
      expect(profileModel.identifiers?.first.preferred, true);

      expect(profileModel.attributes?.length, 2);
      expect(profileModel.attributes?.first.uuid, '72405fa3-0927-4647-8ad3-22cd6d2a87ad');
      expect(profileModel.attributes?.first.value, 'test@gmail.com');
      expect(profileModel.attributes?.first.typeUuid, '79afb096-00f2-11ee-bbc6-0242c0a86002');
      expect(profileModel.attributes?.first.name, 'email');
  });
}

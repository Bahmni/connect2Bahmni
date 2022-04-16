


import 'package:connect2bahmni/domain/models/omrs_obs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Obs de-serialization test with answer as coded concept', () {
    var obs = OmrsObs.fromJson(
        {
          "uuid": "53579cf0-9f29-4040-a76f-42b541f06a67",
          "display": "Diagnosis Certainty: Presumed",
          "concept": {
            "uuid": "81c7d52c-3f10-11e4-adec-0800271c1b75",
            "display": "Diagnosis Certainty",
            "name": {
              "display": "Diagnosis Certainty",
              "uuid": "81c7dc41-3f10-11e4-adec-0800271c1b75",
              "name": "Diagnosis Certainty",
              "locale": "en",
              "localePreferred": true,
              "conceptNameType": "FULLY_SPECIFIED",
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c7d52c-3f10-11e4-adec-0800271c1b75/name/81c7dc41-3f10-11e4-adec-0800271c1b75"
                },
                {
                  "rel": "full",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c7d52c-3f10-11e4-adec-0800271c1b75/name/81c7dc41-3f10-11e4-adec-0800271c1b75?v=full"
                }
              ],
              "resourceVersion": "1.9"
            },
            "datatype": {
              "uuid": "8d4a48b6-c2cc-11de-8d13-0010c6dffd0f",
              "display": "Coded",
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/conceptdatatype/8d4a48b6-c2cc-11de-8d13-0010c6dffd0f"
                }
              ]
            },
            "conceptClass": {
              "uuid": "8d491e50-c2cc-11de-8d13-0010c6dffd0f",
              "display": "Question",
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/conceptclass/8d491e50-c2cc-11de-8d13-0010c6dffd0f"
                }
              ]
            },
            "set": false,
            "version": null,
            "retired": false,
            "names": [
              {
                "uuid": "81c7d914-3f10-11e4-adec-0800271c1b75",
                "display": "Diagnosis Certainty",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c7d52c-3f10-11e4-adec-0800271c1b75/name/81c7d914-3f10-11e4-adec-0800271c1b75"
                  }
                ]
              },
              {
                "uuid": "81c7dc41-3f10-11e4-adec-0800271c1b75",
                "display": "Diagnosis Certainty",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c7d52c-3f10-11e4-adec-0800271c1b75/name/81c7dc41-3f10-11e4-adec-0800271c1b75"
                  }
                ]
              }
            ],
            "descriptions": [],
            "mappings": [
              {
                "uuid": "81c82be9-3f10-11e4-adec-0800271c1b75",
                "display": "org.openmrs.module.emrapi: Diagnosis Certainty",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c7d52c-3f10-11e4-adec-0800271c1b75/mapping/81c82be9-3f10-11e4-adec-0800271c1b75"
                  }
                ]
              }
            ],
            "answers": [
              {
                "uuid": "81c88f93-3f10-11e4-adec-0800271c1b75",
                "display": "Presumed",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c88f93-3f10-11e4-adec-0800271c1b75"
                  }
                ]
              },
              {
                "uuid": "81c90d57-3f10-11e4-adec-0800271c1b75",
                "display": "Confirmed",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c90d57-3f10-11e4-adec-0800271c1b75"
                  }
                ]
              }
            ],
            "setMembers": [],
            "attributes": [],
            "links": [
              {
                "rel": "self",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c7d52c-3f10-11e4-adec-0800271c1b75"
              },
              {
                "rel": "full",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c7d52c-3f10-11e4-adec-0800271c1b75?v=full"
              }
            ],
            "resourceVersion": "2.0"
          },
          "obsDatetime": "2022-04-16T00:57:23.000+0530",
          "comment": null,
          "location": {
            "uuid": "c58e12ed-3f12-11e4-adec-0800271c1b75",
            "name": "OPD-1"
          },
          "value": {
            "uuid": "81c88f93-3f10-11e4-adec-0800271c1b75",
            "display": "Presumed",
            "name": {
              "display": "Presumed",
              "uuid": "81c898a9-3f10-11e4-adec-0800271c1b75",
              "name": "Presumed",
              "locale": "en",
              "localePreferred": true,
              "conceptNameType": "FULLY_SPECIFIED",
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c88f93-3f10-11e4-adec-0800271c1b75/name/81c898a9-3f10-11e4-adec-0800271c1b75"
                },
                {
                  "rel": "full",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c88f93-3f10-11e4-adec-0800271c1b75/name/81c898a9-3f10-11e4-adec-0800271c1b75?v=full"
                }
              ],
              "resourceVersion": "1.9"
            },
            "datatype": {
              "uuid": "8d4a4c94-c2cc-11de-8d13-0010c6dffd0f",
              "display": "N/A",
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/conceptdatatype/8d4a4c94-c2cc-11de-8d13-0010c6dffd0f"
                }
              ]
            },
            "conceptClass": {
              "uuid": "8d492774-c2cc-11de-8d13-0010c6dffd0f",
              "display": "Misc",
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/conceptclass/8d492774-c2cc-11de-8d13-0010c6dffd0f"
                }
              ]
            },
            "set": false,
            "version": null,
            "retired": false,
            "names": [
              {
                "uuid": "81c89455-3f10-11e4-adec-0800271c1b75",
                "display": "Presumed",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c88f93-3f10-11e4-adec-0800271c1b75/name/81c89455-3f10-11e4-adec-0800271c1b75"
                  }
                ]
              },
              {
                "uuid": "81c898a9-3f10-11e4-adec-0800271c1b75",
                "display": "Presumed",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c88f93-3f10-11e4-adec-0800271c1b75/name/81c898a9-3f10-11e4-adec-0800271c1b75"
                  }
                ]
              }
            ],
            "descriptions": [],
            "mappings": [
              {
                "uuid": "81c8e269-3f10-11e4-adec-0800271c1b75",
                "display": "org.openmrs.module.emrapi: Presumed",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c88f93-3f10-11e4-adec-0800271c1b75/mapping/81c8e269-3f10-11e4-adec-0800271c1b75"
                  }
                ]
              }
            ],
            "answers": [],
            "setMembers": [],
            "attributes": [],
            "links": [
              {
                "rel": "self",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c88f93-3f10-11e4-adec-0800271c1b75"
              },
              {
                "rel": "full",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c88f93-3f10-11e4-adec-0800271c1b75?v=full"
              }
            ],
            "resourceVersion": "2.0"
          },
          "encounter": {
            "uuid": "9218b9ae-641b-4d24-b444-f75f183cfc4f",
            "encounterDatetime": "2022-04-16T00:57:23.000+0530",
            "encounterType": {
              "uuid": "81852aee-3f10-11e4-adec-0800271c1b75",
              "display": "Consultation",
              "name": "Consultation",
              "description": "Consultation encounter",
              "retired": false,
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/encountertype/81852aee-3f10-11e4-adec-0800271c1b75"
                },
                {
                  "rel": "full",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/encountertype/81852aee-3f10-11e4-adec-0800271c1b75?v=full"
                }
              ],
              "resourceVersion": "1.8"
            },
            "encounterProviders": [
              {
                "uuid": "415ee02c-0a1e-4bff-a6e1-658dd09e54f6",
                "provider": {
                  "uuid": "c1c26908-3f10-11e4-adec-0800271c1b75",
                  "display": "superman - Super Man",
                  "links": [
                    {
                      "rel": "self",
                      "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/provider/c1c26908-3f10-11e4-adec-0800271c1b75"
                    }
                  ]
                },
                "encounterRole": {
                  "uuid": "a0b03050-c99b-11e0-9572-0800200c9a66",
                  "display": "Unknown",
                  "links": [
                    {
                      "rel": "self",
                      "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/encounterrole/a0b03050-c99b-11e0-9572-0800200c9a66"
                    }
                  ]
                },
                "voided": false,
                "links": [
                  {
                    "rel": "full",
                    "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/encounter/9218b9ae-641b-4d24-b444-f75f183cfc4f/encounterprovider/415ee02c-0a1e-4bff-a6e1-658dd09e54f6?v=full"
                  }
                ],
                "resourceVersion": "1.9"
              }
            ],
            "location": {
              "uuid": "c58e12ed-3f12-11e4-adec-0800271c1b75",
              "name": "OPD-1"
            },
            "patient": {
              "uuid": "d6e3319e-a989-4573-b8a3-001f99b60cc9",
              "display": "GAN205196 - Chinta Mani"
            }
          }
        }
    );
    expect(obs.display, "Diagnosis Certainty: Presumed");
    expect(obs.obsDatetime?.isUtc, true);
    expect(obs.obsDatetime, DateTime.utc(2022,04,15,19,27,23));
    expect(obs.concept.uuid, "81c7d52c-3f10-11e4-adec-0800271c1b75");
    expect(obs.encounter?.encounterType?.display, "Consultation");
    expect(obs.encounter?.encounterProviders?[0].provider?.display, "superman - Super Man");
    expect(obs.value is Map, true, reason: 'Obs Value is not a map');
    expect(obs.value['uuid'], "81c88f93-3f10-11e4-adec-0800271c1b75");
  });

  test('Obs de-serialization test with answer as string', () {
    var obs = OmrsObs.fromJson({
      "uuid": "8fd6f5f3-d54b-49a9-8075-743da4a28ff6",
      "display": "Consultation Note: Clinical notes",
      "concept": {
        "uuid": "81d6e852-3f10-11e4-adec-0800271c1b75",
        "display": "Consultation Note",
        "name": {
          "display": "Consultation Note",
          "uuid": "81d6f097-3f10-11e4-adec-0800271c1b75",
          "name": "Consultation Note",
          "locale": "en",
          "localePreferred": true,
          "conceptNameType": "FULLY_SPECIFIED",
          "links": [
            {
              "rel": "self",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81d6e852-3f10-11e4-adec-0800271c1b75/name/81d6f097-3f10-11e4-adec-0800271c1b75"
            },
            {
              "rel": "full",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81d6e852-3f10-11e4-adec-0800271c1b75/name/81d6f097-3f10-11e4-adec-0800271c1b75?v=full"
            }
          ],
          "resourceVersion": "1.9"
        },
        "datatype": {
          "uuid": "8d4a4ab4-c2cc-11de-8d13-0010c6dffd0f",
          "display": "Text",
          "links": [
            {
              "rel": "self",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/conceptdatatype/8d4a4ab4-c2cc-11de-8d13-0010c6dffd0f"
            }
          ]
        },
        "conceptClass": {
          "uuid": "8d492774-c2cc-11de-8d13-0010c6dffd0f",
          "display": "Misc",
          "links": [
            {
              "rel": "self",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/conceptclass/8d492774-c2cc-11de-8d13-0010c6dffd0f"
            }
          ]
        },
        "set": false,
        "version": null,
        "retired": false,
        "names": [
          {
            "uuid": "81d6f097-3f10-11e4-adec-0800271c1b75",
            "display": "Consultation Note",
            "links": [
              {
                "rel": "self",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81d6e852-3f10-11e4-adec-0800271c1b75/name/81d6f097-3f10-11e4-adec-0800271c1b75"
              }
            ]
          },
          {
            "uuid": "81d6ed5e-3f10-11e4-adec-0800271c1b75",
            "display": "consultation note",
            "links": [
              {
                "rel": "self",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81d6e852-3f10-11e4-adec-0800271c1b75/name/81d6ed5e-3f10-11e4-adec-0800271c1b75"
              }
            ]
          }
        ],
        "descriptions": [
          {
            "uuid": "81d7da03-3f10-11e4-adec-0800271c1b75",
            "display": "Consultation Note",
            "links": [
              {
                "rel": "self",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81d6e852-3f10-11e4-adec-0800271c1b75/description/81d7da03-3f10-11e4-adec-0800271c1b75"
              }
            ]
          }
        ],
        "mappings": [],
        "answers": [],
        "setMembers": [],
        "attributes": [],
        "links": [
          {
            "rel": "self",
            "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81d6e852-3f10-11e4-adec-0800271c1b75"
          },
          {
            "rel": "full",
            "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81d6e852-3f10-11e4-adec-0800271c1b75?v=full"
          }
        ],
        "resourceVersion": "2.0"
      },
      "obsDatetime": "2022-04-16T20:19:42.000+0530",
      "comment": null,
      "location": {
        "uuid": "c58e12ed-3f12-11e4-adec-0800271c1b75",
        "name": "OPD-1"
      },
      "value": "Clinical notes",
      "encounter": {
        "uuid": "db6f6d78-7919-4df8-82bd-87ba8ed16abe",
        "encounterDatetime": "2022-04-16T20:19:42.000+0530",
        "encounterType": {
          "uuid": "81852aee-3f10-11e4-adec-0800271c1b75",
          "display": "Consultation",
          "name": "Consultation",
          "description": "Consultation encounter",
          "retired": false,
          "links": [
            {
              "rel": "self",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/encountertype/81852aee-3f10-11e4-adec-0800271c1b75"
            },
            {
              "rel": "full",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/encountertype/81852aee-3f10-11e4-adec-0800271c1b75?v=full"
            }
          ],
          "resourceVersion": "1.8"
        },
        "encounterProviders": [
          {
            "uuid": "74a7153d-c50c-4b3a-a90a-9f9ff267869f",
            "provider": {
              "uuid": "c1c26908-3f10-11e4-adec-0800271c1b75",
              "display": "superman - Super Man",
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/provider/c1c26908-3f10-11e4-adec-0800271c1b75"
                }
              ]
            },
            "encounterRole": {
              "uuid": "a0b03050-c99b-11e0-9572-0800200c9a66",
              "display": "Unknown",
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/encounterrole/a0b03050-c99b-11e0-9572-0800200c9a66"
                }
              ]
            },
            "voided": false,
            "links": [
              {
                "rel": "full",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/encounter/db6f6d78-7919-4df8-82bd-87ba8ed16abe/encounterprovider/74a7153d-c50c-4b3a-a90a-9f9ff267869f?v=full"
              }
            ],
            "resourceVersion": "1.9"
          }
        ],
        "location": {
          "uuid": "c58e12ed-3f12-11e4-adec-0800271c1b75",
          "name": "OPD-1"
        },
        "patient": {
          "uuid": "d6e3319e-a989-4573-b8a3-001f99b60cc9",
          "display": "GAN205196 - Chinta Mani"
        }
      }
    });
    expect(obs.value.runtimeType, String);
    expect(obs.value, "Clinical notes");
  });

  test('Obs de-serialization test with answer as numeric', () {
    var obs = OmrsObs.fromJson({
      "uuid": "396d58e9-14d4-406a-863f-07d8506b5df0",
      "display": "HEIGHT: 171",
      "concept": {
        "uuid": "5090AAAAAAAAAAAAAAAAAAAAAAAAAAAA",
        "display": "HEIGHT",
        "name": {
          "display": "HEIGHT",
          "uuid": "c366bfd8-3f10-11e4-adec-0800271c1b75",
          "name": "HEIGHT",
          "locale": "en",
          "localePreferred": true,
          "conceptNameType": "FULLY_SPECIFIED",
          "links": [
            {
              "rel": "self",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/5090AAAAAAAAAAAAAAAAAAAAAAAAAAAA/name/c366bfd8-3f10-11e4-adec-0800271c1b75"
            },
            {
              "rel": "full",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/5090AAAAAAAAAAAAAAAAAAAAAAAAAAAA/name/c366bfd8-3f10-11e4-adec-0800271c1b75?v=full"
            }
          ],
          "resourceVersion": "1.9"
        },
        "datatype": {
          "uuid": "8d4a4488-c2cc-11de-8d13-0010c6dffd0f",
          "display": "Numeric",
          "links": [
            {
              "rel": "self",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/conceptdatatype/8d4a4488-c2cc-11de-8d13-0010c6dffd0f"
            }
          ]
        },
        "conceptClass": {
          "uuid": "8d492774-c2cc-11de-8d13-0010c6dffd0f",
          "display": "Misc",
          "links": [
            {
              "rel": "self",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/conceptclass/8d492774-c2cc-11de-8d13-0010c6dffd0f"
            }
          ]
        },
        "set": false,
        "version": null,
        "retired": false,
        "names": [
          {
            "uuid": "c366bfd8-3f10-11e4-adec-0800271c1b75",
            "display": "HEIGHT",
            "links": [
              {
                "rel": "self",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/5090AAAAAAAAAAAAAAAAAAAAAAAAAAAA/name/c366bfd8-3f10-11e4-adec-0800271c1b75"
              }
            ]
          },
          {
            "uuid": "c366bcf2-3f10-11e4-adec-0800271c1b75",
            "display": "HEIGHT",
            "links": [
              {
                "rel": "self",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/5090AAAAAAAAAAAAAAAAAAAAAAAAAAAA/name/c366bcf2-3f10-11e4-adec-0800271c1b75"
              }
            ]
          }
        ],
        "descriptions": [],
        "mappings": [
          {
            "uuid": "ccb7f47b-823e-4918-9729-03009020a143",
            "display": "SNOMED: 271603002 (Height / growth measure)",
            "links": [
              {
                "rel": "self",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/5090AAAAAAAAAAAAAAAAAAAAAAAAAAAA/mapping/ccb7f47b-823e-4918-9729-03009020a143"
              }
            ]
          }
        ],
        "answers": [],
        "setMembers": [],
        "attributes": [],
        "links": [
          {
            "rel": "self",
            "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/5090AAAAAAAAAAAAAAAAAAAAAAAAAAAA"
          },
          {
            "rel": "full",
            "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/5090AAAAAAAAAAAAAAAAAAAAAAAAAAAA?v=full"
          }
        ],
        "resourceVersion": "2.0"
      },
      "obsDatetime": "2022-04-17T20:42:05.000+0530",
      "comment": null,
      "location": {
        "uuid": "c58e12ed-3f12-11e4-adec-0800271c1b75",
        "name": "OPD-1"
      },
      "value": 171.0,
      "encounter": {
        "uuid": "35e1f7fb-5f57-424a-af9c-5f91cab6fa0d",
        "encounterDatetime": "2022-04-17T20:42:05.000+0530",
        "encounterType": {
          "uuid": "81852aee-3f10-11e4-adec-0800271c1b75",
          "display": "Consultation",
          "name": "Consultation",
          "description": "Consultation encounter",
          "retired": false,
          "links": [
            {
              "rel": "self",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/encountertype/81852aee-3f10-11e4-adec-0800271c1b75"
            },
            {
              "rel": "full",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/encountertype/81852aee-3f10-11e4-adec-0800271c1b75?v=full"
            }
          ],
          "resourceVersion": "1.8"
        },
        "encounterProviders": [
          {
            "uuid": "6f97ec86-6e58-4853-afeb-3381df832fea",
            "provider": {
              "uuid": "c1c26908-3f10-11e4-adec-0800271c1b75",
              "display": "superman - Super Man",
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/provider/c1c26908-3f10-11e4-adec-0800271c1b75"
                }
              ]
            },
            "encounterRole": {
              "uuid": "a0b03050-c99b-11e0-9572-0800200c9a66",
              "display": "Unknown",
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/encounterrole/a0b03050-c99b-11e0-9572-0800200c9a66"
                }
              ]
            },
            "voided": false,
            "links": [
              {
                "rel": "full",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/encounter/35e1f7fb-5f57-424a-af9c-5f91cab6fa0d/encounterprovider/6f97ec86-6e58-4853-afeb-3381df832fea?v=full"
              }
            ],
            "resourceVersion": "1.9"
          }
        ],
        "location": {
          "uuid": "c58e12ed-3f12-11e4-adec-0800271c1b75",
          "name": "OPD-1"
        },
        "patient": {
          "uuid": "d6e3319e-a989-4573-b8a3-001f99b60cc9",
          "display": "GAN205196 - Chinta Mani"
        }
      }
    });
    expect(obs.value is num, true, reason: 'Value is not a number');
    expect(obs.valueAsString, "171.0");
    expect(obs.value, 171.0);
    expect(obs.valueAsString, "171.0");
  });

}
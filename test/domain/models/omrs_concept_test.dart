

import 'package:connect2bahmni/domain/models/omrs_concept.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('EMR API Diagnosis de-serialization test', () {
    var concept = OmrsConcept.fromJson({
      "conceptName": "Salmonella gastroenteritis",
      "conceptUuid": "dc6bf34b-4e14-11e4-8a57-0800271c1b75",
      "matchedName": "Salmonella gastroenteritis"
    });
    expect(concept.display, "Salmonella gastroenteritis");
    expect(concept.uuid, "dc6bf34b-4e14-11e4-8a57-0800271c1b75");
  });

  test('REST API concept de-serialization test', () {
    var concept = OmrsConcept.fromJson({
      "uuid": "dc6bf34b-4e14-11e4-8a57-0800271c1b75",
      "display": "Salmonella gastroenteritis",
      "name": {
        "display": "Salmonella gastroenteritis",
        "uuid": "dc6c25cc-4e14-11e4-8a57-0800271c1b75",
        "name": "Salmonella gastroenteritis",
        "locale": "en",
        "localePreferred": true,
        "conceptNameType": "FULLY_SPECIFIED",
        "links": [
          {
            "rel": "self",
            "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/dc6bf34b-4e14-11e4-8a57-0800271c1b75/name/dc6c25cc-4e14-11e4-8a57-0800271c1b75"
          },
          {
            "rel": "full",
            "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/dc6bf34b-4e14-11e4-8a57-0800271c1b75/name/dc6c25cc-4e14-11e4-8a57-0800271c1b75?v=full"
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
        "uuid": "8d4918b0-c2cc-11de-8d13-0010c6dffd0f",
        "display": "Diagnosis",
        "links": [
          {
            "rel": "self",
            "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/conceptclass/8d4918b0-c2cc-11de-8d13-0010c6dffd0f"
          }
        ]
      },
      "set": false,
      "version": null,
      "retired": false,
      "names": [
        {
          "uuid": "dc6c25cc-4e14-11e4-8a57-0800271c1b75",
          "display": "Salmonella gastroenteritis",
          "links": [
            {
              "rel": "self",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/dc6bf34b-4e14-11e4-8a57-0800271c1b75/name/dc6c25cc-4e14-11e4-8a57-0800271c1b75"
            }
          ]
        }
      ],
      "descriptions": [
        {
          "uuid": "f7cd95cb-6f9d-4b9f-af0c-71f8c6307828",
          "display": "An infection with salmonella bacteria, commonly caused by contaminated food or water.\r\nSalmonella is most common among children. People with compromised immune systems, such as older adults, babies and people with AIDS, are more likely to have severe cases.\r\nSymptoms include diarrhoea, fever, chills and abdominal pain.\r\nMost people only need fluids to recover in less than a week. Severe infections may require medical care, including IV fluids and sometimes antibiotics.",
          "links": [
            {
              "rel": "self",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/dc6bf34b-4e14-11e4-8a57-0800271c1b75/description/f7cd95cb-6f9d-4b9f-af0c-71f8c6307828"
            }
          ]
        }
      ],
      "mappings": [
        {
          "uuid": "dc6d5437-4e14-11e4-8a57-0800271c1b75",
          "display": "ICD 10 - WHO: A02.0 (Salmonella enteritis)",
          "links": [
            {
              "rel": "self",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/dc6bf34b-4e14-11e4-8a57-0800271c1b75/mapping/dc6d5437-4e14-11e4-8a57-0800271c1b75"
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
          "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/dc6bf34b-4e14-11e4-8a57-0800271c1b75"
        },
        {
          "rel": "full",
          "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/dc6bf34b-4e14-11e4-8a57-0800271c1b75?v=full"
        }
      ],
      "resourceVersion": "2.0"
    });
    expect(concept.display, "Salmonella gastroenteritis");
    expect(concept.uuid, "dc6bf34b-4e14-11e4-8a57-0800271c1b75");
    expect(concept.descriptions?.length, 1);
    expect(concept.descriptions?.first.display!.startsWith('An infection with salmonella bacteria'), true);
    expect(concept.description!.startsWith('An infection with salmonella bacteria'), true);
  });

  test('REST API concept deserialization with answers', () {
    var concept = OmrsConcept.fromJson( {
      "uuid": "81c9da5f-3f10-11e4-adec-0800271c1b75",
      "display": "Diagnosis order",
      "name": {
        "display": "Diagnosis order",
        "uuid": "81c9e1bc-3f10-11e4-adec-0800271c1b75",
        "name": "Diagnosis order",
        "locale": "en",
        "localePreferred": true,
        "conceptNameType": "FULLY_SPECIFIED",
        "links": [
          {
            "rel": "self",
            "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c9da5f-3f10-11e4-adec-0800271c1b75/name/81c9e1bc-3f10-11e4-adec-0800271c1b75"
          },
          {
            "rel": "full",
            "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c9da5f-3f10-11e4-adec-0800271c1b75/name/81c9e1bc-3f10-11e4-adec-0800271c1b75?v=full"
          }
        ],
        "resourceVersion": "1.9"
      },
      "datatype": {
        "uuid": "8d4a48b6-c2cc-11de-8d13-0010c6dffd0f",
        "display": "Coded",
        "name": "Coded",
        "description": "Value determined by term dictionary lookup (i.e., term identifier)",
        "hl7Abbreviation": "CWE",
        "retired": false,
        "links": [
          {
            "rel": "self",
            "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/conceptdatatype/8d4a48b6-c2cc-11de-8d13-0010c6dffd0f"
          },
          {
            "rel": "full",
            "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/conceptdatatype/8d4a48b6-c2cc-11de-8d13-0010c6dffd0f?v=full"
          }
        ],
        "resourceVersion": "1.8"
      },
      "conceptClass": {
        "uuid": "8d491e50-c2cc-11de-8d13-0010c6dffd0f",
        "display": "Question",
        "name": "Question",
        "description": "Question (eg, patient history, SF36 items)",
        "retired": false,
        "links": [
          {
            "rel": "self",
            "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/conceptclass/8d491e50-c2cc-11de-8d13-0010c6dffd0f"
          },
          {
            "rel": "full",
            "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/conceptclass/8d491e50-c2cc-11de-8d13-0010c6dffd0f?v=full"
          }
        ],
        "resourceVersion": "1.8"
      },
      "set": false,
      "version": null,
      "retired": false,
      "names": [
        {
          "display": "Diagnosis order",
          "uuid": "81c9de8d-3f10-11e4-adec-0800271c1b75",
          "name": "Diagnosis order",
          "locale": "en",
          "localePreferred": false,
          "conceptNameType": "SHORT",
          "links": [
            {
              "rel": "self",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c9da5f-3f10-11e4-adec-0800271c1b75/name/81c9de8d-3f10-11e4-adec-0800271c1b75"
            },
            {
              "rel": "full",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c9da5f-3f10-11e4-adec-0800271c1b75/name/81c9de8d-3f10-11e4-adec-0800271c1b75?v=full"
            }
          ],
          "resourceVersion": "1.9"
        },
        {
          "display": "Diagnosis order",
          "uuid": "81c9e1bc-3f10-11e4-adec-0800271c1b75",
          "name": "Diagnosis order",
          "locale": "en",
          "localePreferred": true,
          "conceptNameType": "FULLY_SPECIFIED",
          "links": [
            {
              "rel": "self",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c9da5f-3f10-11e4-adec-0800271c1b75/name/81c9e1bc-3f10-11e4-adec-0800271c1b75"
            },
            {
              "rel": "full",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c9da5f-3f10-11e4-adec-0800271c1b75/name/81c9e1bc-3f10-11e4-adec-0800271c1b75?v=full"
            }
          ],
          "resourceVersion": "1.9"
        }
      ],
      "descriptions": [],
      "mappings": [
        {
          "display": "org.openmrs.module.emrapi: Diagnosis Order",
          "uuid": "81ca346e-3f10-11e4-adec-0800271c1b75",
          "conceptReferenceTerm": {
            "uuid": "81ca2ee1-3f10-11e4-adec-0800271c1b75",
            "display": "org.openmrs.module.emrapi: Diagnosis Order",
            "links": [
              {
                "rel": "self",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/conceptreferenceterm/81ca2ee1-3f10-11e4-adec-0800271c1b75"
              }
            ]
          },
          "conceptMapType": {
            "uuid": "35543629-7d8c-11e1-909d-c80aa9edcf4e",
            "display": "SAME-AS",
            "links": [
              {
                "rel": "self",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/conceptmaptype/35543629-7d8c-11e1-909d-c80aa9edcf4e"
              }
            ]
          },
          "links": [
            {
              "rel": "self",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c9da5f-3f10-11e4-adec-0800271c1b75/mapping/81ca346e-3f10-11e4-adec-0800271c1b75"
            },
            {
              "rel": "full",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c9da5f-3f10-11e4-adec-0800271c1b75/mapping/81ca346e-3f10-11e4-adec-0800271c1b75?v=full"
            }
          ],
          "resourceVersion": "1.9"
        }
      ],
      "answers": [
        {
          "uuid": "81ca9451-3f10-11e4-adec-0800271c1b75",
          "display": "Secondary",
          "name": {
            "display": "Secondary",
            "uuid": "81ca9b4c-3f10-11e4-adec-0800271c1b75",
            "name": "Secondary",
            "locale": "en",
            "localePreferred": true,
            "conceptNameType": "FULLY_SPECIFIED",
            "links": [
              {
                "rel": "self",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81ca9451-3f10-11e4-adec-0800271c1b75/name/81ca9b4c-3f10-11e4-adec-0800271c1b75"
              },
              {
                "rel": "full",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81ca9451-3f10-11e4-adec-0800271c1b75/name/81ca9b4c-3f10-11e4-adec-0800271c1b75?v=full"
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
              "uuid": "81ca983f-3f10-11e4-adec-0800271c1b75",
              "display": "Secondary",
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81ca9451-3f10-11e4-adec-0800271c1b75/name/81ca983f-3f10-11e4-adec-0800271c1b75"
                }
              ]
            },
            {
              "uuid": "81ca9b4c-3f10-11e4-adec-0800271c1b75",
              "display": "Secondary",
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81ca9451-3f10-11e4-adec-0800271c1b75/name/81ca9b4c-3f10-11e4-adec-0800271c1b75"
                }
              ]
            }
          ],
          "descriptions": [],
          "mappings": [
            {
              "uuid": "81cad22e-3f10-11e4-adec-0800271c1b75",
              "display": "org.openmrs.module.emrapi: Secondary",
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81ca9451-3f10-11e4-adec-0800271c1b75/mapping/81cad22e-3f10-11e4-adec-0800271c1b75"
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
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81ca9451-3f10-11e4-adec-0800271c1b75"
            },
            {
              "rel": "full",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81ca9451-3f10-11e4-adec-0800271c1b75?v=full"
            }
          ],
          "resourceVersion": "2.0"
        },
        {
          "uuid": "81cafebe-3f10-11e4-adec-0800271c1b75",
          "display": "Primary",
          "name": {
            "display": "Primary",
            "uuid": "81cb054c-3f10-11e4-adec-0800271c1b75",
            "name": "Primary",
            "locale": "en",
            "localePreferred": true,
            "conceptNameType": "FULLY_SPECIFIED",
            "links": [
              {
                "rel": "self",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81cafebe-3f10-11e4-adec-0800271c1b75/name/81cb054c-3f10-11e4-adec-0800271c1b75"
              },
              {
                "rel": "full",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81cafebe-3f10-11e4-adec-0800271c1b75/name/81cb054c-3f10-11e4-adec-0800271c1b75?v=full"
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
              "uuid": "81cb054c-3f10-11e4-adec-0800271c1b75",
              "display": "Primary",
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81cafebe-3f10-11e4-adec-0800271c1b75/name/81cb054c-3f10-11e4-adec-0800271c1b75"
                }
              ]
            },
            {
              "uuid": "81cb025b-3f10-11e4-adec-0800271c1b75",
              "display": "Primary",
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81cafebe-3f10-11e4-adec-0800271c1b75/name/81cb025b-3f10-11e4-adec-0800271c1b75"
                }
              ]
            }
          ],
          "descriptions": [],
          "mappings": [
            {
              "uuid": "81cb6974-3f10-11e4-adec-0800271c1b75",
              "display": "org.openmrs.module.emrapi: Primary",
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81cafebe-3f10-11e4-adec-0800271c1b75/mapping/81cb6974-3f10-11e4-adec-0800271c1b75"
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
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81cafebe-3f10-11e4-adec-0800271c1b75"
            },
            {
              "rel": "full",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81cafebe-3f10-11e4-adec-0800271c1b75?v=full"
            }
          ],
          "resourceVersion": "2.0"
        }
      ],
      "setMembers": [],
      "auditInfo": {
        "creator": {
          "uuid": "62a3b753-3f10-11e4-adec-0800271c1b75",
          "display": "admin",
          "links": [
            {
              "rel": "self",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/user/62a3b753-3f10-11e4-adec-0800271c1b75"
            }
          ]
        },
        "dateCreated": "2014-09-18T14:18:05.000+0530",
        "changedBy": {
          "uuid": "62a3b753-3f10-11e4-adec-0800271c1b75",
          "display": "admin",
          "links": [
            {
              "rel": "self",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/user/62a3b753-3f10-11e4-adec-0800271c1b75"
            }
          ]
        },
        "dateChanged": "2014-09-18T14:18:05.000+0530"
      },
      "attributes": [],
      "links": [
        {
          "rel": "self",
          "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/concept/81c9da5f-3f10-11e4-adec-0800271c1b75"
        }
      ],
      "resourceVersion": "2.0"
    });
    expect(concept.answers!.length, 2);
    expect(concept.answers!.first.display, 'Secondary');
    expect(concept.names!.first.name, 'Diagnosis order');
    expect(concept.names!.first.conceptNameType, 'SHORT');
    expect(concept.names![1].name, 'Diagnosis order');
    expect(concept.names![1].conceptNameType, 'FULLY_SPECIFIED');
    expect(concept.conceptClass!.name, 'Question');
    expect(concept.datatype!.name, 'Coded');
  });
}


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
  });
}
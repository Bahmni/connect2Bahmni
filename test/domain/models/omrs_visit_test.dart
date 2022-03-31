

import 'package:connect2bahmni/domain/models/oms_visit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('OMRS Visit de-serialization test', () {
    var visit = OmrsVisit.fromJson(
        {
          "uuid": "a669e4f8-605c-4682-9619-982a34ff589a",
          "display": "OPD @ Ganiyari - 03/14/2022 06:41 PM",
          "patient": {
            "uuid": "a6ae62fc-37fd-417c-995a-12ed327997b4",
            "display": "GAN205177 - Rutgar Ragos",
            "links": [
              {
                "rel": "self",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/patient/a6ae62fc-37fd-417c-995a-12ed327997b4"
              }
            ]
          },
          "visitType": {
            "uuid": "c22a5000-3f10-11e4-adec-0800271c1b75",
            "display": "OPD",
            "links": [
              {
                "rel": "self",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/visittype/c22a5000-3f10-11e4-adec-0800271c1b75"
              }
            ]
          },
          "indication": null,
          "location": {
            "uuid": "c1e42932-3f10-11e4-adec-0800271c1b75",
            "display": "Ganiyari",
            "links": [
              {
                "rel": "self",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/location/c1e42932-3f10-11e4-adec-0800271c1b75"
              }
            ]
          },
          "startDatetime": "2022-03-14T18:41:23.000+0530",
          "stopDatetime": "2022-03-14T18:42:09.000+0530",
          "encounters": [
            {
              "uuid": "5fb572c6-5baf-4eee-b1b5-28f3ba60a63a",
              "display": "Consultation 03/14/2022",
              "encounterDatetime": "2022-03-14T18:42:09.000+0530",
              "patient": {
                "uuid": "a6ae62fc-37fd-417c-995a-12ed327997b4",
                "display": "GAN205177 - Rutgar Ragos",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/patient/a6ae62fc-37fd-417c-995a-12ed327997b4"
                  }
                ]
              },
              "location": {
                "uuid": "c58e12ed-3f12-11e4-adec-0800271c1b75",
                "display": "OPD-1",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/location/c58e12ed-3f12-11e4-adec-0800271c1b75"
                  }
                ]
              },
              "form": null,
              "encounterType": {
                "uuid": "81852aee-3f10-11e4-adec-0800271c1b75",
                "display": "Consultation",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/encountertype/81852aee-3f10-11e4-adec-0800271c1b75"
                  }
                ]
              },
              "obs": [
                {
                  "uuid": "d1ef9ebf-5ad6-4f55-8c37-ba3ef9c281ed",
                  "display": "BMI Status Data: Overweight, true",
                  "links": [
                    {
                      "rel": "self",
                      "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/obs/d1ef9ebf-5ad6-4f55-8c37-ba3ef9c281ed"
                    }
                  ]
                },
                {
                  "uuid": "b0ab332f-c636-41fe-b81e-8dbeb2c500c6",
                  "display": "Visit Diagnoses: Presumed, Gastrointestinal tract, unspec., Primary, false, b0ab332f-c636-41fe-b81e-8dbeb2c500c6",
                  "links": [
                    {
                      "rel": "self",
                      "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/obs/b0ab332f-c636-41fe-b81e-8dbeb2c500c6"
                    }
                  ]
                },
                {
                  "uuid": "62063270-5ea0-48a3-be80-4f4a5846ffe5",
                  "display": "BMI Data: true, 26.64",
                  "links": [
                    {
                      "rel": "self",
                      "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/obs/62063270-5ea0-48a3-be80-4f4a5846ffe5"
                    }
                  ]
                },
                {
                  "uuid": "f896e1a4-8cf5-4191-818f-5757610655b2",
                  "display": "Vitals: 72.0, false, 77.0, 170.0",
                  "links": [
                    {
                      "rel": "self",
                      "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/obs/f896e1a4-8cf5-4191-818f-5757610655b2"
                    }
                  ]
                }
              ],
              "orders": [],
              "voided": false,
              "visit": {
                "uuid": "a669e4f8-605c-4682-9619-982a34ff589a",
                "display": "OPD @ Ganiyari - 03/14/2022 06:41 PM",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/visit/a669e4f8-605c-4682-9619-982a34ff589a"
                  }
                ]
              },
              "encounterProviders": [
                {
                  "uuid": "61a127de-4fbd-4d30-9470-0b71713271e6",
                  "display": "Super Man: Unknown",
                  "links": [
                    {
                      "rel": "self",
                      "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/encounter/5fb572c6-5baf-4eee-b1b5-28f3ba60a63a/encounterprovider/61a127de-4fbd-4d30-9470-0b71713271e6"
                    }
                  ]
                }
              ],
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/encounter/5fb572c6-5baf-4eee-b1b5-28f3ba60a63a"
                },
                {
                  "rel": "full",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/encounter/5fb572c6-5baf-4eee-b1b5-28f3ba60a63a?v=full"
                }
              ],
              "resourceVersion": "1.9"
            }
          ],
          "attributes": [
            {
              "display": "Visit Status: OPD",
              "uuid": "09834109-379f-4017-a9cc-131e573669dc",
              "attributeType": {
                "uuid": "ff25b0f3-e276-11e4-900f-080027b662ec",
                "display": "Visit Status",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/visitattributetype/ff25b0f3-e276-11e4-900f-080027b662ec"
                  }
                ]
              },
              "value": "OPD",
              "voided": false,
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/visit/a669e4f8-605c-4682-9619-982a34ff589a/attribute/09834109-379f-4017-a9cc-131e573669dc"
                },
                {
                  "rel": "full",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/visit/a669e4f8-605c-4682-9619-982a34ff589a/attribute/09834109-379f-4017-a9cc-131e573669dc?v=full"
                }
              ],
              "resourceVersion": "1.9"
            }
          ],
          "voided": false,
          "auditInfo": {
            "creator": {
              "uuid": "c1c21e11-3f10-11e4-adec-0800271c1b75",
              "display": "superman",
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/user/c1c21e11-3f10-11e4-adec-0800271c1b75"
                }
              ]
            },
            "dateCreated": "2022-03-14T18:41:23.000+0530",
            "changedBy": {
              "uuid": "A4F30A1B-5EB9-11DF-A648-37A07F9C90FB",
              "display": "daemon",
              "links": [
                {
                  "rel": "self",
                  "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/user/A4F30A1B-5EB9-11DF-A648-37A07F9C90FB"
                }
              ]
            },
            "dateChanged": "2022-03-15T23:59:59.000+0530"
          },
          "links": [
            {
              "rel": "self",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/visit/a669e4f8-605c-4682-9619-982a34ff589a"
            }
          ],
          "resourceVersion": "1.9"
        }
    );
    expect(visit.uuid, 'a669e4f8-605c-4682-9619-982a34ff589a');
    expect(visit.display, 'OPD @ Ganiyari - 03/14/2022 06:41 PM');
    expect(visit.startDatetime, DateTime.parse('2022-03-14T18:41:23.000+0530'));
    expect(visit.stopDatetime, DateTime.parse('2022-03-14T18:42:09.000+0530'));
  });

}
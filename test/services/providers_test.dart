import 'dart:convert';

import 'package:connect2bahmni/domain/models/omrs_provider.dart';
import 'package:connect2bahmni/services/providers.dart';
import 'package:fhir/r4.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  test('provider to practitioner deserialization test', () async {
    var jsonString = '''{
      "results": [
        {
          "uuid": "c1c26908-3f10-11e4-adec-0800271c1b75",
          "identifier": "superman",
          "attributes": []
        }
      ]
    }''';
    var json = jsonDecode(jsonString);
    var resultList = json['results'] ?? [];
    var providerList = List<Practitioner>.from(resultList.map((prov) {
      return Providers().fromOmrsProvider(prov);
    }));

    expect(providerList.isNotEmpty, true);
    expect(providerList.single.id, Id('c1c26908-3f10-11e4-adec-0800271c1b75'));
    expect(providerList.single.identifier!.first.value, 'superman');
  });

  test('omrs provider deserialization test', () async {
    final provider   = OmrsProvider.fromJson({
      "uuid": "c1c26908-3f10-11e4-adec-0800271c1b75",
      "identifier": "superman",
      "attributes": []
    });
    expect(provider.uuid, 'c1c26908-3f10-11e4-adec-0800271c1b75');
    expect(provider.identifier, 'superman');

    final drKishore = OmrsProvider.fromJson({
      "uuid": "95fc0b16-eb92-4332-a105-ec5aa6df6cc5",
      "identifier": "27-3",
      "attributes": [
        {
          "display": "Available for appointments: true",
          "uuid": "241d005e-67e6-48f2-b183-8829d06ddfc5",
          "attributeType": {
            "uuid": "a378fc62-e03a-11ea-abe2-025d983c9330",
            "display": "Available for appointments",
            "links": [
              {
                "rel": "self",
                "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/providerattributetype/a378fc62-e03a-11ea-abe2-025d983c9330"
              }
            ]
          },
          "value": true,
          "voided": false,
          "links": [
            {
              "rel": "self",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/provider/95fc0b16-eb92-4332-a105-ec5aa6df6cc5/attribute/241d005e-67e6-48f2-b183-8829d06ddfc5"
            },
            {
              "rel": "full",
              "uri": "http://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/provider/95fc0b16-eb92-4332-a105-ec5aa6df6cc5/attribute/241d005e-67e6-48f2-b183-8829d06ddfc5?v=full"
            }
          ],
          "resourceVersion": "1.9"
        }
      ]
    });
    expect(drKishore.uuid, '95fc0b16-eb92-4332-a105-ec5aa6df6cc5');
    expect(drKishore.identifier, '27-3');
    var result = drKishore.attributes?.where((attr) => attr["uuid"] == "241d005e-67e6-48f2-b183-8829d06ddfc5");
    expect(result!.isNotEmpty, true);
    expect(result.first['value'], true);

    var valuesOfAttribute = drKishore.attrValue('Available for appointments');
    expect(valuesOfAttribute.length, 1);
    expect(valuesOfAttribute.elementAt(0), true);
  });
  
  test('Omrs provider attribute dynamic value test', () async {
    final drKishore = OmrsProvider.fromJson({
      "uuid": "c1c26908-3f10-11e4-adec-0800271c1b75",
      "identifier": "superman",
      "attributes": [
        {
          "display": "Available for appointments: true",
          "uuid": "eaab04e5-ce73-45ff-9fea-c99768fb2f75",
          "attributeType": {
            "uuid": "58f1d642-a8ec-11ec-921a-0242ac110004",
            "display": "Available for appointments",
            "links": [
              {
                "rel": "self",
                "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/providerattributetype/58f1d642-a8ec-11ec-921a-0242ac110004"
              }
            ]
          },
          "value": true,
          "voided": false,
          "links": [
            {
              "rel": "self",
              "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/provider/c1c26908-3f10-11e4-adec-0800271c1b75/attribute/eaab04e5-ce73-45ff-9fea-c99768fb2f75"
            },
            {
              "rel": "full",
              "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/provider/c1c26908-3f10-11e4-adec-0800271c1b75/attribute/eaab04e5-ce73-45ff-9fea-c99768fb2f75?v=full"
            }
          ],
          "resourceVersion": "1.9"
        },
        {
          "display": "locations: Subcenter 1 (BAM)",
          "uuid": "a3fa02b2-ea31-4f4c-81fe-137a8d5d6482",
          "attributeType": {
            "uuid": "98bc7052-9c3d-4a8b-9001-7d8f84a0b257",
            "display": "locations",
            "links": [
              {
                "rel": "self",
                "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/providerattributetype/98bc7052-9c3d-4a8b-9001-7d8f84a0b257"
              }
            ]
          },
          "value": {
            "uuid": "c1f25be5-3f10-11e4-adec-0800271c1b75",
            "display": "Subcenter 1 (BAM)",
            "name": "Subcenter 1 (BAM)",
            "description": "Subcenter 1 (BAM)",
            "address1": null,
            "address2": null,
            "cityVillage": null,
            "stateProvince": null,
            "country": null,
            "postalCode": null,
            "latitude": null,
            "longitude": null,
            "countyDistrict": null,
            "address3": null,
            "address4": null,
            "address5": null,
            "address6": null,
            "tags": [
              {
                "uuid": "475d8fa3-5572-11e6-8be9-0800270d80ce",
                "display": "Visit Location",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/locationtag/475d8fa3-5572-11e6-8be9-0800270d80ce"
                  }
                ]
              },
              {
                "uuid": "b8bbf83e-645f-451f-8efe-a0db56f09676",
                "display": "Login Location",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/locationtag/b8bbf83e-645f-451f-8efe-a0db56f09676"
                  }
                ]
              }
            ],
            "parentLocation": null,
            "childLocations": [],
            "retired": false,
            "attributes": [
              {
                "uuid": "c1f2a697-3f10-11e4-adec-0800271c1b75",
                "display": "IdentifierSourceName: BAM",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/location/c1f25be5-3f10-11e4-adec-0800271c1b75/attribute/c1f2a697-3f10-11e4-adec-0800271c1b75"
                  }
                ]
              }
            ],
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
                "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/location/c1f25be5-3f10-11e4-adec-0800271c1b75"
              },
              {
                "rel": "full",
                "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/location/c1f25be5-3f10-11e4-adec-0800271c1b75?v=full"
              }
            ],
            "resourceVersion": "2.0"
          },
          "voided": false,
          "links": [
            {
              "rel": "self",
              "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/provider/c1c26908-3f10-11e4-adec-0800271c1b75/attribute/a3fa02b2-ea31-4f4c-81fe-137a8d5d6482"
            },
            {
              "rel": "full",
              "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/provider/c1c26908-3f10-11e4-adec-0800271c1b75/attribute/a3fa02b2-ea31-4f4c-81fe-137a8d5d6482?v=full"
            }
          ],
          "resourceVersion": "1.9"
        },
        {
          "display": "locations: Subcenter 2 (SEM)",
          "uuid": "5fc6817b-28dc-4d25-95fd-98d6cdf96d0b",
          "attributeType": {
            "uuid": "98bc7052-9c3d-4a8b-9001-7d8f84a0b257",
            "display": "locations",
            "links": [
              {
                "rel": "self",
                "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/providerattributetype/98bc7052-9c3d-4a8b-9001-7d8f84a0b257"
              }
            ]
          },
          "value": {
            "uuid": "c1e4950f-3f10-11e4-adec-0800271c1b75",
            "display": "Subcenter 2 (SEM)",
            "name": "Subcenter 2 (SEM)",
            "description": "Subcenter 2 (SEM)",
            "address1": null,
            "address2": null,
            "cityVillage": null,
            "stateProvince": null,
            "country": null,
            "postalCode": null,
            "latitude": null,
            "longitude": null,
            "countyDistrict": null,
            "address3": null,
            "address4": null,
            "address5": null,
            "address6": null,
            "tags": [
              {
                "uuid": "475d8fa3-5572-11e6-8be9-0800270d80ce",
                "display": "Visit Location",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/locationtag/475d8fa3-5572-11e6-8be9-0800270d80ce"
                  }
                ]
              },
              {
                "uuid": "b8bbf83e-645f-451f-8efe-a0db56f09676",
                "display": "Login Location",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/locationtag/b8bbf83e-645f-451f-8efe-a0db56f09676"
                  }
                ]
              }
            ],
            "parentLocation": null,
            "childLocations": [],
            "retired": false,
            "attributes": [
              {
                "uuid": "c1e4e4a5-3f10-11e4-adec-0800271c1b75",
                "display": "IdentifierSourceName: SEM",
                "links": [
                  {
                    "rel": "self",
                    "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/location/c1e4950f-3f10-11e4-adec-0800271c1b75/attribute/c1e4e4a5-3f10-11e4-adec-0800271c1b75"
                  }
                ]
              }
            ],
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
                "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/location/c1e4950f-3f10-11e4-adec-0800271c1b75"
              },
              {
                "rel": "full",
                "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/location/c1e4950f-3f10-11e4-adec-0800271c1b75?v=full"
              }
            ],
            "resourceVersion": "2.0"
          },
          "voided": false,
          "links": [
            {
              "rel": "self",
              "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/provider/c1c26908-3f10-11e4-adec-0800271c1b75/attribute/5fc6817b-28dc-4d25-95fd-98d6cdf96d0b"
            },
            {
              "rel": "full",
              "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/provider/c1c26908-3f10-11e4-adec-0800271c1b75/attribute/5fc6817b-28dc-4d25-95fd-98d6cdf96d0b?v=full"
            }
          ],
          "resourceVersion": "1.9"
        }
      ]
    });
    var apptAttr = drKishore.attrValue('Available for appointments');
    expect(apptAttr.length, 1);
    expect(apptAttr.elementAt(0), true);

    var locationAttrs = drKishore.attrValue('locations');
    expect(locationAttrs.length, 2);
    expect(locationAttrs.elementAt(0) is Map, true);
    expect(locationAttrs.elementAt(0)['name'], 'Subcenter 1 (BAM)'); //name of location
    expect(locationAttrs.elementAt(0)['uuid'], 'c1f25be5-3f10-11e4-adec-0800271c1b75'); //uuid of location
    expect(locationAttrs.elementAt(1)['name'], 'Subcenter 2 (SEM)'); //name of location
    expect(locationAttrs.elementAt(1)['uuid'], 'c1e4950f-3f10-11e4-adec-0800271c1b75'); //uuid of location
  });
}
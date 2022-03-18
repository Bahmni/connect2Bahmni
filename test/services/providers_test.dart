import 'dart:convert';

import 'package:connect2bahmni/domain/models/omrs_provider.dart';
import 'package:connect2bahmni/services/providers.dart';
import 'package:fhir/r4.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
    expect(result!.first['value'], true);

  });
}
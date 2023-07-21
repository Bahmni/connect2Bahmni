import 'package:connect2bahmni/domain/models/omrs_order.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var orderTypesJson = [
      {
        "uuid": "131168f4-15f5-102d-96e4-000c29c2a5d7",
        "display": "Drug Order",
        "conceptClasses": [
          {
            "uuid": "8d490dfc-c2cc-11de-8d13-0010c6dffd0f",
            "display": "Drug",
            "name": "Drug"
          }
        ]
      },
      {
        "uuid": "52a447d3-a64a-11e3-9aeb-50e549534c5e",
        "display": "Test Order",
        "conceptClasses": [

        ]
      },
      {
        "uuid": "aa3a6164-0e3e-11ee-9960-0242ac150002",
        "display": "Lab Order",
        "conceptClasses": [
          {
            "uuid": "8d4907b2-c2cc-11de-8d13-0010c6dffd0f",
            "display": "Test",
            "name": "Test"
          },
          {
            "uuid": "ab54d7d6-0e3e-11ee-9960-0242ac150002",
            "display": "LabTest",
            "name": "LabTest"
          },
          {
            "uuid": "8d492026-c2cc-11de-8d13-0010c6dffd0f",
            "display": "LabSet",
            "name": "LabSet"
          }
        ]
      },
      {
        "uuid": "aa3a7134-0e3e-11ee-9960-0242ac150002",
        "display": "Radiology Order",
        "conceptClasses": [
          {
            "uuid": "c6664c16-16b4-4bf4-91da-93f2ac88a0eb",
            "display": "Radiology/Imaging Procedure",
            "name": "Radiology/Imaging Procedure"
          }
        ]
      }
    ];

  test('should deserialize order types', () {
    var list = orderTypesJson.map((e) => OmrsOrderType.fromJson(e)).toList();
    expect(list.length, 4);
    expect(list[2].conceptClasses?.length, 3);
  });

  var orderJson = {
    "uuid": "176c93c9-56c8-4a58-8c64-da670206dc2d",
    "orderNumber": "ORD-39",
    "accessionNumber": null,
    "patient": {
      "uuid": "03cca96a-c390-4347-91d7-764faaa87c07",
      "display": "KA500011 - Harry Farry",
      "links": [
        {
          "rel": "self",
          "uri": "https://dev.gdobahmni.click/openmrs/ws/rest/v1/patient/03cca96a-c390-4347-91d7-764faaa87c07",
          "resourceAlias": "patient"
        }
      ]
    },
    "concept": {
      "uuid": "21AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
      "display": "Haemoglobin",
      "links": [
        {
          "rel": "self",
          "uri": "https://dev.gdobahmni.click/openmrs/ws/rest/v1/concept/21AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
          "resourceAlias": "concept"
        }
      ]
    },
    "action": "NEW",
    "careSetting": {
      "uuid": "6f0c9a92-6f24-11e3-af88-005056821db0",
      "name": "Outpatient",
      "description": "Out-patient care setting",
      "retired": false,
      "careSettingType": "OUTPATIENT",
      "display": "Outpatient",
      "links": [
        {
          "rel": "self",
          "uri": "https://dev.gdobahmni.click/openmrs/ws/rest/v1/caresetting/6f0c9a92-6f24-11e3-af88-005056821db0",
          "resourceAlias": "caresetting"
        },
        {
          "rel": "full",
          "uri": "https://dev.gdobahmni.click/openmrs/ws/rest/v1/caresetting/6f0c9a92-6f24-11e3-af88-005056821db0?v=full",
          "resourceAlias": "caresetting"
        }
      ],
      "resourceVersion": "1.10"
    },
    "previousOrder": null,
    "dateActivated": "2023-07-20T05:13:25.000+0000",
    "scheduledDate": null,
    "dateStopped": null,
    "autoExpireDate": "2023-07-20T06:13:25.000+0000",
    "encounter": {
      "uuid": "2f5ef226-cf3f-4555-911f-a74d9bb91d88",
      "display": "Consultation 07/20/2023",
      "links": [
        {
          "rel": "self",
          "uri": "https://dev.gdobahmni.click/openmrs/ws/rest/v1/encounter/2f5ef226-cf3f-4555-911f-a74d9bb91d88",
          "resourceAlias": "encounter"
        }
      ]
    },
    "orderer": {
      "uuid": "ac370e10-0e3e-11ee-9960-0242ac150002",
      "display": "superman - Super Man",
      "links": [
        {
          "rel": "self",
          "uri": "https://dev.gdobahmni.click/openmrs/ws/rest/v1/provider/ac370e10-0e3e-11ee-9960-0242ac150002",
          "resourceAlias": "provider"
        }
      ]
    },
    "orderReason": null,
    "orderReasonNonCoded": null,
    "orderType": {
      "uuid": "aa3a6164-0e3e-11ee-9960-0242ac150002",
      "display": "Lab Order",
      "name": "Lab Order",
      "javaClassName": "org.openmrs.Order",
      "retired": false,
      "description": "An order for laboratory tests",
      "conceptClasses": [
        {
          "uuid": "8d4907b2-c2cc-11de-8d13-0010c6dffd0f",
          "display": "Test",
          "links": [
            {
              "rel": "self",
              "uri": "https://dev.gdobahmni.click/openmrs/ws/rest/v1/conceptclass/8d4907b2-c2cc-11de-8d13-0010c6dffd0f",
              "resourceAlias": "conceptclass"
            }
          ]
        },
        {
          "uuid": "ab54d7d6-0e3e-11ee-9960-0242ac150002",
          "display": "LabTest",
          "links": [
            {
              "rel": "self",
              "uri": "https://dev.gdobahmni.click/openmrs/ws/rest/v1/conceptclass/ab54d7d6-0e3e-11ee-9960-0242ac150002",
              "resourceAlias": "conceptclass"
            }
          ]
        },
        {
          "uuid": "8d492026-c2cc-11de-8d13-0010c6dffd0f",
          "display": "LabSet",
          "links": [
            {
              "rel": "self",
              "uri": "https://dev.gdobahmni.click/openmrs/ws/rest/v1/conceptclass/8d492026-c2cc-11de-8d13-0010c6dffd0f",
              "resourceAlias": "conceptclass"
            }
          ]
        }
      ],
      "parent": null,
      "links": [
        {
          "rel": "self",
          "uri": "https://dev.gdobahmni.click/openmrs/ws/rest/v1/ordertype/aa3a6164-0e3e-11ee-9960-0242ac150002",
          "resourceAlias": "ordertype"
        },
        {
          "rel": "full",
          "uri": "https://dev.gdobahmni.click/openmrs/ws/rest/v1/ordertype/aa3a6164-0e3e-11ee-9960-0242ac150002?v=full",
          "resourceAlias": "ordertype"
        }
      ],
      "resourceVersion": "1.10"
    },
    "urgency": "ROUTINE",
    "instructions": null,
    "commentToFulfiller": "Very low",
    "display": "Haemoglobin",
    "auditInfo": {
      "creator": {
        "uuid": "ac36f45c-0e3e-11ee-9960-0242ac150002",
        "display": "superman",
        "links": [
          {
            "rel": "self",
            "uri": "https://dev.gdobahmni.click/openmrs/ws/rest/v1/user/ac36f45c-0e3e-11ee-9960-0242ac150002",
            "resourceAlias": "user"
          }
        ]
      },
      "dateCreated": "2023-07-20T05:13:25.000+0000",
      "changedBy": null,
      "dateChanged": null
    },
    "links": [
      {
        "rel": "self",
        "uri": "https://dev.gdobahmni.click/openmrs/ws/rest/v1/order/176c93c9-56c8-4a58-8c64-da670206dc2d",
        "resourceAlias": "order"
      }
    ],
    "type": "order",
    "resourceVersion": "1.10"
  };
  test('should deserialize order', () {
    var omrsOrder = OmrsOrder.fromJson(orderJson);
    expect(omrsOrder.patient?.uuid, '03cca96a-c390-4347-91d7-764faaa87c07');
    expect(omrsOrder.orderType?.name, 'Lab Order');
    expect(omrsOrder.concept?.display, 'Haemoglobin');
    expect(omrsOrder.concept?.uuid, '21AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
    expect(omrsOrder.orderType?.conceptClasses?[0].display, 'Test');
  });

}
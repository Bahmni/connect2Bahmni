

import 'package:connect2bahmni/domain/models/session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Session user de-serialization test with recent patients', () {
      var session = Session.fromJson({
        "sessionId": "CC1D15D62B3024F4A2F9364AF34E73AC",
        "authenticated": true,
        "user": {
          "uuid": "c1c21e11-3f10-11e4-adec-0800271c1b75",
          "display": "superman",
          "username": "superman",
          "systemId": "superman",
          "userProperties": {
            "defaultLocale": "en",
            "favouriteObsTemplates": "",
            "recentlyViewedPatients": "[{\"uuid\":\"34d6dc9b-1d2f-4360-9c60-31c1e267a247\",\"name\":\"Rutgar Ragos\",\"identifier\":\"GAN203013\"},{\"uuid\":\"533d14b8-737b-497e-918d-7b040319af77\",\"name\":\"Test Minikube\",\"identifier\":\"GAN203012\"},{\"uuid\":\"bf379289-62b7-47b3-ab7b-5186cb6fc46c\",\"name\":\"MARIAM MSAFIRI\",\"identifier\":\"SEM203001\"},{\"uuid\":\"dc9444c6-ad55-4200-b6e9-407e025eb948\",\"name\":\"Test Radiology\",\"identifier\":\"GAN203010\"},{\"uuid\":\"3ae1ee52-e9b2-4934-876d-30711c0e3e2f\",\"name\":\"Test Hypertension\",\"identifier\":\"GAN203009\"},{\"uuid\":\"f5a00c0c-6230-4a13-b794-18ee0c137aa9\",\"name\":\"Test TB\",\"identifier\":\"GAN203008\"},{\"uuid\":\"0b573f9a-d75d-47fe-a655-043dc2f6b4fa\",\"name\":\"Test Diabetes\",\"identifier\":\"GAN203007\"},{\"uuid\":\"1dfff08c-141b-46df-b6a2-6b69080a5000\",\"name\":\"Test Hyperthyroidism\",\"identifier\":\"GAN203006\"},{\"uuid\":\"9a133946-e529-4d2d-a376-ce0045f0a685\",\"name\":\"Sample Two\",\"identifier\":\"GAN203005\"},{\"uuid\":\"4177d31e-b495-423d-b4ef-a454cc95c0d1\",\"name\":\"SAmple one\",\"identifier\":\"GAN203004\"}]",
            "loginAttempts": "0",
            "favouriteWards": "General Ward###Labour Ward"
          },
          "person": {
            "uuid": "c1bc22a5-3f10-11e4-adec-0800271c1b75",
            "display": "Super Man"
          },
          "privileges": [
            {
              "uuid": "4eca6197-3f10-11e4-adec-0800271c1b75",
              "display": "View Forms",
              "name": "View Forms"
            },
            {
              "uuid": "6f5ec66c-3f10-11e4-adec-0800271c1b75",
              "display": "View HL7 Source",
              "name": "View HL7 Source"
            },
          ],
          "roles": [
            {
              "uuid": "bb2eecdc-e0b0-11e7-aec6-02e6b64603ba",
              "display": "Appointments:ReadOnly",
              "name": "Appointments:ReadOnly"
            },
            {
              "uuid": "697875ea-a662-11e6-91e9-0800270d80ce",
              "display": "SuperAdmin",
              "name": "SuperAdmin"
            },
            {
              "uuid": "8d94f280-c2cc-11de-8d13-0010c6dffd0f",
              "display": "Provider",
              "name": "Provider"
            }
          ],
          "links": [
            {
              "rel": "self",
              "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/user/c1c21e11-3f10-11e4-adec-0800271c1b75"
            },
            {
              "rel": "default",
              "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/user/c1c21e11-3f10-11e4-adec-0800271c1b75?v=default"
            }
          ]
        },
        "locale": "en",
        "allowedLocales": [
          "en",
          "es",
          "fr",
          "it",
          "pt_BR"
        ],
        "sessionLocation": null,
        "currentProvider": {
          "uuid": "c1c26908-3f10-11e4-adec-0800271c1b75",
          "display": "superman - Super Man",
          "links": [
            {
              "rel": "self",
              "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/provider/c1c26908-3f10-11e4-adec-0800271c1b75"
            }
          ]
        }
      });
      var recentlyViewedPatients = session.user.recentlyViewedPatients();
      expect(recentlyViewedPatients.length, 10);
      expect(recentlyViewedPatients[0].display, 'Rutgar Ragos');
  });

  test('Session user de-serialization test without recent patients', () {
    var session = Session.fromJson({
      "sessionId": "CC1D15D62B3024F4A2F9364AF34E73AC",
      "authenticated": true,
      "user": {
        "uuid": "c1c21e11-3f10-11e4-adec-0800271c1b75",
        "display": "superman",
        "username": "superman",
        "systemId": "superman",
        "userProperties": {
          "defaultLocale": "en",
          "favouriteObsTemplates": "",
          "recentlyViewedPatients": null,
          "loginAttempts": "0",
          "favouriteWards": "General Ward###Labour Ward"
        },
        "person": {
          "uuid": "c1bc22a5-3f10-11e4-adec-0800271c1b75",
          "display": "Super Man"
        },
        "privileges": [
          {
            "uuid": "4eca6197-3f10-11e4-adec-0800271c1b75",
            "display": "View Forms",
            "name": "View Forms"
          },
          {
            "uuid": "6f5ec66c-3f10-11e4-adec-0800271c1b75",
            "display": "View HL7 Source",
            "name": "View HL7 Source"
          },
        ],
        "roles": [
          {
            "uuid": "bb2eecdc-e0b0-11e7-aec6-02e6b64603ba",
            "display": "Appointments:ReadOnly",
            "name": "Appointments:ReadOnly"
          },
          {
            "uuid": "697875ea-a662-11e6-91e9-0800270d80ce",
            "display": "SuperAdmin",
            "name": "SuperAdmin"
          },
          {
            "uuid": "8d94f280-c2cc-11de-8d13-0010c6dffd0f",
            "display": "Provider",
            "name": "Provider"
          }
        ],
        "links": [
          {
            "rel": "self",
            "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/user/c1c21e11-3f10-11e4-adec-0800271c1b75"
          },
          {
            "rel": "default",
            "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/user/c1c21e11-3f10-11e4-adec-0800271c1b75?v=default"
          }
        ]
      },
      "locale": "en",
      "allowedLocales": [
        "en",
        "es",
        "fr",
        "it",
        "pt_BR"
      ],
      "sessionLocation": null,
      "currentProvider": {
        "uuid": "c1c26908-3f10-11e4-adec-0800271c1b75",
        "display": "superman - Super Man",
        "links": [
          {
            "rel": "self",
            "uri": "http://next.mybahmni.org/openmrs/ws/rest/v1/provider/c1c26908-3f10-11e4-adec-0800271c1b75"
          }
        ]
      }
    });
    var recentlyViewedPatients = session.user.recentlyViewedPatients();
    expect(recentlyViewedPatients.length, 0);
    //expect(recentlyViewedPatients[0].display, 'Rutgar Ragos');
  });

}
import 'package:fhir/r4.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('something', () async {
    var bundleText = {
      "resourceType": "Bundle",
      "id": "f3f45990-5a79-4607-a63a-d9c510797595",
      "meta": {
        "lastUpdated": "2022-03-22T17:28:35.794+00:00"
      },
      "type": "searchset",
      "total": 6,
      "link": [
        {
          "relation": "self",
          "url": "http://next.mybahmni.org/openmrs/ws/fhir2/R4/Location?_tag=Login%20Location"
        }
      ],
      "entry": [
        {
          "fullUrl": "http://next.mybahmni.org/openmrs/ws/fhir2/R4/Location/c1e4950f-3f10-11e4-adec-0800271c1b75",
          "resource": {
            "resourceType": "Location",
            "id": "c1e4950f-3f10-11e4-adec-0800271c1b75",
            "meta": {
              "tag": [
                {
                  "system": "http://fhir.openmrs.org/ext/location-tag",
                  "code": "Visit Location",
                  "display": "Visit Location"
                },
                {
                  "system": "http://fhir.openmrs.org/ext/location-tag",
                  "code": "Login Location",
                  "display": "When a user logs in and chooses a session location, they may only choose one with this tag"
                }
              ]
            },
            "text": {
              "status": "generated",
              "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>Subcenter 2 (SEM)</h2></div>"
            },
            "contained": [
              {
                "resourceType": "Provenance",
                "id": "53acea35-b082-448f-ac99-be328eff8c6e",
                "recorded": "2014-09-18T00:00:00.000+00:00",
                "activity": {
                  "coding": [
                    {
                      "system": "http://terminology.hl7.org/CodeSystemv3-DataOperation",
                      "code": "CREATE",
                      "display": "create"
                    }
                  ]
                },
                "agent": [
                  {
                    "type": {
                      "coding": [
                        {
                          "system": "http://terminology.hl7.org/CodeSystemprovenance-participant-type",
                          "code": "author",
                          "display": "Author"
                        }
                      ]
                    },
                    "role": [
                      {
                        "coding": [
                          {
                            "system": "http://terminology.hl7.org/CodeSystemv3-ParticipationType",
                            "code": "AUT",
                            "display": "author"
                          }
                        ]
                      }
                    ],
                    "who": {
                      "reference": "Practitioner/62a3b753-3f10-11e4-adec-0800271c1b75",
                      "type": "Practitioner",
                      "display": "Super User"
                    }
                  }
                ]
              }
            ],
            "status": "active",
            "name": "Subcenter 2 (SEM)",
            "description": "Subcenter 2 (SEM)"
          }
        },
        {
          "fullUrl": "http://next.mybahmni.org/openmrs/ws/fhir2/R4/Location/c1f25be5-3f10-11e4-adec-0800271c1b75",
          "resource": {
            "resourceType": "Location",
            "id": "c1f25be5-3f10-11e4-adec-0800271c1b75",
            "meta": {
              "tag": [
                {
                  "system": "http://fhir.openmrs.org/ext/location-tag",
                  "code": "Visit Location",
                  "display": "Visit Location"
                },
                {
                  "system": "http://fhir.openmrs.org/ext/location-tag",
                  "code": "Login Location",
                  "display": "When a user logs in and chooses a session location, they may only choose one with this tag"
                }
              ]
            },
            "text": {
              "status": "generated",
              "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>Subcenter 1 (BAM)</h2></div>"
            },
            "contained": [
              {
                "resourceType": "Provenance",
                "id": "4e050393-85a2-40b7-a9b8-bb1d90251d17",
                "recorded": "2014-09-18T00:00:00.000+00:00",
                "activity": {
                  "coding": [
                    {
                      "system": "http://terminology.hl7.org/CodeSystemv3-DataOperation",
                      "code": "CREATE",
                      "display": "create"
                    }
                  ]
                },
                "agent": [
                  {
                    "type": {
                      "coding": [
                        {
                          "system": "http://terminology.hl7.org/CodeSystemprovenance-participant-type",
                          "code": "author",
                          "display": "Author"
                        }
                      ]
                    },
                    "role": [
                      {
                        "coding": [
                          {
                            "system": "http://terminology.hl7.org/CodeSystemv3-ParticipationType",
                            "code": "AUT",
                            "display": "author"
                          }
                        ]
                      }
                    ],
                    "who": {
                      "reference": "Practitioner/62a3b753-3f10-11e4-adec-0800271c1b75",
                      "type": "Practitioner",
                      "display": "Super User"
                    }
                  }
                ]
              }
            ],
            "status": "active",
            "name": "Subcenter 1 (BAM)",
            "description": "Subcenter 1 (BAM)"
          }
        },
        {
          "fullUrl": "http://next.mybahmni.org/openmrs/ws/fhir2/R4/Location/c5854fd7-3f12-11e4-adec-0800271c1b75",
          "resource": {
            "resourceType": "Location",
            "id": "c5854fd7-3f12-11e4-adec-0800271c1b75",
            "meta": {
              "lastUpdated": "2017-06-07T11:35:34.000+00:00",
              "tag": [
                {
                  "system": "http://fhir.openmrs.org/ext/location-tag",
                  "code": "Visit Location",
                  "display": "Visit Location"
                },
                {
                  "system": "http://fhir.openmrs.org/ext/location-tag",
                  "code": "Login Location",
                  "display": "When a user logs in and chooses a session location, they may only choose one with this tag"
                }
              ]
            },
            "text": {
              "status": "generated",
              "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>Registration Desk</h2><h2><span>Chattisgarh </span></h2></div>"
            },
            "contained": [
              {
                "resourceType": "Provenance",
                "id": "6713b349-5373-4cc0-97aa-83cf048db5b9",
                "recorded": "2014-09-18T14:34:18.000+00:00",
                "activity": {
                  "coding": [
                    {
                      "system": "http://terminology.hl7.org/CodeSystemv3-DataOperation",
                      "code": "CREATE",
                      "display": "create"
                    }
                  ]
                },
                "agent": [
                  {
                    "type": {
                      "coding": [
                        {
                          "system": "http://terminology.hl7.org/CodeSystemprovenance-participant-type",
                          "code": "author",
                          "display": "Author"
                        }
                      ]
                    },
                    "role": [
                      {
                        "coding": [
                          {
                            "system": "http://terminology.hl7.org/CodeSystemv3-ParticipationType",
                            "code": "AUT",
                            "display": "author"
                          }
                        ]
                      }
                    ],
                    "who": {
                      "reference": "Practitioner/62a3b753-3f10-11e4-adec-0800271c1b75",
                      "type": "Practitioner",
                      "display": "Super User"
                    }
                  }
                ]
              },
              {
                "resourceType": "Provenance",
                "id": "ceda8ba0-ec26-4259-9dc4-5d80f493eb4c",
                "recorded": "2017-06-07T11:35:34.000+00:00",
                "activity": {
                  "coding": [
                    {
                      "system": "http://terminology.hl7.org/CodeSystemv3-DataOperation",
                      "code": "UPDATE",
                      "display": "revise"
                    }
                  ]
                },
                "agent": [
                  {
                    "type": {
                      "coding": [
                        {
                          "system": "http://terminology.hl7.org/CodeSystemprovenance-participant-type",
                          "code": "author",
                          "display": "Author"
                        }
                      ]
                    },
                    "role": [
                      {
                        "coding": [
                          {
                            "system": "http://terminology.hl7.org/CodeSystemv3-ParticipationType",
                            "code": "AUT",
                            "display": "author"
                          }
                        ]
                      }
                    ],
                    "who": {
                      "reference": "Practitioner/c1c21e11-3f10-11e4-adec-0800271c1b75",
                      "type": "Practitioner",
                      "display": "Super Man"
                    }
                  }
                ]
              }
            ],
            "status": "active",
            "name": "Registration Desk",
            "address": {
              "state": "Chattisgarh"
            }
          }
        },
        {
          "fullUrl": "http://next.mybahmni.org/openmrs/ws/fhir2/R4/Location/c58e12ed-3f12-11e4-adec-0800271c1b75",
          "resource": {
            "resourceType": "Location",
            "id": "c58e12ed-3f12-11e4-adec-0800271c1b75",
            "meta": {
              "lastUpdated": "2017-06-07T16:18:05.000+00:00",
              "tag": [
                {
                  "system": "http://fhir.openmrs.org/ext/location-tag",
                  "code": "Visit Location",
                  "display": "Visit Location"
                },
                {
                  "system": "http://fhir.openmrs.org/ext/location-tag",
                  "code": "Login Location",
                  "display": "When a user logs in and chooses a session location, they may only choose one with this tag"
                },
                {
                  "system": "http://fhir.openmrs.org/ext/location-tag",
                  "code": "Appointment Location",
                  "display": "When a user user creates a appointment service and chooses a location, they may only choose one with this tag"
                }
              ]
            },
            "text": {
              "status": "generated",
              "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>OPD-1</h2><h2><span>Chattisgarh </span></h2></div>"
            },
            "contained": [
              {
                "resourceType": "Provenance",
                "id": "ad797a3b-6a4d-4b0b-8d04-c1f5b0e2c96d",
                "recorded": "2014-09-18T14:34:18.000+00:00",
                "activity": {
                  "coding": [
                    {
                      "system": "http://terminology.hl7.org/CodeSystemv3-DataOperation",
                      "code": "CREATE",
                      "display": "create"
                    }
                  ]
                },
                "agent": [
                  {
                    "type": {
                      "coding": [
                        {
                          "system": "http://terminology.hl7.org/CodeSystemprovenance-participant-type",
                          "code": "author",
                          "display": "Author"
                        }
                      ]
                    },
                    "role": [
                      {
                        "coding": [
                          {
                            "system": "http://terminology.hl7.org/CodeSystemv3-ParticipationType",
                            "code": "AUT",
                            "display": "author"
                          }
                        ]
                      }
                    ],
                    "who": {
                      "reference": "Practitioner/62a3b753-3f10-11e4-adec-0800271c1b75",
                      "type": "Practitioner",
                      "display": "Super User"
                    }
                  }
                ]
              },
              {
                "resourceType": "Provenance",
                "id": "e7f0c361-8d34-482c-ad3d-0442a6fab4e0",
                "recorded": "2017-06-07T16:18:05.000+00:00",
                "activity": {
                  "coding": [
                    {
                      "system": "http://terminology.hl7.org/CodeSystemv3-DataOperation",
                      "code": "UPDATE",
                      "display": "revise"
                    }
                  ]
                },
                "agent": [
                  {
                    "type": {
                      "coding": [
                        {
                          "system": "http://terminology.hl7.org/CodeSystemprovenance-participant-type",
                          "code": "author",
                          "display": "Author"
                        }
                      ]
                    },
                    "role": [
                      {
                        "coding": [
                          {
                            "system": "http://terminology.hl7.org/CodeSystemv3-ParticipationType",
                            "code": "AUT",
                            "display": "author"
                          }
                        ]
                      }
                    ],
                    "who": {
                      "reference": "Practitioner/c1c21e11-3f10-11e4-adec-0800271c1b75",
                      "type": "Practitioner",
                      "display": "Super Man"
                    }
                  }
                ]
              }
            ],
            "status": "active",
            "name": "OPD-1",
            "address": {
              "state": "Chattisgarh"
            }
          }
        },
        {
          "fullUrl": "http://next.mybahmni.org/openmrs/ws/fhir2/R4/Location/baf7bd38-d225-11e4-9c67-080027b662ec",
          "resource": {
            "resourceType": "Location",
            "id": "baf7bd38-d225-11e4-9c67-080027b662ec",
            "meta": {
              "lastUpdated": "2017-06-07T16:15:36.000+00:00",
              "tag": [
                {
                  "system": "http://fhir.openmrs.org/ext/location-tag",
                  "code": "Visit Location",
                  "display": "Visit Location"
                },
                {
                  "system": "http://fhir.openmrs.org/ext/location-tag",
                  "code": "Login Location",
                  "display": "When a user logs in and chooses a session location, they may only choose one with this tag"
                },
                {
                  "system": "http://fhir.openmrs.org/ext/location-tag",
                  "code": "Admission Location",
                  "display": "General Ward Patients"
                }
              ]
            },
            "text": {
              "status": "generated",
              "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>General Ward</h2><h2><span>Chattisgarh </span></h2></div>"
            },
            "contained": [
              {
                "resourceType": "Provenance",
                "id": "c7b14a7a-8af6-4154-8d59-dd03bfcf32dc",
                "recorded": "2015-03-24T18:30:22.000+00:00",
                "activity": {
                  "coding": [
                    {
                      "system": "http://terminology.hl7.org/CodeSystemv3-DataOperation",
                      "code": "CREATE",
                      "display": "create"
                    }
                  ]
                },
                "agent": [
                  {
                    "type": {
                      "coding": [
                        {
                          "system": "http://terminology.hl7.org/CodeSystemprovenance-participant-type",
                          "code": "author",
                          "display": "Author"
                        }
                      ]
                    },
                    "role": [
                      {
                        "coding": [
                          {
                            "system": "http://terminology.hl7.org/CodeSystemv3-ParticipationType",
                            "code": "AUT",
                            "display": "author"
                          }
                        ]
                      }
                    ],
                    "who": {
                      "reference": "Practitioner/62a3b753-3f10-11e4-adec-0800271c1b75",
                      "type": "Practitioner",
                      "display": "Super User"
                    }
                  }
                ]
              },
              {
                "resourceType": "Provenance",
                "id": "34963d46-a63c-4e24-85c9-9751d322ce0e",
                "recorded": "2017-06-07T16:15:36.000+00:00",
                "activity": {
                  "coding": [
                    {
                      "system": "http://terminology.hl7.org/CodeSystemv3-DataOperation",
                      "code": "UPDATE",
                      "display": "revise"
                    }
                  ]
                },
                "agent": [
                  {
                    "type": {
                      "coding": [
                        {
                          "system": "http://terminology.hl7.org/CodeSystemprovenance-participant-type",
                          "code": "author",
                          "display": "Author"
                        }
                      ]
                    },
                    "role": [
                      {
                        "coding": [
                          {
                            "system": "http://terminology.hl7.org/CodeSystemv3-ParticipationType",
                            "code": "AUT",
                            "display": "author"
                          }
                        ]
                      }
                    ],
                    "who": {
                      "reference": "Practitioner/c1c21e11-3f10-11e4-adec-0800271c1b75",
                      "type": "Practitioner",
                      "display": "Super Man"
                    }
                  }
                ]
              }
            ],
            "status": "active",
            "name": "General Ward",
            "description": "General Ward",
            "address": {
              "state": "Chattisgarh"
            }
          }
        },
        {
          "fullUrl": "http://next.mybahmni.org/openmrs/ws/fhir2/R4/Location/bb0e512e-d225-11e4-9c67-080027b662ec",
          "resource": {
            "resourceType": "Location",
            "id": "bb0e512e-d225-11e4-9c67-080027b662ec",
            "meta": {
              "lastUpdated": "2017-06-07T16:17:28.000+00:00",
              "tag": [
                {
                  "system": "http://fhir.openmrs.org/ext/location-tag",
                  "code": "Visit Location",
                  "display": "Visit Location"
                },
                {
                  "system": "http://fhir.openmrs.org/ext/location-tag",
                  "code": "Login Location",
                  "display": "When a user logs in and chooses a session location, they may only choose one with this tag"
                },
                {
                  "system": "http://fhir.openmrs.org/ext/location-tag",
                  "code": "Admission Location",
                  "display": "General Ward Patients"
                }
              ]
            },
            "text": {
              "status": "generated",
              "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>Labour Ward</h2><h2><span>Chattisgarh </span></h2></div>"
            },
            "contained": [
              {
                "resourceType": "Provenance",
                "id": "be0efd34-668e-4663-86a9-e9821f07e734",
                "recorded": "2015-03-24T18:30:22.000+00:00",
                "activity": {
                  "coding": [
                    {
                      "system": "http://terminology.hl7.org/CodeSystemv3-DataOperation",
                      "code": "CREATE",
                      "display": "create"
                    }
                  ]
                },
                "agent": [
                  {
                    "type": {
                      "coding": [
                        {
                          "system": "http://terminology.hl7.org/CodeSystemprovenance-participant-type",
                          "code": "author",
                          "display": "Author"
                        }
                      ]
                    },
                    "role": [
                      {
                        "coding": [
                          {
                            "system": "http://terminology.hl7.org/CodeSystemv3-ParticipationType",
                            "code": "AUT",
                            "display": "author"
                          }
                        ]
                      }
                    ],
                    "who": {
                      "reference": "Practitioner/62a3b753-3f10-11e4-adec-0800271c1b75",
                      "type": "Practitioner",
                      "display": "Super User"
                    }
                  }
                ]
              },
              {
                "resourceType": "Provenance",
                "id": "0b88ff89-bbef-4f57-b4ac-fd1789272c2a",
                "recorded": "2017-06-07T16:17:28.000+00:00",
                "activity": {
                  "coding": [
                    {
                      "system": "http://terminology.hl7.org/CodeSystemv3-DataOperation",
                      "code": "UPDATE",
                      "display": "revise"
                    }
                  ]
                },
                "agent": [
                  {
                    "type": {
                      "coding": [
                        {
                          "system": "http://terminology.hl7.org/CodeSystemprovenance-participant-type",
                          "code": "author",
                          "display": "Author"
                        }
                      ]
                    },
                    "role": [
                      {
                        "coding": [
                          {
                            "system": "http://terminology.hl7.org/CodeSystemv3-ParticipationType",
                            "code": "AUT",
                            "display": "author"
                          }
                        ]
                      }
                    ],
                    "who": {
                      "reference": "Practitioner/c1c21e11-3f10-11e4-adec-0800271c1b75",
                      "type": "Practitioner",
                      "display": "Super Man"
                    }
                  }
                ]
              }
            ],
            "status": "active",
            "name": "Labour Ward",
            "description": "General Ward",
            "address": {
              "state": "Chattisgarh"
            }
          }
        }
      ]
    };
      Bundle bundle = Bundle.fromJson(bundleText);
      expect(bundle.type?.value, "searchset");
  }, skip: 'TODO: to fix with later version of FHIR2 module as 1.3.0 does not set provenance.target');

}
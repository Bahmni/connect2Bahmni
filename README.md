# Connect2

This is a simple Flutter application integrating with Bahmni/OpenMRS. Depending on the capability of the server, certain features may not work.
As of now, this project is experimental, only a starting point and far from being used in production.


## Getting Started
### Setup dev environment   
- For help getting started with Flutter, view  [online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.
- [New to flutter?](https://flutter.dev/docs/get-started/codelab)
- [Flutter samples](https://flutter.dev/docs/cookbook)

### Development
- Git clone and load onto Android Studio
- run > flutter pub get
- create a ".env" file at project root, add properties

| property                     | description                                                                                   | example value                                                                       | 
|------------------------------|-----------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|
| bahmni.server                | HTTPS and without trailing slash                                                              | https://dev.lite.mybahmni.in (use https://10.0.2.2 if running on https://localhost) |
| bahmni.list.activePatients   | ref to the list queue identifier on Bahmni                                                    | emrapi.sqlSearch.activePatients                                                     |
| app.allowedVisitTypes        | subset of visit types on server, matched by name                                              | OPD,IPD,FIELD                                                                       |  
| app.allowedEncTypes          | subset of encounter types on server, matched by name                                          | Consultation,REG,TRANSFER                                                           |  
| app.conceptConsultationNotes | uuid of the obs concept on server (datatype = text) for recording consult notes               | 81d6e852-3f10-11e4-adec-0800271c1b75                                                |
| app.conceptCodedDiagnosis    | uuid of the obs concept on server (datatype = text) for recording coded diagnosis             | 81d6e852-3f10-11e4-adec-0800271c1b75                                                |
| app.additionalIdentifiers    | additional identifiers for patient to be captured, matched by name                            | ABHA Number,RCH_ID                                                                  |
| app.patientAttributes        | additional attributes for patient to be captured, matched by name (* denotes mandatory)       | phoneNumber*,email                                                                  |
| abdm.identifiers             | Linkages for ABHA  identifiers (India Only). If enabled triggers ABHA linking. Not modifiable | ABHA Number,ABHA Address                                                            |


## Build
- flutter build apk --debug

# Connect2

This is a simple Flutter application integrating with Bahmni/OpenMRS. Depending on the capability of the server, certain features may not work.
As of now, this project is experimental, only a starting point and far from being used in production.


## Getting Started
### Setup dev environment   
- For help getting started with Flutter, view  [online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.
- [New to flutter?](https://flutter.dev/docs/get        -started/codelab)
- [Flutter samples](https://flutter.dev/docs/cookbook)

### Development
- Git clone and load onto Android Studio
- run > flutter pub get
- create a ".env" file at project root, add properties

| property | description | example value | 
| ----------- | ----------- | ----------- |
| bahmni.server | HTTPS and without trailing slash | https://dev.lite.mybahmni.in |
| app.allowedVisitTypes | subset of visit types on server, matched by name | OPD,IPD,FIELD  | 
| app.allowedEncTypes| subset of encounter types on server, matched by name | Consultation,REG,TRANSFER | 
| app.allowedEncTypes| subset of encounter types on server, matched by name | Consultation,REG,TRANSFER |  
| app.conceptConsultationNotes | uuid of the obs concept (datatype = text) for recording consult notes | 81d6e852-3f10-11e4-adec-0800271c1b75 |


## Build
- flutter build apk --debug

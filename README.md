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

| property | value | description |
| ----------- | ----------- | ----------- |
| bahmni.server | http://www.example.org | no trailing slash |
| app.allowedVisitTypes | OPD,IPD,FIELD  | subset of visit types on server, matched by name |
| app.allowedEncTypes| Consultation,REG,TRANSFER | subset of encounter types on server, matched by name |


## Build
- flutter build apk --debug
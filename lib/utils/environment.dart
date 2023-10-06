import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static const String defaultServer = 'https://dev.lite.mybahmni.in';
  String? bahmniServerUrl;
  String? activePatientListName;
  String? dispenseMedsListName;
  String? flowSheetConcepts;
  String? abdmIdentifiers;
  String? additionalIdentifiers;
  String? patientAttributeNames;
  String? allowedVisitTypes;
  String? allowedEncounterTypes;
  String? obsFormNames;
  String? consultationNoteConcept;

  static final Environment _instance = Environment._internal();
  //static final instance = Environment._();
  factory Environment() => _instance;
  Environment._internal();


  void initialize() async {
    await dotenv.load(fileName: ".env");
    bahmniServerUrl = dotenv.get('bahmni.server', fallback: defaultServer);
    activePatientListName = dotenv.get('bahmni.list.activePatients', fallback: 'emrapi.sqlSearch.activePatients');
    dispenseMedsListName = dotenv.get('bahmni.list.patientsToDispenseMeds', fallback: 'emrapi.sqlSearch.activePatients');
    flowSheetConcepts = dotenv.get('app.flowSheet.concepts', fallback: '');
    abdmIdentifiers = dotenv.get('abdm.identifiers', fallback: '');
    additionalIdentifiers = dotenv.get('app.additionalIdentifiers', fallback: '');
    patientAttributeNames = dotenv.get('app.patientAttributes', fallback: '');
    allowedVisitTypes = dotenv.get('app.allowedVisitTypes', fallback: '');
    allowedEncounterTypes = dotenv.get('app.allowedEncTypes', fallback: '');
    obsFormNames = dotenv.get('bahmni.obsForms', fallback: '');
    consultationNoteConcept = dotenv.get('app.conceptConsultationNotes', fallback: '');
  }
}
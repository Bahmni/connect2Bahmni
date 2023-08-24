import '../domain/models/dosage_instruction.dart';
import '../domain/models/form_definition.dart';
import '../domain/models/omrs_identifier_type.dart';
import '../domain/models/omrs_order.dart';
import '../domain/models/omrs_person_attribute.dart';
import '../services/emr_api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../domain/models/omrs_concept.dart';
import '../domain/models/omrs_encounter_type.dart';
import '../services/concept_dictionary.dart';
import '../domain/models/omrs_visit_type.dart';
import '../services/encounters.dart';
import '../services/forms.dart';
import '../services/patients.dart';

class MetaProvider with ChangeNotifier {
  OmrsConcept? _conditionCertainty;
  OmrsConcept? _diagnosisOrder;
  OmrsConcept? _consultNoteConcept;
  List<OmrsVisitType>? _visitTypes;
  List<OmrsEncounterType>? _encTypes;
  List<OmrsIdentifierType>? _patientIdentifierTypes;
  List<OmrsPersonAttributeType>? _personAttrTypes;
  List<FormResource>? _publishedForms;
  List<OmrsOrderType>? _orderTypes;
  DoseAttributes? _dosageInstructions;

  OmrsConcept? get conditionCertainty => _conditionCertainty;

  OmrsConcept? get diagnosisOrder => _diagnosisOrder;
  OmrsConcept? get consultNoteConcept => _consultNoteConcept;
  List<OmrsVisitType>? get visitTypes => _visitTypes;
  List<OmrsEncounterType>? get encTypes => _encTypes;
  List<OmrsIdentifierType>? get patientIdentifierTypes => _patientIdentifierTypes;
  OmrsIdentifierType? get primaryPatientIdentifierType => _patientIdentifierTypes?.firstWhere((element) => element.primary == true);
  List<OmrsPersonAttributeType>? get personAttrTypes => _personAttrTypes;
  List<FormResource>? get publishedForms => _publishedForms;
  List<OmrsOrderType>? get orderTypes => _orderTypes;
  DoseAttributes? get dosageInstruction => _dosageInstructions;

  List<OmrsVisitType>? get allowedVisitTypes {
    if (_visitTypes == null) return [];
    var allowedList = dotenv.get('app.allowedVisitTypes', fallback: '')
        .split(',')
        .map((e) => e.trim().toLowerCase()).toList();
    return _visitTypes!.where((e) => allowedList.contains(e.display?.toLowerCase())).toList();
  }

  List<OmrsEncounterType>? get allowedEncTypes {
    if (_encTypes == null) return [];
    var allowedList = dotenv.get('app.allowedEncTypes', fallback: '')
        .split(',')
        .map((e) => e.trim().toLowerCase()).toList();
    return _encTypes!.where((e) => allowedList.contains(e.display?.toLowerCase())).toList();
  }

  List<FormResource> get observationForms {
    if (_publishedForms == null) return [];
    var allowedList = dotenv.get('bahmni.obsForms', fallback: '')
        .split(',')
        .map((e) => e.trim().toLowerCase()).toList();
    return _publishedForms!.where((form) => allowedList.contains(form.name.toLowerCase())).toList();
  }

  void initialize() {
    ConceptDictionary().fetchDiagnosisCertainty().then((value) {
      _conditionCertainty = value;
      notifyListeners();
    }).onError((error, stackTrace) => _logError(error));
    ConceptDictionary().fetchDiagnosisOrder().then((value) {
      _diagnosisOrder = value;
      notifyListeners();
    }).onError((error, stackTrace) => _logError(error));
    Encounters().visitTypes().then((value) {
      _visitTypes = value;
      notifyListeners();
    }).catchError((e) => _logError(e));

    Encounters().encTypes().then((value) {
      _encTypes = value;
      notifyListeners();
    }).catchError((e) => _logError(e));

    Patients().identifierTypes().then((value) {
      _patientIdentifierTypes = value;
      notifyListeners();
    }).catchError((e) => _logError(e));

    Patients().attributeTypes().then((value) {
      _personAttrTypes = value;
      notifyListeners();
    }).catchError((e) => _logError(e));

    var consultConceptUuid = dotenv.get('app.conceptConsultationNotes', fallback: '');
    if (consultConceptUuid.isNotEmpty) {
      ConceptDictionary().fetchConceptByUuid(consultConceptUuid).then((value) {
        _consultNoteConcept = value;
        notifyListeners();
      }).catchError((e) => _logError(e));
    }
    BahmniForms().published().then((value) {
      _publishedForms = value;
      notifyListeners();
    }).catchError((e) => _logError(e));
    EmrApiService().orderTypes().then((value) {
      _orderTypes = value;
      notifyListeners();
    });
    ConceptDictionary().dosageInstruction().then((value) {
      _dosageInstructions = value;
      notifyListeners();
    }).onError((error, stackTrace) => _logError(error));
  }

  _logError(e) {
    debugPrint(e);
  }

}
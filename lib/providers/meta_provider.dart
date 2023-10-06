import 'dart:async';
import '../domain/models/dosage_instruction.dart';
import '../domain/models/form_definition.dart';
import '../domain/models/omrs_identifier_type.dart';
import '../domain/models/omrs_order.dart';
import '../domain/models/omrs_person_attribute.dart';
import '../services/emr_api_service.dart';
import 'package:flutter/foundation.dart';
import '../domain/models/omrs_concept.dart';
import '../domain/models/omrs_encounter_type.dart';
import '../services/concept_dictionary.dart';
import '../domain/models/omrs_visit_type.dart';
import '../services/encounters.dart';
import '../services/forms.dart';
import '../services/patients.dart';
import '../utils/environment.dart';

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
    var allowedList = Environment().allowedVisitTypes!.split(',')
        .map((e) => e.trim().toLowerCase()).toList();
    return _visitTypes!.where((e) => allowedList.contains(e.display?.toLowerCase())).toList();
  }

  List<OmrsEncounterType>? get allowedEncTypes {
    if (_encTypes == null) return [];
    var allowedList = Environment().allowedEncounterTypes!.split(',')
        .map((e) => e.trim().toLowerCase()).toList();
    return _encTypes!.where((e) => allowedList.contains(e.display?.toLowerCase())).toList();
  }

  List<FormResource> get observationForms {
    if (_publishedForms == null) return [];
    var allowedList = Environment().obsFormNames!.split(',')
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

    var consultConceptUuid = Environment().consultationNoteConcept!;
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

  Future<bool> initMetaData() {
    var consultConceptUuid = Environment().consultationNoteConcept!;
    return Future.wait(
      [
        ConceptDictionary().fetchDiagnosisCertainty(),
        ConceptDictionary().fetchDiagnosisOrder(),
        Encounters().visitTypes(),
        Encounters().encTypes(),
        Patients().identifierTypes(),
        Patients().attributeTypes(),
        EmrApiService().orderTypes(),
        ConceptDictionary().fetchConceptByUuid(consultConceptUuid),
        BahmniForms().published(),
        ConceptDictionary().dosageInstruction(),
      ]
    ).then((List<Object?> values) {
      debugPrint('initMetaData: metadata loaded');
      _conditionCertainty = values[0] as OmrsConcept?;
      _diagnosisOrder = values[1] as OmrsConcept?;
      _visitTypes = values[2] as List<OmrsVisitType>?;
      _encTypes = values[3] as List<OmrsEncounterType>?;
      _patientIdentifierTypes = values[4] as List<OmrsIdentifierType>?;
      _personAttrTypes = values[5] as List<OmrsPersonAttributeType>?;
      _orderTypes = values[6] as List<OmrsOrderType>?;
      _consultNoteConcept = values[7] as OmrsConcept?;
      _publishedForms = values[8] as List<FormResource>?;
      _dosageInstructions = values[9] as DoseAttributes?;
      notifyListeners();
      return true;
    }).catchError((error, stackTrace) {
      _logError(error);
      return false;
    });
  }

  _logError(e) {
    debugPrint(e);
  }
}


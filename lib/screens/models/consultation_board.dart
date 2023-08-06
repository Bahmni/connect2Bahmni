import 'package:connect2bahmni/domain/models/bahmni_drug_order.dart';
import 'package:connect2bahmni/domain/models/omrs_order.dart';
import 'package:flutter/foundation.dart';

import 'consultation_model.dart';
import 'patient_model.dart';

import '../../domain/condition_model.dart';
import '../../domain/models/omrs_encounter_type.dart';
import '../../domain/models/omrs_location.dart';
import '../../domain/models/omrs_visit_type.dart';
import '../../domain/models/user.dart';
import '../../domain/models/omrs_concept.dart';
import '../../domain/models/omrs_obs.dart';

class ConsultationBoard extends ChangeNotifier {
  final User user;
  ConsultationModel? _currentConsultation;
  ConsultationModel? get currentConsultation => _currentConsultation;

  ConsultationBoard(this.user);

  bool get isEmpty => _currentConsultation == null;

  void initNewConsult(PatientModel forWhom,[OmrsLocation? atLocation, OmrsVisitType? vType, OmrsEncounterType? eType, bool existingVisit = false]) {
    var canInitNew = (_currentConsultation == null) ? true :  (_currentConsultation?.status != ConsultationStatus.draft);
    if (!canInitNew) {
      throw 'Please stage or discard current consultation';
    }
    var newConsult = ConsultationModel(user);
    newConsult.patient = forWhom;
    newConsult.location = atLocation;
    newConsult.status = ConsultationStatus.draft;
    newConsult.visitType = vType;
    newConsult.existingVisit = existingVisit;
    newConsult.encounterType = eType;
    newConsult.startTime ??= DateTime.now();
    newConsult.lastUpdateAt = DateTime.now();
    _currentConsultation = newConsult;
    notifyListeners();
  }

  void addCondition(ConditionModel condition) {
    _verifyEditable();
    _currentConsultation?.addCondition(condition);
    notifyListeners();
  }

  void _verifyEditable() {
    var canEdit = (_currentConsultation != null) &&  (_currentConsultation?.status == ConsultationStatus.draft);
    if (!canEdit) {
      throw 'Unable to change consultation';
    }
  }

  Future<bool> save() {
    _currentConsultation ?? { throw 'Nothing to save' };
    if (_currentConsultation?.status == ConsultationStatus.finalized) {
      return Future.error('Already finalized');
    }
    var results = _currentConsultation!.validate();
    if (results.isNotEmpty) {
      return Future.error(results);
    }
    return _currentConsultation!.save();
  }

  void updateConsultContext(OmrsVisitType vType, OmrsEncounterType eType) {
    _verifyEditable();
    _currentConsultation?.visitType = vType;
    _currentConsultation?.encounterType = eType;
    notifyListeners();
  }

  void removeCondition(ConditionModel condition) {
    _verifyEditable();
    _currentConsultation?.removeCondition(condition);
    notifyListeners();
  }

  void addConsultationNotes(String notes, OmrsConcept? consultNoteConcept) {
    _verifyEditable();
    var obsConcept = consultNoteConcept ?? OmrsConcept();
    var consultNotes = OmrsObs(concept: obsConcept, value: notes);
    _currentConsultation?.addNotes(consultNotes);
    notifyListeners();
  }
  void addInvestigation(OmrsOrder investigation){
    _verifyEditable();
    _currentConsultation?.addInvestigation(investigation);
    notifyListeners();
  }
  void updateInvestigation(OmrsOrder investigation,int index){
    _currentConsultation?.updateInvestigation(investigation,index);
    notifyListeners();
  }
  void removeInvestigation(OmrsOrder investigation){
    _verifyEditable();
    _currentConsultation?.removeInvestigation(investigation);
    notifyListeners();
  }

  void addMedication(BahmniDrugOrder medication) {
    _verifyEditable();
    _currentConsultation?.addMedication(medication);
    notifyListeners();
  }

  void removeMedication(BahmniDrugOrder medication){
    _verifyEditable();
    _currentConsultation?.removeMedication(medication);
    notifyListeners();
  }

  void updateMedication(BahmniDrugOrder medication, int index) {
    _currentConsultation?.updateMedication(medication,index);
    notifyListeners();
  }
}
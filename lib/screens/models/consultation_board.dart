import 'package:flutter/foundation.dart';

import 'consultation_model.dart';
import 'patient_view.dart';

import '../../domain/condition_model.dart';
import '../../domain/models/omrs_encounter_type.dart';
import '../../domain/models/omrs_location.dart';
import '../../domain/models/omrs_visit_type.dart';
import '../../domain/models/user.dart';

class ConsultationBoard extends ChangeNotifier {
  final User user;
  ConsultationModel? _currentConsultation;
  ConsultationModel? get currentConsultation => _currentConsultation;

  ConsultationBoard(this.user);

  void initNewConsult(PatientModel forWhom,[OmrsLocation? atLocation, OmrsVisitType? vType, OmrsEncounterType? eType]) {
    var canInitNew = (_currentConsultation == null) ? true :  (_currentConsultation?.status != ConsultationStatus.draft);
    if (!canInitNew) {
      throw 'Please stage or discard current consultation';
    }
    var newConsult = ConsultationModel(user);
    newConsult.patient = forWhom;
    newConsult.location = atLocation;
    newConsult.status = ConsultationStatus.draft;
    newConsult.visitType = vType;
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
      throw 'Already finalized';
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
  }

}
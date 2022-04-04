import 'package:flutter/foundation.dart';
import '../../domain/models/omrs_location.dart';
import '../../domain/condition_model.dart';
import '../../screens/models/patient_view.dart';

import '../../domain/models/user.dart';
import '../../domain/visit_encounter_type.dart';
import '../../services/emr_api_service.dart';

class ConsultationModel extends ChangeNotifier {
  final User user;
  PatientModel? patient;
  OmrsLocation? location;

  ConsultationStatus status = ConsultationStatus.none;
  DateTime? startTime;
  DateTime? lastUpdateAt;
  List<ConditionModel> problemList = [];
  List<ConditionModel> diagnosisList = [];
  VisitType? visitType = VisitType(uuid: 'c22a5000-3f10-11e4-adec-0800271c1b75', display: 'OPD');
  EncounterType? encounterType = EncounterType(uuid: '81852aee-3f10-11e4-adec-0800271c1b75', display: 'Consultation');


  ConsultationModel(this.user);

  void initialize(PatientModel forWhom,[OmrsLocation? atLocation]) {
    if (status != ConsultationStatus.none) return;
    patient = forWhom;
    location = atLocation;
    status = ConsultationStatus.draft;
    _notifyObservers();
  }

  void _notifyObservers() {
    startTime ??= DateTime.now();
    lastUpdateAt = DateTime.now();
    notifyListeners();
  }

  void addCondition(ConditionModel conditionModel) {
    if (status == ConsultationStatus.finalized) return;
    String? _id = conditionModel.code?.uuid;
    _id ??= conditionModel.id;
    if (_id == null) return;
    var refList = conditionModel.isEncounterDiagnosis ?  diagnosisList : problemList;
    var result = refList.where((element) {
      String? _elementId = element.code?.uuid;
      _elementId ??= element.id;
      return _id == _elementId;
    }).toList();
    if (result.isEmpty) {
      refList.add(conditionModel);
    } else {
      refList.remove(result.first);
      refList.add(conditionModel);
    }
    if (status == ConsultationStatus.none) {
      status = ConsultationStatus.draft;
    }
    _notifyObservers();
  }

  void removeCondition(ConditionModel conditionModel) {
    if (status == ConsultationStatus.finalized) return;
    conditionModel.isEncounterDiagnosis ? diagnosisList.remove(conditionModel) : problemList.remove(conditionModel);
    _notifyObservers();
  }

  Future<bool> save() {
    return EmrApiService().saveConsultation(this).then((value) {
      if (value) {
        _finalizeConsultation();
      }
      return value;
    });
  }

  void _finalizeConsultation() {
    status = ConsultationStatus.finalized;
  }
}

enum ConsultationStatus { none, draft, finalized, amended }
import 'package:connect2bahmni/domain/models/omrs_order.dart';
import 'package:connect2bahmni/utils/app_failures.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/omrs_location.dart';
import '../../domain/condition_model.dart';
import '../../screens/models/patient_model.dart';

import '../../domain/models/user.dart';
import '../../domain/models/omrs_encounter_type.dart';
import '../../domain/models/omrs_obs.dart';
import '../../domain/models/omrs_visit_type.dart';
import '../../services/emr_api_service.dart';

class ConsultationModel {
  final String uuid = const Uuid().v4();
  final User user;
  PatientModel? patient;
  OmrsLocation? location;
  ConsultationStatus status = ConsultationStatus.none;
  DateTime? startTime;
  DateTime? lastUpdateAt;
  List<ConditionModel> problemList = [];
  List<ConditionModel> diagnosisList = [];
  List<OmrsOrder> investigationList = [];
  OmrsVisitType? visitType;
  OmrsEncounterType? encounterType;

  OmrsObs? consultNote;

  bool existingVisit = false;
  String? get consultationNotes {
    return (consultNote == null) ? null : consultNote?.valueAsString;
  }

  ConsultationModel(this.user);

  void initialize(PatientModel forWhom,[OmrsLocation? atLocation, OmrsVisitType? vType, OmrsEncounterType? eType]) {
    if (status != ConsultationStatus.none) return;
    patient = forWhom;
    location = atLocation;
    status = ConsultationStatus.draft;
    visitType = vType;
    encounterType = eType;
  }

  void addCondition(ConditionModel conditionModel) {
    if (status == ConsultationStatus.finalized) return;
    String? conditionId = conditionModel.code?.uuid;
    conditionId ??= conditionModel.id;
    if (conditionId == null) return;
    var refList = conditionModel.isEncounterDiagnosis ?  diagnosisList : problemList;
    var result = refList.where((element) {
      String? elementId = element.code?.uuid;
      elementId ??= element.id;
      return conditionId == elementId;
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
  }

  void removeCondition(ConditionModel conditionModel) {
    if (status == ConsultationStatus.finalized) return;
    conditionModel.isEncounterDiagnosis ? diagnosisList.remove(conditionModel) : problemList.remove(conditionModel);
  }


  List<Failure> validate() {
    return EmrApiService().validate(this);
  }

  Future<bool> save() {
    var service = EmrApiService();
    var validationResults = service.validate(this);
    if (validationResults.isNotEmpty) {
      return Future.value(false);
    }

    return service.saveConsultation(this).then((status) {
      if (status) {
        _finalizeConsultation();
      }
      return status;
    });
  }

  void _finalizeConsultation() {
    status = ConsultationStatus.finalized;
  }

  void updateContext(OmrsVisitType vType, OmrsEncounterType eType) {
    visitType = vType;
    encounterType = eType;
  }

  void addNotes(OmrsObs notes) {
     consultNote = notes;
  }
  void addInvestigation(OmrsOrder investigation){
    investigationList.add(investigation);
  }
  void removeInvestigation(OmrsOrder investigation){
    investigationList.remove(investigation);
  }

  void updateInvestigation(OmrsOrder investigation,int index) {
    investigationList[index]=investigation;
  }
}

enum ConsultationStatus { none, draft, finalized, amended }
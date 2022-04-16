import 'package:uuid/uuid.dart';

import '../../domain/models/omrs_location.dart';
import '../../domain/condition_model.dart';
import '../../screens/models/patient_view.dart';

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
  OmrsVisitType? visitType;
  OmrsEncounterType? encounterType;

  OmrsObs? consultNote;
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
  }

  void removeCondition(ConditionModel conditionModel) {
    if (status == ConsultationStatus.finalized) return;
    conditionModel.isEncounterDiagnosis ? diagnosisList.remove(conditionModel) : problemList.remove(conditionModel);
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

  void updateContext(OmrsVisitType vType, OmrsEncounterType eType) {
    visitType = vType;
    encounterType = eType;
  }

  void addNotes(OmrsObs notes) {
     consultNote = notes;
  }
}

enum ConsultationStatus { none, draft, finalized, amended }
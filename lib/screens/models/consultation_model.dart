import 'package:connect2bahmni/domain/models/omrs_location.dart';
import 'package:connect2bahmni/screens/models/condition_model.dart';
import 'package:fhir/r4.dart';
import 'package:flutter/foundation.dart';

import '../../domain/models/user.dart';

class ConsultationModel extends ChangeNotifier {
  final User user;
  Patient? patient;
  OmrsLocation? location;

  ConsultationStatus status = ConsultationStatus.none;
  DateTime startTime = DateTime.now();
  List<ConditionModel> problemList = [];
  List<ConditionModel> diagnosisList = [];


  ConsultationModel(this.user);

  void initialize(Patient forWhom,[OmrsLocation? atLocation]) {
    if (status != ConsultationStatus.none) return;
    patient = forWhom;
    location = atLocation;
    status = ConsultationStatus.draft;
    notifyListeners();
  }

  void addCondition(ConditionModel conditionModel) {
    conditionModel.isEncounterDiagnosis ? diagnosisList.add(conditionModel) : problemList.add(conditionModel);
    notifyListeners();
  }
}

enum ConsultationStatus { none, draft, finalized, amended }
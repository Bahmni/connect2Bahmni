import 'package:fhir/r4.dart';
import 'package:flutter/foundation.dart';

import '../../domain/models/user.dart';

class ConsultationModel extends ChangeNotifier {
  final User user;
  Patient? patient;
  bool consultationInitiated = false;
  DateTime startTime = DateTime.now();

  ConsultationModel(this.user);

  void initialize(Patient forWhom) {
    if (consultationInitiated) return;
    patient = forWhom;
    consultationInitiated = true;
    notifyListeners();
  }
}
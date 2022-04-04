
import '../../domain/models/omrs_concept.dart';
import '../../domain/models/omrs_patient.dart';
import '../../domain/models/omrs_provider.dart';

class ConditionModel {
  String? id;
  OmrsPatient? subject;
  OmrsProvider? recorder;
  OmrsConcept? code;
  OmrsConcept? verificationStatus;
  OmrsConcept? category;
  OmrsConcept? clinicalStatus;
  String? note;
  DateTime? recordedDate = DateTime.now();

  ConditionModel({
      this.id,
      this.subject,
      this.recorder,
      this.code,
      this.verificationStatus,
      this.category,
      this.clinicalStatus,
      this.note,
      this.recordedDate});

  List<OmrsConcept> get valueSetVerificationStatus => <OmrsConcept>[
    OmrsConcept(uuid: '1', display: 'provisional'),
    OmrsConcept(uuid: '2', display: 'confirmed'),
  ];

  List<OmrsConcept> get valueSetCategory => <OmrsConcept>[
    OmrsConcept(uuid: '1', display: 'diagnosis'),
    OmrsConcept(uuid: '2', display: 'problem-list')
  ];

  bool get isEncounterDiagnosis {
    return category?.display == 'diagnosis';
  }
}
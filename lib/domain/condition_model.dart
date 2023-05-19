
import 'models/omrs_concept.dart';
import 'models/omrs_patient.dart';
import 'models/omrs_provider.dart';

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
  ConditionOrder? order;

  ConditionModel({
      this.id,
      this.subject,
      this.recorder,
      this.code,
      this.verificationStatus,
      this.category,
      this.clinicalStatus,
      this.note,
      this.recordedDate,
      this.order});

  factory ConditionModel.fromPatientDiagnosis(OmrsPatient patient, Map<String, dynamic> json) {
    return ConditionModel(
      id: json['existingObs'],
      recordedDate: _fromDateTime(json['diagnosisDateTime']),
      note: json['comments'],
      subject: patient,
      code: json['codedAnswer'] == null ? OmrsConcept(display: json['freeTextAnswer'])
        : OmrsConcept(uuid: json['codedAnswer']['uuid'],
            display: json['codedAnswer']['name'],
            conceptClass: OmrsConceptClass(name: json['codedAnswer']['conceptClass']),
            datatype: OmrsConceptDataType(name: json['codedAnswer']['dataType']),
          ),
      category: OmrsConcept(display: 'encounter-diagnosis'),
      order: json['order'] == null ? null : _fromOrderString(json['order']),
      verificationStatus: json['certainty'] == null ? null : OmrsConcept(display: json['certainty'])
    );
  }

  List<OmrsConcept> get valueSetCategory => <OmrsConcept>[
    OmrsConcept(uuid: '1', display: 'encounter-diagnosis'),
    OmrsConcept(uuid: '2', display: 'problem-list')
  ];

  bool get isEncounterDiagnosis {
    return category?.display == 'encounter-diagnosis';
  }

}

enum ConditionOrder { primary, secondary }


ConditionOrder? _fromOrderString(String? diagnosisOrder) {
  if (diagnosisOrder == null) return null;
  for (var value in ConditionOrder.values) {
    if (value.name.toUpperCase() == diagnosisOrder.toUpperCase()) return value;
  }
  return null;
}

DateTime? _fromDateTime(dynamic jsonValue) {
  if (jsonValue == null) return null;
  if (jsonValue is int) return DateTime.fromMillisecondsSinceEpoch(jsonValue);
  if (jsonValue is String) return DateTime.parse(jsonValue);
  return null;
}
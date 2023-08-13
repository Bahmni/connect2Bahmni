import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/models/omrs_encounter_type.dart';
import '../domain/models/omrs_visit_type.dart';
import '../providers/meta_provider.dart';
import '../screens/models/patient_model.dart';
import '../services/visits.dart';
import '../widgets/patient_info.dart';

class ConsultationContext extends StatefulWidget {
  final String? visitTypeUuid;
  final String? encTypeUuid;
  final PatientModel patient;
  final bool? isNew;
  final bool allowVisitTypeChange;
  const ConsultationContext({Key? key, this.visitTypeUuid, this.encTypeUuid, required this.patient, this.isNew, this.allowVisitTypeChange = true}) : super(key: key);

  @override
  State<ConsultationContext> createState() => _ConsultationContextState();
}

class _ConsultationContextState extends State<ConsultationContext> {
  final _formKey = GlobalKey<FormState>();
  List<OmrsEncounterType>? _allowedEncTypes;
  List<OmrsVisitType>? _allowedVisitTypes;

  OmrsEncounterType? _selectedEncType;
  OmrsVisitType? _selectedVisitType;
  static const lblVisitType = 'Visit Type';
  static const lblEncounterType = 'Encounter Type';
  final ValueNotifier<bool> _visitChangeAllowed = ValueNotifier<bool>(true);

  static const hdrConsultationContext = 'Consultation Context';
  static const errEncounterTypeRequired = 'Encounter Type is required';
  static const errVisitTypeRequired = 'Visit Type is required';
  static const lblAdd = 'Add';
  static const lblUpdate = 'Update';
  static const lblUnknown = 'unknown';

  @override
  void initState() {
    super.initState();
    var metaProvider = Provider.of<MetaProvider>(context, listen: false);
    _allowedVisitTypes = metaProvider.allowedVisitTypes;
    _allowedEncTypes = metaProvider.allowedEncTypes;
    if (widget.visitTypeUuid != null) {
      var matchingVisitTypes = _allowedVisitTypes!.where((element) => element.uuid == widget.visitTypeUuid);
      if (matchingVisitTypes.isNotEmpty) {
        _selectedVisitType = matchingVisitTypes.first;
        _visitChangeAllowed.value = widget.allowVisitTypeChange;
      }
    } else {
      Visits().visitsForPatient(widget.patient.uuid, false).then((activeVisitList) {
        if (activeVisitList.isNotEmpty) {
          //identify open visit
          var lastVisit = activeVisitList.first;
          var matchingVisitTypes = _allowedVisitTypes!.where((element) => element.uuid == lastVisit.visitType?.uuid);
          if (matchingVisitTypes.isNotEmpty) {
            _selectedVisitType = matchingVisitTypes.first;
            _visitChangeAllowed.value = (_selectedVisitType == null);
          }
        }
      });
    }
    if (widget.encTypeUuid != null) {
      var matchingEncTypes = _allowedEncTypes!.where((element) => element.uuid == widget.encTypeUuid);
      if (matchingEncTypes.isNotEmpty) {
        _selectedEncType = matchingEncTypes.first;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var isNewConsultation = widget.isNew ?? false;
    return Scaffold(
        appBar: AppBar(title: const Text(hdrConsultationContext),),
        body: Container(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height:10),
                  PatientInfo(patient: widget.patient),
                  ..._buildVisitType(),
                  ..._buildEncType(),
                  const SizedBox(height: 20),
                  Align(
                    child: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(50)),
                            child: TextButton(
                              autofocus: false,
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                Navigator.pop(context, {
                                  'encounterType' : _selectedEncType,
                                  'visitType' : _selectedVisitType,
                                  'existingVisit' : !_visitChangeAllowed.value,
                                });
                              },
                              child: Text(isNewConsultation ? lblAdd : lblUpdate, style: TextStyle(color: Colors.white)),
                            ),
                          ),
                  ),
                ],
              ),
            )
        )
    );
  }

  List<Widget> _buildVisitType() {
    return [
      const SizedBox(height: 10.0),
      const Text(lblVisitType),
      ValueListenableBuilder<bool>(
        builder: (BuildContext context, bool allowChange, Widget? child) {
          return DropdownButtonFormField<OmrsVisitType>(
              value: _selectedVisitType,
              isExpanded: true,
              onChanged: allowChange ? (newVal)  {
                setState(() {
                  _selectedVisitType = newVal;
                });
              } : null,
              items: (_allowedVisitTypes ?? []).map<DropdownMenuItem<OmrsVisitType>>((vt) {
                    return DropdownMenuItem(value: vt, child: Text(vt.display ?? lblUnknown));
                  }).toList(),
              validator: (value) => value == null ? errVisitTypeRequired : null,
          );
        },
        valueListenable: _visitChangeAllowed,
      ),
    ];
  }

  List<Widget> _buildEncType() {
    return [
      const SizedBox(height: 10.0),
      const Text(lblEncounterType),
      DropdownButtonFormField<OmrsEncounterType>(
          value: _selectedEncType,
          isExpanded: true,
          onChanged: (newVal)  {
            setState(() {
              _selectedEncType = newVal;
            });
          },
          items: (_allowedEncTypes ?? [])
              .map<DropdownMenuItem<OmrsEncounterType>>((et) => DropdownMenuItem(value: et, child: Text(et.display ?? lblUnknown))).toList(),
          validator: (value) => value == null ? errEncounterTypeRequired : null,
      )
    ];
  }

}
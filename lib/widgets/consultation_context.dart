import 'package:connect2bahmni/services/visits.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/models/omrs_encounter_type.dart';
import '../domain/models/omrs_visit_type.dart';
import '../providers/meta_provider.dart';
import '../screens/models/patient_model.dart';
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
  List<OmrsEncounterType>? _allowedEncTypes;
  List<OmrsVisitType>? _allowedVisitTypes;

  OmrsEncounterType? _selectedEncType;
  OmrsVisitType? _selectedVisitType;
  static const lblVisitType = 'Visit Type';
  static const lblEncounterType = 'Encounter Type';
  final ValueNotifier<bool> _visitChangeAllowed = ValueNotifier<bool>(true);


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
        appBar: AppBar(title: const Text('Consultation Context'),),
        body: Container(
            padding: const EdgeInsets.all(10),
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
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(color: Colors.red)
                            )
                        )
                    ),
                    onPressed: () {
                      if ((_selectedEncType == null) || (_selectedVisitType == null)) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please provide the required info')));
                      } else {
                        Navigator.pop(context, {
                          'encounterType' : _selectedEncType,
                          'visitType' : _selectedVisitType,
                          'existingVisit' : !_visitChangeAllowed.value,
                        });
                      }
                    },
                    child: isNewConsultation ? const Text('Start') : const Text('Update'),
                  ),
                ),
              ],
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
          return DropdownButton<OmrsVisitType>(
              value: _selectedVisitType,
              isExpanded: true,
              onChanged: allowChange ? (newVal)  {
                setState(() {
                  _selectedVisitType = newVal;
                });
              } : null,
              items: (_allowedVisitTypes ?? [])
                  .map<DropdownMenuItem<OmrsVisitType>>((vt) => DropdownMenuItem(value: vt, child: Text(vt.display ?? 'unknown'))).toList()
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
      DropdownButton<OmrsEncounterType>(
          value: _selectedEncType,
          isExpanded: true,
          onChanged: (newVal)  {
            setState(() {
              _selectedEncType = newVal;
            });
          },
          items: (_allowedEncTypes ?? [])
              .map<DropdownMenuItem<OmrsEncounterType>>((et) => DropdownMenuItem(value: et, child: Text(et.display ?? 'unknown'))).toList()
      )
    ];
  }

}
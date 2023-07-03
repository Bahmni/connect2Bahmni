import 'package:flutter/material.dart';

import '../screens/models/patient_model.dart';
import '../utils/app_type_def.dart';

class PatientListWidget extends StatelessWidget {
  final List<PatientModel> patientList;
  final OnSelectPatient? onSelect;
  final OnActionPatient? onAction;
  const PatientListWidget({Key? key, required this.patientList, this.onSelect, this.onAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var p in patientList) _patientRow(context, p)
        ],
      ),
    );
  }

  Row _patientRow(BuildContext context, PatientModel patient) {
    var drugOrderIndicator = patient.getVisitDrugIds() != ''? '*' : '';
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color(0xFFC8CED5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(shape: BoxShape.circle,),
                      child: InkWell(
                        onTap: () {
                          debugPrint('patient search clicked');
                          if (onSelect != null) {
                            onSelect!(patient);
                          }
                        },
                        child: const Icon(Icons.person_rounded, size: 24,),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '${patient.fullName} $drugOrderIndicator',
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleMedium
                              ?.merge(const TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF15212B),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            strutStyle: const StrutStyle(fontSize: 12.0),
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              text: patient.minimalInfo,),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                child: InkWell(
                  onTap: () async {
                    if (onAction != null) {
                      onAction!(patient);
                    }
                  },
                  child: const Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF82878C),
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

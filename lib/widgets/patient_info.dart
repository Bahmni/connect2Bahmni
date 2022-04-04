import 'package:flutter/material.dart';
import '../screens/models/patient_view.dart';

class PatientInfo extends StatefulWidget {
  const PatientInfo({
    Key? key,
    required this.patient,
    this.onSelect
  }) : super(key: key);

  final PatientModel patient;
  final OnSelectPatient? onSelect;


  @override
  _PatientInfoState createState() => _PatientInfoState();
}

enum SingingCharacter { lafayette, jefferson }

class _PatientInfoState extends State<PatientInfo> {
  @override
  Widget build(BuildContext context) {
    return _patientRow(widget.patient);
  }

  Row _patientRow(PatientModel patient) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 65,
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
                      width: 50,
                      height: 50,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(shape: BoxShape.circle,),
                      child: const Icon(Icons.person_rounded, size: 24,),
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
                          patient.fullName,
                          style: Theme.of(context).textTheme.subtitle1?.merge(const TextStyle(
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
              _selectOption(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _selectOption() {
    if (widget.onSelect == null) {
      return const SizedBox(width: 1);
    }
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
      child: InkWell(
        onTap: () {
          widget.onSelect!(widget.patient);
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF82878C),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

}

typedef OnSelectPatient = void Function(PatientModel selectedPatient);
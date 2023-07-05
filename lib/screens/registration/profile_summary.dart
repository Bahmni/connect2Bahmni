import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fhir/r4.dart';

import '../../utils/app_routes.dart';
import '../models/patient_model.dart';
import '../models/profile_model.dart';

class ProfileSummary extends StatefulWidget {
  final String? uuid;
  final List<ProfileAttribute>? attributes;
  final List<ProfileIdentifier>? identifiers;
  final ProfileBasics? basicDetails;
  final ProfileAddress? address;
  const ProfileSummary({Key? key, this.uuid, this.attributes, this.identifiers, this.basicDetails, this.address}) : super(key: key);

  @override
  State<ProfileSummary> createState() => _ProfileSummaryState();
}


class _ProfileSummaryState extends State<ProfileSummary> {

  @override
  Widget build(BuildContext context) {
    // debugPrint('Summary build(). basic details - ${widget.basicDetails}');
    // debugPrint('Summary build(). firstname - ${widget.basicDetails?.firstName}');
    // debugPrint('Summary build(). Address - ${widget.address}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...nameGenderAge(),
        if (widget.identifiers != null)
          ...showIdentifiers(),
        showAddress(),
        ...showAttributes(),
      ],
    );

  }

  List<Card> showIdentifiers() {
    return widget.identifiers!.map((identifier) {
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.perm_identity_sharp),
                  title: Text(identifier.value),
                  subtitle: Text(identifier.name),
                ),
              ],
            ),
          );
        }).toList();
  }

  List<Widget> nameGenderAge() {
      return [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
                child: Container(
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
                    mainAxisAlignment: MainAxisAlignment.start,
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
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                (widget.uuid != null)
                                    ? Icons.person_rounded
                                    : Icons.person_add_alt_1_rounded,
                                size: 24,
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
                                  _fullName(),
                                  style: Theme.of(context)
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
                                      text: _genderAge(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (widget.uuid != null)
                        TextButton(
                            onPressed: () {
                              _navigateToPatientChart();
                            },
                            child: const Column(
                                children: [
                                  SizedBox(height: 10.0),
                                  Icon(Icons.subdirectory_arrow_right_outlined, color: Colors.pink, size: 20.0),
                                  Text('Charts')
                                ]
                            )
                        )
                    ],
                  ),
            )),
          ],
       ),
    ];
  }

  void _navigateToPatientChart() {
    var patient = PatientModel(Patient(
      fhirId: widget.uuid,
      name: [HumanName(given:  [widget.basicDetails!.firstName!], family: widget.basicDetails?.lastName)],
      identifier: widget.identifiers?.map((id) => Identifier(
          fhirId: id.uuid,
          value: id.value,
          use: id.preferred != null && id.preferred! ? IdentifierUse.usual : IdentifierUse.official,
          type: CodeableConcept(
              coding: [
                Coding(
                  code: FhirCode.asConst(id.typeUuid ?? ''),
                  display: id.name,
                )
              ]
          )
      )).toList(),
      birthDate: FhirDate.fromDateTime(widget.basicDetails!.dateOfBirth!),
      gender: FhirCode.asConst(widget.basicDetails!.gender!.name),
      address: widget.address != null ? [Address(
          city: widget.address!.cityVillage,
          district: widget.address!.countyDistrict,
          state: widget.address!.stateProvince,
          extension_: [
            FhirExtension(
              url: FhirUri("http://fhir.openmrs.org/ext/address#address4"),
              valueString: widget.address!.subDistrict,
            )
          ])] : null,
    ));
    Navigator.pushReplacementNamed(context, AppRoutes.patients, arguments: patient);
  }

  String _fullName() {
    return '${widget.basicDetails?.firstName} ${widget.basicDetails?.lastName}';
  }

  String? _genderAge() {
    var dateStr = '';
    if (widget.basicDetails != null && widget.basicDetails!.dateOfBirth != null) {
      dateStr = DateFormat("dd-MM-yyyy").format( widget.basicDetails!.dateOfBirth!);
    }
    return '${widget.basicDetails?.gender?.name}, $dateStr';
  }

  Widget showAddress() {
    var addressText = [widget.address?.cityVillage, widget.address?.subDistrict, widget.address?.countyDistrict, widget.address?.stateProvince];
    addressText.removeWhere((v) => v == null);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.location_on),
            title: Wrap(children:[Text(addressText.join(", "))]),
            //subtitle: Text(widget.address!.addressLine2!),
          ),
        ],
      ),
    );
  }

  List<Widget> showAttributes() {
    if (widget.attributes != null) {
      return widget.attributes!.map((attribute) {
        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.label_important_outline),
                title: Text(attribute.value!),
                subtitle: Text(attribute.description ?? attribute.name!),
              ),
            ],
          ),
        );
      }).toList();
    } else {
      return [SizedBox()];
    }
  }

}
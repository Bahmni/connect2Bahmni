import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../domain/models/form_definition.dart';
import '../../domain/models/omrs_concept.dart';
import '../../domain/models/omrs_obs.dart';
import '../../screens/models/patient_model.dart';
import '../../services/forms.dart';
import '../form_fields.dart';
import '../patient_info.dart';

class ObservationForm extends StatefulWidget {
  final PatientModel patient;
  final FormResource formToDisplay;
  const ObservationForm({super.key, required this.patient, required this.formToDisplay});

  @override
  State<ObservationForm> createState() => _ObservationFormState();
}

class _ObservationFormState extends State<ObservationForm> {
  final _formKey = GlobalKey<FormState>();
  final List<ObservationInstance> _observationInstances = [];
  bool isEditing = true;
  final String obsControlType = 'obsControl';
  final String obsGroupControlType = 'obsGroupControl';
  late Future<bool?> _formInitialized;

  static const msgEnterMandatory = 'This is a required field';
  static const imageHandler = 'ImageUrlHandler';
  static const videoHandler = 'VideoUrlHandler';
  static const decimalFormat = r'[0-9]+[,.]{0,1}[0-9]*';
  late FormDefinition? _formDefinition;

  @override
  void initState() {
    super.initState();
    _formInitialized = BahmniForms().fetch(widget.formToDisplay.uuid).then((value) {
      _formDefinition = value.definition;
      return _initObservationInstances(value.definition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      future: _formInitialized,
      builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(height: 40, child: Center(child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator())));
        }

        if (snapshot.hasError) {
          return _initializationError(snapshot.error);
        }
        if (snapshot.hasData && snapshot.data == false) {
            return  _initializationError(null);
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Observation Form'),
          ),
          body: Padding(
            padding: EdgeInsets.all(5.0),
            child: Form(
              key: _formKey,
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PatientInfo(patient: widget.patient),
                  for (var rowNum = 0; rowNum < _observationInstances.length; rowNum++)
                    Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 8, 5, 5),
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            border: Border.all(color: Colors.blueAccent),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildObservationFields(_observationInstances[rowNum]),
                              SizedBox(height: 16.0),
                            ],
                          ),
                        ),
                        _buildObservationInstanceHeader(_observationInstances[rowNum]),
                        ..._buildRowActions(_observationInstances[rowNum], rowNum),
                      ],
                    ),
                  // Container(
                  //   height: 40,
                  //   width: 100,
                  //   decoration: BoxDecoration(
                  //       color: Colors.blue,
                  //       borderRadius: BorderRadius.circular(50)),
                  //   child: TextButton(
                  //     autofocus: false,
                  //     onPressed: () {
                  //     },
                  //     child: const Text('Save',
                  //         style: TextStyle(color: Colors.white)),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          floatingActionButton: _buildFAB(),
        );
      },
    );
  }

  Scaffold _initializationError(Object? error) {
    return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: const Text('Observation Form'),
              elevation: 0.1,
            ),
            body: Container(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Text(error?.toString() ?? 'Error initializing form'),
              ),
            )
        );
  }

  FloatingActionButton _buildFAB() {
    if (isEditing) {
      return FloatingActionButton(
        onPressed: _submitForm,
        tooltip: 'Save',
        child: Icon(Icons.save_outlined),
      );
    }
    return FloatingActionButton(
        onPressed: () => setState(() => isEditing = true),
        tooltip: 'Edit',
        child: Icon(Icons.edit_outlined),
    );
  }

  bool _showAddMore(ControlDefinition control) {
    return control.properties!.addMore != null && control.properties!.addMore!;
  }

  Widget _buildObservationFields(ObservationInstance observationInstance) {
    return Column(
      children: observationInstance.fields!.map((field) => _buildObservationField(field, observationInstance)).toList(),
    );
  }

  Widget _buildObservationField(ObservationField field, ObservationInstance observationInstance) {
      switch (field.dataType) {
        case ConceptDataType.text:
          return _buildTextField(field);
        case ConceptDataType.numeric:
          return _buildNumericField(field);
        case ConceptDataType.boolean:
          return _buildBooleanField(field);
        case ConceptDataType.datetime:
        case ConceptDataType.date:
          return _buildDateField(field);
        case ConceptDataType.coded:
          return _buildCodedField(field);
        case ConceptDataType.na:
            if (field.definition.type == obsGroupControlType) {
              return _buildCompositeFields(field, observationInstance);
            }
            return SizedBox();
        case ConceptDataType.complex:
          String? conceptHandler = field.definition.concept?.conceptHandler;
          if (conceptHandler == imageHandler) {
            return _buildImageUploadField(field);
          }
          if (conceptHandler == videoHandler) {
            return _buildVideoUploadField(field);
          }
          return Container(margin: EdgeInsets.fromLTRB(0, 10, 0, 0), width: double.infinity, child: Text('This field type is not supported yet'),);
        default:
          debugPrint('Unknown data type: ${field.dataType}. can not render field');
          return Container(margin: EdgeInsets.fromLTRB(0, 10, 0, 0), width: double.infinity, child: Text('This field type is not supported yet'),);
      }
  }

  TextFormField _buildNumericField(ObservationField field) {
    return TextFormField(
          key: UniqueKey(),
          validator: field.validationRule,
          enabled: isEditing,
          decoration: InputDecoration(
            labelText: '${field.label} ${field.required ? '*' : ''}',
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(decimalFormat)),
          ],
          onChanged: (value) => field.value = value,
          onSaved: (value) => field.value = value,
          initialValue: field.value,
        );
  }

  CheckboxFormField _buildBooleanField(ObservationField field) {
    return CheckboxFormField(
          key: UniqueKey(),
          initialValue: field.value != null ? (field.value is bool ? field.value : bool.tryParse(field.value.toString(), caseSensitive: false)) : false,
          title: Text('${field.label} ${field.required ? '*' : ''}'),
          validator: (value) => field.required ? 'Required' : null,
          onSaved: (value) => field.value = value,
          isEnabled: isEditing,
        );
  }

  InputDatePickerFormField _buildDateField(ObservationField field) {
    DateTime currentDate = DateTime.now();
    return InputDatePickerFormField(
            key: UniqueKey(),
            fieldLabelText: field.label,
            firstDate:  DateTime(currentDate.year-100, 1, 1) ,
            lastDate: currentDate,
            onDateSaved: (value) => field.value = DateFormat('yyyy-MM-dd').format(value),
            initialDate: field.value != null ? DateTime.parse(field.value!) : null,
        );
  }

  DropDownSearchFormField<ConceptAnswerDefinition> _buildCodedField(ObservationField field) {
    return DropDownSearchFormField<ConceptAnswerDefinition>(
          hint: field.label ?? '',
          label: field.label ?? '',
          initialValue: field.value,
          itemAsString: (option) => option.displayString ?? '-unknown-',
          items: field.definition.concept?.answers ?? [],
          enabled: isEditing,
          onChanged: (value) {
            field.value = value;
          },
          onSaved: (value) {
            field.value = value;
          },
          validator: field.validationRule,
          compareFn: (ConceptAnswerDefinition? i, ConceptAnswerDefinition? s) => i?.uuid == s?.uuid,
          filterFn: (ConceptAnswerDefinition? i, String? s) => i?.displayString?.toLowerCase().contains(s!.toLowerCase()) ?? false,
        );
  }

  TextFormField _buildTextField(ObservationField field) {
    return TextFormField(
          key: UniqueKey(),
          validator: field.validationRule,
          enabled: isEditing,
          decoration: InputDecoration(
            labelText: '${field.label} ${field.required ? '*' : ''}',
          ),
          keyboardType: TextInputType.text,
          onChanged: (value) => field.value = value,
          onSaved: (value) => field.value = value,
          initialValue: field.value,
        );
  }

  Stack _buildCompositeFields(ObservationField field, ObservationInstance observationInstance) {
    return Stack(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(5, 15, 5, 5),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  child: Column(
                    key: UniqueKey(),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      for (var subField in field.subFields!)
                        _buildObservationField(subField, observationInstance),
                    ],
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 9,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
                    color: Colors.white,
                    child: Text(
                      field.label ?? '',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                )
              ],
            );
  }

  void _submitForm() {
    List<OmrsObs> obsList = [];
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String formFieldPathPrefix = '${_formDefinition!.name}.${_formDefinition!.referenceVersion ?? '0'}/';
      for (var instance in _observationInstances) {
        var isGroupedInstance = instance.definition?.type == obsGroupControlType;
        ConceptDefinition? groupConcept;
        String? instanceFieldPath = '$formFieldPathPrefix${instance.definition?.id}-${instance.serial}';
        if (isGroupedInstance) {
          groupConcept = instance.definition?.concept;
        }
        List<OmrsObs> observations = [];
        for (var field in instance.fields!) {
          var fieldValue = _getFieldValue(field);
          if (fieldValue == null) continue;
          if (fieldValue is String) {
            if (fieldValue.isEmpty) continue;
          }
          var fieldPath = isGroupedInstance
              ? '$instanceFieldPath/${field.definition.id}-${field.serial}'
              : '$formFieldPathPrefix${field.definition.id}-${field.serial}';
          observations.add(
              OmrsObs(
                  concept: OmrsConcept(uuid: field.definition.concept?.uuid, display: field.label),
                  value: fieldValue,
                  formFieldPath: fieldPath,
              )
          );
        }
        if (observations.isEmpty) continue;
        if (!isGroupedInstance) {
          obsList.add(observations.first);
        } else {
          obsList.add(OmrsObs(
              concept: OmrsConcept(uuid: groupConcept?.uuid, display: groupConcept?.name ),
              groupMembers: observations,
              formFieldPath: instanceFieldPath,
          ));
        }
      }
      //_debugFormObs(obsList);
      Navigator.pop(context, obsList);
    }
  }

  // ignore: unused_element
  List<Map<String, Object>> _debugFormObs(List<OmrsObs> obsList) {
    var resultList = obsList.map((e) => {
      'concept': { 'uuid': e.concept.uuid, 'name': e.concept.display},
      if (e.groupMembers != null && e.groupMembers!.isNotEmpty)
        'groupMembers': e.groupMembers!.map((gm) => {
          'concept': { 'uuid': '${gm.concept.uuid}', 'name' : '${gm.concept.display}'},
          'formFieldPath': '${gm.formFieldPath}',
          'value': '${gm.value}',
        }).toList(),
      if (e.groupMembers == null || e.groupMembers!.isEmpty)
        'value': '${e.value}',
      'formFieldPath': '${e.formFieldPath}'
    }).toList();
    var jsonEncode2 = jsonEncode(resultList);
    debugPrint("************************");
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(jsonEncode2).forEach((RegExpMatch match) =>   debugPrint(match.group(0)));
    debugPrint("************************");
    debugPrint('obs list size: ${obsList.length}');
    return resultList;
  }

  dynamic _getFieldValue(ObservationField field) {
    if (field.value == null) {
      return null;
    }
    if (field.dataType == ConceptDataType.coded) {
      var answerConceptUuid = (field.value as ConceptAnswerDefinition).uuid;
      return OmrsConcept(uuid: answerConceptUuid);
    } else {
      return field.value;
    }
  }

  Widget _buildObservationInstanceHeader(ObservationInstance observationInstance) {
    String? labelText;
    if (observationInstance.definition?.type == obsGroupControlType) {
      labelText = observationInstance.definition?.label?.value;
    }
    labelText ??= '${observationInstance.fields?.first.label}';

    return Positioned(
      left: 20,
      top: 2,
      child: Container(
        padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
        color: Colors.white,
        child: Text(
          labelText,
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
      ),
    );
  }

  List<Widget> _buildRowActions(ObservationInstance obsInstance, int rowNum) {
    List<Widget> actions = [];
    var showAddMore = _showAddMore(obsInstance.definition!);
    if (showAddMore) {
      actions.add(Positioned(
        right: 40,
        top: -12,
        child: IconButton(
            color: Colors.blue,
            onPressed: () => _addObservationInstance(obsInstance, rowNum + 1),
            icon: Icon(Icons.add_circle)
        ),
      ));
    }

    if (showAddMore) {
      actions.add(Positioned(
        right: 10,
        top: -12,
        child: IconButton(
            color: Colors.blue,
            onPressed: () {
              _removeObservationInstance(obsInstance);
            },
            icon: Icon(Icons.remove_circle)
        ),
      ));
    }
    return actions;
  }

  ///Right now handles only one level of nested groups
  ///Only deals with obsControl and ObsGroup control types
  ///No support for form event scripts yet
  bool _initObservationInstances(FormDefinition? formDef) {
    _observationInstances.clear();
    if (formDef == null) {
      return false;
    }
    if (formDef.controls != null) {
      var controls = formDef.controls?.where((element) => element.type == obsControlType || element.type == obsGroupControlType).toList();
      if (controls != null) {
        controls.sort((a, b) => a.position?.row.compareTo(b.position?.row ?? 0) ?? 0);
        for (ControlDefinition fieldDefinition in controls) {
          if (fieldDefinition.type == obsControlType) {
            _observationInstances.add(ObservationInstance(
              fields: [_createFieldInstance(fieldDefinition)],
              definition: fieldDefinition,
            ));
          } else if (fieldDefinition.type == obsGroupControlType) {
            var subFieldsDefinitions = fieldDefinition.controls?.where((element) => element.type == obsControlType || element.type == obsGroupControlType).toList();
            if (subFieldsDefinitions != null) {
              subFieldsDefinitions.sort((a, b) => a.position?.row.compareTo(b.position?.row ?? 0) ?? 0);
              var groupFields = <ObservationField>[];
              for (var controlDef in subFieldsDefinitions) {
                groupFields.add(_createFieldInstance(controlDef));
              }
              _observationInstances.add(ObservationInstance(fields: groupFields, definition: fieldDefinition));
            }
          }
        }
      }
    }
    return true;
  }

  ObservationField _createFieldInstance(ControlDefinition fieldDefinition) {
    if (fieldDefinition.isComposite) {
      var subFieldsDefinitions = fieldDefinition.controls?.where((element) => element.type == obsControlType || element.type == obsGroupControlType).toList();
      if (subFieldsDefinitions != null) {
        subFieldsDefinitions.sort((a, b) => a.position?.row.compareTo(b.position?.row ?? 0) ?? 0);
        var groupFields = <ObservationField>[];
        for (var controlDef in subFieldsDefinitions) {
          groupFields.add(_createFieldInstance(controlDef));
        }
        return ObservationField(
          definition: fieldDefinition,
          subFields: groupFields,
        );
      }
    }
    return ObservationField(
      definition: fieldDefinition,
      validationRule: (value) {
        var mandatory = fieldDefinition.properties?.mandatory ?? false;
        if (mandatory && value == null) {
          return msgEnterMandatory;
        }
        if (mandatory && (value is String) && value.isEmpty) {
          return msgEnterMandatory;
        }
        return null;
      },
    );
  }

  void _addObservationInstance(ObservationInstance obsInstance, int rowNum) {
    int serial = 0;
    for (var element in _observationInstances) {
      if (element.definition?.id == obsInstance.definition?.id) {
          if (element.serial > serial) {
            serial = element.serial;
          }
      }
    }
    var newInstance = obsInstance.clone();
    newInstance.serial = serial + 1;
    setState(() {
      _observationInstances.insert(rowNum, newInstance);
    });
  }

  void _removeObservationInstance(ObservationInstance instance) {
    setState(() {
      _observationInstances.remove(instance);
    });
  }

  Widget _buildImageUploadField(ObservationField field) {
    return Container(margin: EdgeInsets.fromLTRB(0, 10, 0, 0), width: double.infinity, child: Text('Image type is not supported yet'),);
  }

  Widget _buildVideoUploadField(ObservationField field) {
    return Container(margin: EdgeInsets.fromLTRB(0, 10, 0, 0), width: double.infinity, child: Text('Video type is not supported yet'),);
  }
}


class ObservationInstance {
  List<ObservationField>? fields;
  ControlDefinition? definition;
  int serial;
  ObservationInstance({this.fields, this.definition, this.serial = 0});

  ObservationInstance clone() {
    var clone = ObservationInstance(fields: fields?.map((e) => e.clone()).toList(), definition: definition, serial: serial + 1);
    return clone;
  }
}


class ObservationField {
  final List<ObservationField>? subFields;
  final FormFieldValidator<dynamic>? validationRule;
  final ControlDefinition definition;
  dynamic value;
  int serial;

  ObservationField({
    required this.definition,
    this.subFields,
    this.validationRule,
    this.value,
    this.serial = 0,
  });

  bool get required => definition.properties?.mandatory ?? false;
  String? get label => definition.label?.value;
  ConceptDataType? get dataType => definition.dataType;

  ObservationField clone() {
    var clone = ObservationField(
      definition: definition,
      subFields: subFields?.map((e) => e.clone()).toList(),
      validationRule: validationRule,
      serial: serial,
    );
    return clone;
  }
}

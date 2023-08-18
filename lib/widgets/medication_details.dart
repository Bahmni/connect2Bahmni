import 'package:connect2bahmni/domain/models/bahmni_drug_order.dart';
import 'package:connect2bahmni/services/concept_dictionary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicationDetails extends StatefulWidget {
  final BahmniDrugOrder medication;

  const MedicationDetails({Key? key, required this.medication})
      : super(key: key);

  @override
  State<MedicationDetails> createState() => _MedicationDetailsState();
}

class _MedicationDetailsState extends State<MedicationDetails> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedUnitType;
  String? _selectedRouteType;
  String? _selectedFrequencyType;
  String? _selectedDurationType;
  String? _selectedDosingInstructions;
  String lblTitle = " ";
  late BahmniDrugOrder _medication;
  late final Map<dynamic, dynamic>? _dosageInstructions;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _t1Controller = TextEditingController();
  final TextEditingController _t2Controller = TextEditingController();
  final TextEditingController _t3Controller = TextEditingController();
  static const lblAddMedication = "Add Medication";
  static const lblEnterMedicationNote = "Enter note for the medication";
  final ValueNotifier<bool> _typeChangeAllowed = ValueNotifier<bool>(true);
  double totalQuantity = 0.0;
  late Future<Map?> _dataFuture;
  bool toggle=false;
  double s1=0;
  double s2=0;
  double s3=0;
  static const doseRequired = 'Dose is required';
  static const dosingUnitRequired = 'Dose Unit is required';
  static const frequencyRequired = 'Frequency is required';
  static const routeRequired = 'Route is required';
  static const durationRequired = 'Duration is required';
  static const durationUnitRequired = 'Duration Unit is required';
  static const startDateRequired = 'Start Date is required';
  static const dosingInstructionRequired = 'Instruction is required';
  static const requiredAllTerm = "Required";
  List<String> durationUnits = ['Days','Weeks','Months','Years'];


  @override
  void initState() {
    super.initState();
    _dataFuture = fetchFromApi()!;
    _medication = widget.medication;
    _notesController.text = _medication.commentToFulfiller ?? '';
    _dateController.text = _medication.effectiveStartDate?.toString() ?? '';
    _doseController.text =
        _medication.dosingInstructions?.dose.toString() ?? '';
    _durationController.text = _medication.duration?.toString() ?? '';
    if (_medication.dosingInstructions == null) {
      DosingInstructions newDosingInstructions = DosingInstructions();
      _medication.dosingInstructions = newDosingInstructions;
    }
  }

  @override
  void dispose() {
    _doseController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    _dateController.dispose();
    _t1Controller.dispose();
    _t2Controller.dispose();
    _t3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _dataFuture,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              height: 50,
              width: 50,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                strokeWidth: 4,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(lblAddMedication),
              ),
              body: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        _medicationDisplay(),
                        SizedBox(height: 15),
                        toggle == false ? _numericRow("Dose", _doseController): _toggleRow("Dose"),
                        SizedBox(height: 15),
                        // _unitRow("Dose Units", _dosageInstructions?['doseUnits']),
                        SizedBox(height: 15),
                        toggle == false ? _frequencyRow(
                            "Frequency", _dosageInstructions?['frequencies']):Padding(padding: EdgeInsets.zero),
                        toggle == false ?SizedBox(height: 20):Padding(padding: EdgeInsets.zero),
                        _routeRow("Routes", _dosageInstructions?['routes']),
                        SizedBox(height: 15),
                        _numericRow("Duration", _durationController),
                        SizedBox(height: 15),
                        // _durationUnitRow("Duration Units",
                        //     _dosageInstructions?['durationUnits']),
                        SizedBox(height: 15),
                        _startDateRow("Start Date"),
                        SizedBox(height: 20),
                        _totalQuantityRow("Total Quantity"),
                        SizedBox(height: 15),
                        // _unitRow("Units", _dosageInstructions?['doseUnits']),
                        SizedBox(height: 15),
                        _dosingInstructionsRow("Dosing Instructions",
                            _dosageInstructions?['dosingInstructions']),
                        SizedBox(height: 15),
                        _commentToFulfiller(),
                        SizedBox(height: 15),
                        Container(
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
                              _medication.dosingInstructions?.doseUnits =
                                  _selectedUnitType;
                              _medication.dosingInstructions?.quantityUnits =
                                  _selectedUnitType;
                              _medication.dosingInstructions?.route =
                                  _selectedRouteType;
                              toggle==false?_medication.dosingInstructions?.frequency =
                                  _selectedFrequencyType:_medication.dosingInstructions?.frequency =null;
                              _medication.durationUnits = _selectedDurationType;
                              _medication.dosingInstructions
                                      ?.administrationInstructions =
                                  _selectedDosingInstructions;
                              _medication.commentToFulfiller =
                                  _notesController.text;
                              _medication.dosingInstructions?.quantity =
                                  totalQuantity;
                              _effectiveStopDate();
                              Navigator.pop(context, _medication);
                            },
                            child: const Text('Update',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget _medicationDisplay() {
    String? display = _medication.concept?.name ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(display, style: TextStyle(fontSize: 20)),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.black26,
            ),
            child: IconButton(
              icon: Icon(Icons.compare_arrows),
              onPressed: () {
                setState(() {
                  toggle = !toggle;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _unitRow(List<dynamic> items) {
      return Container(
        alignment: Alignment.centerRight,
        width: 110,
        child: ValueListenableBuilder<bool>(
          builder:
              (BuildContext context, bool allowChange, Widget? child) {
            return DropdownButtonFormField(
              value: _selectedUnitType,
              alignment: Alignment.centerRight,
              onChanged: (newvalue) {
                setState(() {
                  _selectedUnitType = newvalue!;
                });
              },
              items: (items)
                  .map<DropdownMenuItem<String>>((vt) =>
                      DropdownMenuItem<String>(
                          value: vt['name'],
                          child: Text(vt['name'] ?? 'unknown')))
                  .toList(),
              validator: (value) => value == null ? dosingUnitRequired : null,
            );
          },
          valueListenable: _typeChangeAllowed,
        ));
  }

  Padding _routeRow(String lblTitle, List<dynamic> items) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(lblTitle),
          Container(
              alignment: Alignment.centerRight,
              width: 200,
              child: ValueListenableBuilder<bool>(
                builder:
                    (BuildContext context, bool allowChange, Widget? child) {
                  return DropdownButtonFormField(
                    value: _selectedRouteType,
                    alignment: Alignment.centerRight,
                    onChanged: (newvalue) {
                      setState(() {
                        _selectedRouteType = newvalue!;
                      });
                    },
                    items: (items)
                        .map<DropdownMenuItem<String>>((vt) =>
                            DropdownMenuItem<String>(
                                value: vt['name'],
                                child: Text(vt['name'] ?? 'unknown')))
                        .toList(),
                    validator: (value) => value == null ? routeRequired : null,
                  );
                },
                valueListenable: _typeChangeAllowed,
              ))
        ]));
  }

  Padding _frequencyRow(String lblTitle, List<dynamic> items) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(lblTitle),
          Container(
              alignment: Alignment.centerRight,
              width: 200,
              child: ValueListenableBuilder<bool>(
                builder:
                    (BuildContext context, bool allowChange, Widget? child) {
                  return DropdownButtonFormField(
                    value: _selectedFrequencyType,
                    alignment: Alignment.centerRight,
                    onChanged: (newvalue) {
                      setState(() {
                        _selectedFrequencyType = newvalue!;
                        _updateResult();
                      });
                    },
                    items: (items)
                        .map<DropdownMenuItem<String>>((vt) =>
                            DropdownMenuItem<String>(
                                value: vt['name'],
                                child: Text(vt['name'] ?? 'unknown')))
                        .toList(),
                    validator: (value) => value == null ? frequencyRequired : null,
                  );
                },
                valueListenable: _typeChangeAllowed,
              ))
        ]));
  }

  Widget _durationUnitRow(List<dynamic> items) {
    return Container(
      alignment: Alignment.centerRight,
      width: 150,
      child: ValueListenableBuilder<bool>(
        builder:
            (BuildContext context, bool allowChange, Widget? child) {
          return DropdownButtonFormField(
            value: _selectedDurationType,
            alignment: Alignment.centerRight,
            onChanged: (newvalue) {
              setState(() {
                _selectedDurationType = newvalue!;
                _updateResult();
              });
            },
            items: (items.where((element) => durationUnits.contains(element['name'])))
                .map<DropdownMenuItem<String>>((vt) =>
                    DropdownMenuItem<String>(
                        value: vt['name'],
                        child: Text(vt['name'] ?? 'unknown')))
                .toList(),
            validator: (value) => value == null ? durationUnitRequired : null,
          );
        },
        valueListenable: _typeChangeAllowed,
      ));
  }

  Padding _dosingInstructionsRow(String lblTitle, List<dynamic> items) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(lblTitle),
          Container(
              alignment: Alignment.centerRight,
              width: 200,
              child: ValueListenableBuilder<bool>(
                builder:
                    (BuildContext context, bool allowChange, Widget? child) {
                  return DropdownButtonFormField<String>(
                    value: _selectedDosingInstructions,
                    alignment: Alignment.centerRight,
                    onChanged: (newvalue) {
                      setState(() {
                        _selectedDosingInstructions = newvalue!;
                      });
                    },
                    items: (items)
                        .map<DropdownMenuItem<String>>((vt) =>
                            DropdownMenuItem<String>(
                                value: vt['name'],
                                child: Text(vt['name'] ?? 'unknown')))
                        .toList(),
                    validator: (value) => value == null ? dosingInstructionRequired : null,
                  );
                },
                valueListenable: _typeChangeAllowed,
              ))
        ]));
  }

  Padding _numericRow(String lblTitle, TextEditingController controller) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(lblTitle),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(right: 10),
                alignment: Alignment.centerRight,
                width: 50,
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: controller,
                    validator: (value) => value!.isEmpty ? controller == _doseController ? doseRequired : durationRequired : null,
                    onTapOutside: (_) {
                      setState(() {
                        if (controller == _doseController) {
                          _medication.dosingInstructions?.dose =
                              double.tryParse(_doseController.text);
                        } else {
                          _medication.duration =
                              int.tryParse(_durationController.text);
                        }
                        _updateResult();
                      });
                    }
                    ),
              ),
              lblTitle=='Dose'? _unitRow(_dosageInstructions?['doseUnits']) : _durationUnitRow(_dosageInstructions?['durationUnits'])
            ],
          ),
        ]));
  }

  Padding _toggleRow(String lblTitle) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(lblTitle),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: SizedBox(
                  width: 30,
                  height: 50,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? requiredAllTerm:null,
                    controller: _t1Controller,
                    onTapOutside: (_){
                      setState(() {
                        s1 = double.tryParse(_t1Controller.text)!;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: SizedBox(
                  width: 30,
                  height: 50,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _t2Controller,
                    validator: (value) => value!.isEmpty ? requiredAllTerm:null,
                    onTapOutside: (_){
                      setState(() {
                        s2 = double.tryParse(_t2Controller.text)!;
                      });
                    },
                  ),
                ),
              ),Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: SizedBox(
                  width: 30,
                  height: 50,
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                    controller: _t3Controller,
                    validator: (value) => value!.isEmpty ? requiredAllTerm:null,
                    onTapOutside: (_){
                      setState(() {
                        s3 = double.tryParse(_t3Controller.text)!;
                        _medication.dosingInstructions?.dose =
                            s1+s2+s3;
                      });
                    },
                  ),
                ),
              ),
              _unitRow(_dosageInstructions?['doseUnits'])
            ],
          )
        ])
    );
  }

  void _updateResult() {
    double value1 = toggle == false ? double.tryParse(_doseController.text) ?? 0.0 : s1+s2+s3;
    double value2 = double.tryParse(_durationController.text) ?? 0.0;
    setState(() {
      if (_selectedDurationType == 'Days') {
        _quantityCalculate(1, value1, value2);
      } else if (_selectedDurationType == 'Weeks') {
        _quantityCalculate(7, value1, value2);
      } else if (_selectedDurationType == 'Months') {
        _quantityCalculate(30, value1, value2);
      } else if (_selectedDurationType == 'Years') {
        _quantityCalculate(365, value1, value2);
      }
      _medication.dosingInstructions?.quantity = totalQuantity;

    });
  }

  void _quantityCalculate(double factor, double value1, double value2) {
    if(toggle==false) {
      if (_selectedFrequencyType == 'Once a day') {
        totalQuantity = factor * value1 * value2;
      } else if (_selectedFrequencyType == 'Twice a day' ||
          _selectedFrequencyType == 'Every 12 hours') {
        totalQuantity = factor * value1 * value2 * 2;
      } else if (_selectedFrequencyType == 'Thrice a day' ||
          _selectedFrequencyType == 'Every 8 hours') {
        totalQuantity = factor * value1 * value2 * 3;
      } else if (_selectedFrequencyType == 'Four times a day' ||
          _selectedFrequencyType == 'Every 6 hours') {
        totalQuantity = factor * value1 * value2 * 4;
      } else if (_selectedFrequencyType == 'Every 4 hours') {
        totalQuantity = factor * value1 * value2 * 6;
      } else if (_selectedFrequencyType == 'Every 3 hours') {
        totalQuantity = factor * value1 * value2 * 8;
      } else if (_selectedFrequencyType == 'Every 2 hours') {
        totalQuantity = factor * value1 * value2 * 12;
      } else if (_selectedFrequencyType == 'Every hour') {
        totalQuantity = factor * value1 * value2 * 24;
      } else if (_selectedFrequencyType == 'On alternate days') {
        totalQuantity = value1 * value2 / 2;
      } else if (_selectedFrequencyType == 'Once a week') {
        totalQuantity = factor * value1 * value2 / 7;
      } else if (_selectedFrequencyType == 'Twice a week') {
        totalQuantity = factor * value1 * (value2 / 7) * 2;
      } else if (_selectedFrequencyType == 'Thrice a week') {
        totalQuantity = factor * value1 * (value2 / 7) * 3;
      }
    }
    else{
      totalQuantity = factor * value1 * value2;
    }
  }

  Padding _startDateRow(String lblTitle) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(lblTitle),
            Container(
              width: 200,
              alignment: Alignment.centerRight,
              child: TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                      // icon: Icon(Icons.calendar_today),
                      suffixIcon: Icon(Icons.calendar_today)),
                  readOnly: true,
                  validator: (value) => value!.isEmpty ? startDateRequired : null,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101));
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd-MMM-yyy').format(pickedDate);
                      setState(() {
                        _dateController.text = formattedDate;
                        _medication.effectiveStartDate = pickedDate;
                      });
                    }
                  }),
            ),
          ],
        ));
  }

  Padding _totalQuantityRow(String lblTitle) {
    String? quantity = _medication.dosingInstructions?.quantity == null
        ? totalQuantity.ceil().toString()
        : _medication.dosingInstructions?.quantity?.ceil().toString();
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(lblTitle),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 10),
                  width: 150,
                  alignment: Alignment.centerRight,
                  child: Text(quantity.toString()),
                ),
                _unitRow(_dosageInstructions?['doseUnits'])
              ],
            ),
          ],
        ));
  }

  Widget _commentToFulfiller() {
    return TextField(
      controller: _notesController,
      decoration: InputDecoration(
        hintText: lblEnterMedicationNote,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFDBE2E7),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFDBE2E7),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 40, 24, 0),
      ),
      maxLines: 8,
      style: Theme.of(context).textTheme.bodyLarge!.merge(const TextStyle(
            fontFamily: 'Lexend Deca',
            color: Color(0xFF1E2429),
            fontSize: 14,
            fontWeight: FontWeight.normal,
          )),
      textAlign: TextAlign.start,
    );
  }

  Future<Map?>? fetchFromApi() async {
    return ConceptDictionary().dosageInstruction().then((value) {
      setState(() {
        _dosageInstructions = value;
        _selectedUnitType = _medication.dosingInstructions?.doseUnits;
        _selectedFrequencyType = _medication.dosingInstructions?.frequency;
        _selectedRouteType = _medication.dosingInstructions?.route;
        _selectedDurationType = _medication.durationUnits;
        _selectedDosingInstructions =
            _medication.dosingInstructions!.administrationInstructions;
      });
      return null;
    });
  }

  void _effectiveStopDate(){
    if(_selectedDurationType == 'Days'){
      setState(() {
        _medication.effectiveStopDate = _medication.effectiveStartDate!.add(Duration(days: int.parse(_durationController.text)));
      });
    }
    else if(_selectedDurationType == 'Hours'){
      setState(() {
        _medication.effectiveStopDate = _medication.effectiveStartDate!.add(Duration(days: int.parse(_durationController.text)));
      });
    }
    else if(_selectedDurationType == 'Weeks'){
      setState(() {
        _medication.effectiveStopDate = _medication.effectiveStartDate!.add(Duration(days: int.parse(_durationController.text)*7));
      });
    }
    else if(_selectedDurationType == 'Months'){
      setState(() {
        _medication.effectiveStopDate = _medication.effectiveStartDate!.add(Duration(days: int.parse(_durationController.text)*30));
      });
    }
    else if(_selectedDurationType == 'Years'){
      setState(() {
        _medication.effectiveStopDate = _medication.effectiveStartDate!.add(Duration(days: int.parse(_durationController.text)*365));
      });
    }
  }
}

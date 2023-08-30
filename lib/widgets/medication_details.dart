import 'package:connect2bahmni/domain/models/bahmni_drug_order.dart';
import 'package:connect2bahmni/domain/models/dosage_instruction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/meta_provider.dart';

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
  late final Map<dynamic, dynamic>? _dosageAttributes;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _morningDoseController = TextEditingController();
  final TextEditingController _afternoonDoseController = TextEditingController();
  final TextEditingController _eveningDoseController = TextEditingController();
  static const lblAddMedication = "Add Medication";
  static const lblEnterMedicationNote = "Enter note for the medication";
  final ValueNotifier<bool> _typeChangeAllowed = ValueNotifier<bool>(true);
  double totalQuantity = 0.0;
  bool showFrequency=true;
  int morningDose=0;
  int afternoonDose=0;
  int eveningDose=0;
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
    DoseAttributes? dosageInstructions = Provider.of<MetaProvider>(context, listen: false).dosageInstruction;
    _dosageAttributes = dosageInstructions?.details;
    _medication = widget.medication;
    _selectedUnitType = _medication.dosingInstructions?.doseUnits;
    _selectedFrequencyType = _medication.dosingInstructions?.frequency;
    _selectedRouteType = _medication.dosingInstructions?.route;
    _selectedDurationType = _medication.durationUnits;
    _selectedDosingInstructions =
        _medication.dosingInstructions?.administrationInstructions;
    _notesController.text = _medication.commentToFulfiller ?? '';
    _dateController.text = _medication.effectiveStartDate!=null ? DateFormat('dd-MMM-yyy').format(_medication.effectiveStartDate!) : '';
    _durationController.text = _medication.duration?.toString() ?? '';
    String? dose = _medication.dosingInstructions?.dose.toString();
    showFrequency = dose?[dose.length - 1] != '1'? true:false;
    _doseController.text = dose?[dose.length - 1] != '1' ?
    _medication.dosingInstructions?.dose.toString() ?? '':'';
    _morningDoseController.text = dose?[dose.length - 1] != '1' ? '' : dose?[0] ?? '';
    _afternoonDoseController.text = dose?[dose.length - 1] != '1' ? '' : dose?[1] ?? '';
    _eveningDoseController.text = dose?[dose.length - 1] != '1' ? '' : dose?[2] ?? '';
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
    _morningDoseController.dispose();
    _afternoonDoseController.dispose();
    _eveningDoseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        SizedBox(height: 10),
                        _medicationDisplay(),
                        SizedBox(height: 10),
                        showFrequency == true ? _doseRow("Dose", _doseController): _toggleRow("Dose"),
                        SizedBox(height: 10),
                        showFrequency == true ? _frequencyRow(
                            "Frequency", _dosageAttributes?['frequencies']):Padding(padding: EdgeInsets.zero),
                        showFrequency == true ?SizedBox(height: 20):Padding(padding: EdgeInsets.zero),
                        _routeRow("Routes", _dosageAttributes?['routes']),
                        SizedBox(height: 10),
                        _durationRow("Duration", _durationController),
                        SizedBox(height: 10),
                        _startDateRow("Start Date"),
                        SizedBox(height: 15),
                        _totalQuantityRow("Total Quantity"),
                        SizedBox(height: 15),
                        _dosingInstructionsRow("Dosing Instructions",
                            _dosageAttributes?['dosingInstructions']),
                        SizedBox(height: 10),
                        _commentToFulfiller(),
                        SizedBox(height: 10),
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
                              showFrequency==true?_medication.dosingInstructions?.frequency =
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
                  showFrequency = !showFrequency;
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

  Padding _doseRow(String lblTitle, TextEditingController controller) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(lblTitle),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  padding: EdgeInsets.only(right: 10,left: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 3,
                        color: Colors.black12
                      )
                    ]
                  ),
                  width: 80,
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: controller,
                      validator: (value) => value!.isEmpty ?doseRequired : null,
                      onTapOutside: (_) {
                        setState(() {
                          if (_doseController.text.isNotEmpty) {
                            _medication.dosingInstructions?.dose =
                                double.tryParse(_doseController.text);
                          }
                          _updateResult();
                        });
                      }
                      ),
                ),
              ),
              _unitRow(_dosageAttributes?['doseUnits'])
            ],
          ),
        ]));
  }

  Padding _durationRow(String lblTitle, TextEditingController controller) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(lblTitle),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  padding: EdgeInsets.only(right: 10,left: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 3,
                            color: Colors.black12
                        )
                      ]
                  ),
                  width: 80,
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: controller,
                      validator: (value) => value!.isEmpty ? durationRequired : null,
                      onTapOutside: (_) {
                        setState(() {
                          if(_durationController.text.isNotEmpty){
                            _medication.duration =
                                int.tryParse(_durationController.text);
                          }
                          _updateResult();
                        });
                      }
                  ),
                ),
              ),
              _durationUnitRow(_dosageAttributes?['durationUnits'])
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
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 3,
                            color: Colors.black12
                        )
                      ]
                  ),
                  width: 50,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder()
                    ),
                    validator: (value) => value!.isEmpty ? requiredAllTerm:null,
                    controller: _morningDoseController,
                    onTapOutside: (_){
                      _morningDoseController.text.isNotEmpty?setState(() {
                        morningDose = int.tryParse(_morningDoseController.text)!;
                      }):null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 3,
                            color: Colors.black12
                        )
                      ]
                  ),
                  width: 50,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder()
                    ),
                    controller: _afternoonDoseController,
                    validator: (value) => value!.isEmpty ? requiredAllTerm:null,
                    onTapOutside: (_){
                      _afternoonDoseController.text.isNotEmpty?setState(() {
                        afternoonDose = int.tryParse(_afternoonDoseController.text)!;
                      }):null;
                    },
                  ),
                ),
              ),Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 3,
                            color: Colors.black12
                        )
                      ]
                  ),
                  width: 50,
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder()
                    ),
                    controller: _eveningDoseController,
                    validator: (value) => value!.isEmpty ? requiredAllTerm:null,
                    onTapOutside: (_){
                      _eveningDoseController.text.isNotEmpty?setState(() {
                        eveningDose = int.tryParse(_eveningDoseController.text)!;
                        _medication.dosingInstructions?.dose =
                            double.tryParse('$morningDose$afternoonDose$eveningDose.1');
                      }):null;
                    },
                  ),
                ),
              ),
              _unitRow(_dosageAttributes?['doseUnits'])
            ],
          )
        ])
    );
  }

  void _updateResult() {
    double doseValue = showFrequency == true ? double.tryParse(_doseController.text) ?? 0.0 : (morningDose+afternoonDose+eveningDose).toDouble();
    double durationValue = double.tryParse(_durationController.text) ?? 0.0;
    setState(() {
      if (_selectedDurationType == 'Days') {
        _quantityCalculate(1, doseValue, durationValue);
      } else if (_selectedDurationType == 'Weeks') {
        _quantityCalculate(7, doseValue, durationValue);
      } else if (_selectedDurationType == 'Months') {
        _quantityCalculate(30, doseValue, durationValue);
      } else if (_selectedDurationType == 'Years') {
        _quantityCalculate(365, doseValue, durationValue);
      }
      _medication.dosingInstructions?.quantity = totalQuantity;
    });
  }

  void _quantityCalculate(double factor, double value1, double value2) {
    if(showFrequency==true) {
      var frequencyPerDay = _dosageAttributes?['frequencies'].where((element)=> element['name']==_selectedFrequencyType).toList()[0]['frequencyPerDay'];
      totalQuantity = factor * value1 * value2 * frequencyPerDay;
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
                _selectedUnitType != null?Text("$_selectedUnitType"):Padding(padding: EdgeInsets.zero)
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

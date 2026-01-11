import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/meta_provider.dart';
import '../domain/models/bahmni_drug_order.dart';
import '../domain/models/dosage_instruction.dart';

class MedicationDetails extends StatefulWidget {
  final BahmniDrugOrder medOrder;

  const MedicationDetails({super.key, required this.medOrder});

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
  DateTime? _effectiveStartDate;
  late BahmniDrugOrder _drugOrder;
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
  double totalQuantity = 0.0;
  late ValueNotifier<double> _totalQuantityNotifier;
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
  static const lblRoutes = "Routes";
  static const lblFrequency = "Frequency";
  static const lblDose = "Dose";
  static const lblDuration = "Duration";
  static const lblStartDate = "Start Date";
  static const lblTotalQuantity = "Total Quantity";
  static const lblDosingInstructions = "Instructions";
  // static const lblDosingInstructions = "Dosing Instructions";
  static const lblDefaultRoute = 'Oral';
  static const careSettingOutPatient = 'OUTPATIENT';
  List<String> durationUnits = ['Days','Weeks','Months','Years'];
  static const firstColumnWidth = 100.0;


  @override
  void initState() {
    super.initState();
    DoseAttributes? dosageInstructions = Provider.of<MetaProvider>(context, listen: false).dosageInstruction;
    _dosageAttributes = dosageInstructions?.details;
    _drugOrder = widget.medOrder;
    _drugOrder.careSetting = _drugOrder.careSetting ?? careSettingOutPatient;
    _selectedUnitType = _drugOrder.dosingInstructions?.doseUnits;
    _selectedFrequencyType = _drugOrder.dosingInstructions?.frequency;

    var defaultRouteElement = _dosageAttributes?['routes'].firstWhere((element) {
      return element['name'] == lblDefaultRoute;
    }, orElse: () => null);
    var defaultRoute = defaultRouteElement != null ? defaultRouteElement['name'] : null;
    _selectedRouteType = _drugOrder.dosingInstructions?.route ?? defaultRoute;
    _selectedDurationType = _drugOrder.durationUnits ?? 'Days';
    _selectedDosingInstructions = _drugOrder.dosingInstructions?.administrationInstructions;
    _notesController.text = _drugOrder.commentToFulfiller ?? '';
    _effectiveStartDate = _drugOrder.effectiveStartDate ?? DateTime.now();
    _dateController.text = DateFormat('dd-MMM-yyy').format(_effectiveStartDate!);
    _durationController.text = _drugOrder.duration?.toString() ?? '';
    String? dose = _drugOrder.dosingInstructions?.dose.toString();
    showFrequency = dose?[dose.length - 1] != '1'? true:false;
    _doseController.text = dose?[dose.length - 1] != '1' ?
    _drugOrder.dosingInstructions?.dose.toString() ?? '':'';
    _morningDoseController.text = dose?[dose.length - 1] != '1' ? '' : dose?[0] ?? '';
    _afternoonDoseController.text = dose?[dose.length - 1] != '1' ? '' : dose?[1] ?? '';
    _eveningDoseController.text = dose?[dose.length - 1] != '1' ? '' : dose?[2] ?? '';
    if (_drugOrder.dosingInstructions == null) {
      DosingInstructions newDosingInstructions = DosingInstructions();
      _drugOrder.dosingInstructions = newDosingInstructions;
    }
    totalQuantity = _drugOrder.dosingInstructions?.quantity ?? 0.0;
    _totalQuantityNotifier = ValueNotifier<double>(totalQuantity);
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
                        showFrequency ? _selectDose(): _selectCommonTimes(),
                        SizedBox(height: 10),
                        if (showFrequency)
                          _selectFrequency(_dosageAttributes?['frequencies']),
                        _selectRoutes(_dosageAttributes?['routes']),
                        SizedBox(height: 10),
                        _selectDuration(),
                        SizedBox(height: 10),
                        _selectStartDate(),
                        SizedBox(height: 15),
                        _totalQuantityDisplay(),
                        SizedBox(height: 15),
                        _selectDosingInstruction(_dosageAttributes?['dosingInstructions']),
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
                              _drugOrder.dosingInstructions?.doseUnits = _selectedUnitType;
                              _drugOrder.dosingInstructions?.quantityUnits = _selectedUnitType;
                              _drugOrder.dosingInstructions?.route = _selectedRouteType;
                              showFrequency
                                  ? _drugOrder.dosingInstructions?.frequency = _selectedFrequencyType
                                  : _drugOrder.dosingInstructions?.frequency = null;
                              if (_durationController.text.isNotEmpty) {
                                _drugOrder.duration = int.tryParse(_durationController.text);
                              }
                              _drugOrder.durationUnits = _selectedDurationType;
                              _drugOrder.dosingInstructions?.administrationInstructions = _selectedDosingInstructions;
                              _drugOrder.commentToFulfiller = _notesController.text;
                              _drugOrder.dosingInstructions?.quantity = totalQuantity;
                              _drugOrder.dosingInstructions?.dose = double.tryParse(_doseController.text);
                              _drugOrder.effectiveStartDate = _effectiveStartDate;
                              _drugOrder.effectiveStopDate = _calculateEffectiveStopDate(_effectiveStartDate!, _selectedDurationType!);
                              Navigator.pop(context, _drugOrder);
                            },
                            child: const Text('Update', style: TextStyle(color: Colors.white)),
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
    String? display = _drugOrder.drug?.name ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(display, style: TextStyle(fontSize: 20)),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade600,
                  spreadRadius: 0.5,
                  blurRadius: 1,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: Colors.grey),
              color: showFrequency ? Colors.grey : Theme.of(context).canvasColor,
            ),
            child: IconButton(
              icon: Icon(Icons.compare_arrows),
              iconSize: 20,
              color: showFrequency ? Colors.white : Colors.blue,
              isSelected: showFrequency,
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

  Widget _drugDoseUnits(List<dynamic> items) {
      return Container(
        alignment: Alignment.topRight,
        child: DropdownButtonFormField(
          initialValue: _selectedUnitType,
          alignment: Alignment.topLeft,
          onChanged: (value) {
            _selectedUnitType = value!;
          },
          items: (items).map<DropdownMenuItem<String>>((vt) =>
              DropdownMenuItem<String>(value: vt['name'], child: Text(vt['name'] ?? 'unknown'))
          ).toList(),
          validator: (value) => value == null ? dosingUnitRequired : null,
        )
      );
  }

  Padding _selectRoutes(List<dynamic> items) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: firstColumnWidth,
                child: Text(lblRoutes),
              ),
              Expanded(
                  child: DropdownButtonFormField(
                    initialValue: _selectedRouteType,
                    alignment: Alignment.topLeft,
                    onChanged: (value) {
                      _selectedRouteType = value!;
                    },
                    items: (items).map<DropdownMenuItem<String>>((vt) =>
                        DropdownMenuItem<String>(value: vt['name'], child: Text(vt['name'] ?? 'unknown'))
                    ).toList(),
                    validator: (value) => value == null ? routeRequired : null
                 )
              )
            ]
        )
    );
  }

  Padding _selectFrequency(List<dynamic> items) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child:
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: firstColumnWidth,
                    child: Text(lblFrequency),
                  ),
                  Expanded(
                      child: DropdownButtonFormField(
                        initialValue: _selectedFrequencyType,
                        alignment: Alignment.topLeft,
                        onChanged: (value) {
                          setState(() {
                            _selectedFrequencyType = value!;
                            _updateTotalQuantity();
                          });
                        },
                        items: (items).map<DropdownMenuItem<String>>((vt) =>
                            DropdownMenuItem<String>(value: vt['name'], child: Text(vt['name'] ?? 'unknown'))
                        ).toList(),
                        validator: (value) => value == null ? frequencyRequired : null,
                      ),
                  ),
                ]
            )
    );
  }

  Widget _selectDurationUnit(List<dynamic> items) {
    return SizedBox(
      child: DropdownButtonFormField(
        initialValue: _selectedDurationType,
        alignment: Alignment.topLeft,
        onChanged: (value) {
          setState(() {
            _selectedDurationType = value!;
            _updateTotalQuantity();
          });
        },
        items: (items.where((element) => durationUnits.contains(element['name']))).map<DropdownMenuItem<String>>((vt) =>
              DropdownMenuItem<String>(value: vt['name'], child: Text(vt['name'] ?? 'unknown'))
        ).toList(),
        validator: (value) => value == null ? durationUnitRequired : null,
      )
    );
  }

  Padding _selectDosingInstruction(List<dynamic> items) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: firstColumnWidth,
                child: Text(lblDosingInstructions),
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedDosingInstructions,
                  alignment: Alignment.topRight,
                  onChanged: (value) {
                    setState(() {
                      _selectedDosingInstructions = value!;
                    });
                  },
                  items: (items).map<DropdownMenuItem<String>>((vt) =>
                      DropdownMenuItem<String>(value: vt['name'], child: Text(vt['name'] ?? 'unknown'))
                  ).toList(),
                  validator: (value) => value == null ? dosingInstructionRequired : null,
                ),
              ),
            ]
        )
    );
  }

  Padding _selectDose() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: firstColumnWidth,
                child: Text(lblDose),
              ),
              SizedBox(
                width: 50,
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _doseController,
                    textAlign: TextAlign.left,
                    validator: (value) => value!.isEmpty ?doseRequired : null,
                    onChanged: (_) {
                      if (_doseController.text.isNotEmpty) {
                        _updateTotalQuantity();
                      }
                    }
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _drugDoseUnits(_dosageAttributes?['doseUnits']),
              )
          ]
        )
    );
  }

  Padding _selectDuration() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: firstColumnWidth,
                child: Text(lblDuration),
              ),
              SizedBox(
                width: 50,
                child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _durationController,
                      textAlign: TextAlign.left,
                      validator: (value) => value!.isEmpty ? durationRequired : null,
                      onChanged: (_) {
                        if (_durationController.text.isNotEmpty) {
                          _updateTotalQuantity();
                        }
                      }
                  ),
              ),
              SizedBox(
                width:10,
              ),
              Expanded(
                child: _selectDurationUnit(_dosageAttributes?['durationUnits'])
              ),
            ]
        )
    );
  }

  Padding _selectCommonTimes() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child:
        Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: firstColumnWidth,
                child:Text(lblDose),
              ),
              //SizedBox(width: 10,),
              SizedBox(
                  width: 80,
                  child: TextField(
                    decoration: InputDecoration(
                      //border: OutlineInputBorder(),
                      hintText: 'X-X-X',
                    ),
                    inputFormatters: [
                      // FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      // LengthLimitingTextInputFormatter(4),
                      CommonDoseTimeFormatter(pattern: 'X-X-X'),
                    ],
                  )
              ),
              SizedBox(width: 10,),
              Expanded(
                child:_drugDoseUnits(_dosageAttributes?['doseUnits'])
              ),
            ]
        )
    );
  }

  // ignore: unused_element
  Padding _commonTimesRow() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child:
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lblDose),
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
                        onTapOutside: (_)   {
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
                        controller: _eveningDoseController,
                        validator: (value) => value!.isEmpty ? requiredAllTerm:null,
                        onTapOutside: (_){
                          _eveningDoseController.text.isNotEmpty?setState(() {
                            eveningDose = int.tryParse(_eveningDoseController.text)!;
                            _drugOrder.dosingInstructions?.dose =
                                double.tryParse('$morningDose$afternoonDose$eveningDose.1');
                          }):null;
                        },
                      ),
                    ),
                  ),
                  _drugDoseUnits(_dosageAttributes?['doseUnits'])
                ],
              )
          ]
        )
    );
  }

  void _updateTotalQuantity() {
    double doseValue = showFrequency ? double.tryParse(_doseController.text) ?? 0.0 : (morningDose+afternoonDose+eveningDose).toDouble();
    double durationValue = double.tryParse(_durationController.text) ?? 0.0;
    setState(() {
      if (_selectedDurationType == 'Days') {
        totalQuantity = _calculateQuantity(1, doseValue, durationValue);
      } else if (_selectedDurationType == 'Weeks') {
        totalQuantity = _calculateQuantity(7, doseValue, durationValue);
      } else if (_selectedDurationType == 'Months') {
        totalQuantity = _calculateQuantity(30, doseValue, durationValue);
      } else if (_selectedDurationType == 'Years') {
        totalQuantity = _calculateQuantity(365, doseValue, durationValue);
      }
      _totalQuantityNotifier.value = totalQuantity;
    });
  }

  double _calculateQuantity(double factor, double value1, double value2) {
    if (_selectedFrequencyType == null) {
      return 0.0;
    }
    if (showFrequency) {
      var frequencyPerDay = _dosageAttributes?['frequencies'].where((element)=> element['name']==_selectedFrequencyType).toList()[0]['frequencyPerDay'];
      return factor * value1 * value2 * frequencyPerDay;
    } else {
      return factor * value1 * value2;
    }
  }

  Padding _selectStartDate() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: firstColumnWidth,
              child: Text(lblStartDate),
            ),
            Expanded(
              child: TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(suffixIcon: Icon(Icons.calendar_today_outlined)),
                readOnly: true,
                validator: (value) => value!.isEmpty ? startDateRequired : null,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101));
                  if (pickedDate != null) {
                    String formattedDate = DateFormat('dd-MMM-yyy').format(pickedDate);
                    _effectiveStartDate = pickedDate;
                    _dateController.text = formattedDate;
                  }
                                }
              ),
            ),
          ],
        ));
  }

  Widget _totalQuantityDisplay() {
    return ValueListenableBuilder<double>(
      builder: (BuildContext context, double value, Widget? child) {
        // String? quantity = _drugOrder.dosingInstructions?.quantity == null
        //     ? totalQuantity.ceil().toString()
        //     : _drugOrder.dosingInstructions?.quantity?.ceil().toString();
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(lblTotalQuantity),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      width: 150,
                      alignment: Alignment.centerRight,
                      child: Text(value.ceil().toString()),
                    ),
                    _selectedUnitType != null ? Text("$_selectedUnitType") : Padding(padding: EdgeInsets.zero)
                  ],
                ),
              ],
            )
        );
      },
      valueListenable: _totalQuantityNotifier,
    );
  }

  Widget _commentToFulfiller() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
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
        style: Theme.of(context).textTheme.bodyLarge!.merge(
            const TextStyle(
              fontFamily: 'Lexend Deca',
              color: Color(0xFF1E2429),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            )
        ),
        textAlign: TextAlign.start,
      )
    );
  }

  DateTime? _calculateEffectiveStopDate(DateTime startDate, String durationType) {
    switch (durationType) {
      case 'Hours':
        //TODO fix it
        return startDate.add(Duration(hours: int.parse(_durationController.text)));
      case 'Days':
        return startDate.add(Duration(days: int.parse(_durationController.text)));
      case 'Weeks':
        return startDate.add(Duration(days: int.parse(_durationController.text)*7));
      case 'Months':
        return startDate.add(Duration(days: int.parse(_durationController.text)*30));
      case 'Years':
        return startDate.add(Duration(days: int.parse(_durationController.text)*365));
      default:
        return null;
    }
  }
}

class CommonDoseTimeFormatter extends TextInputFormatter {
  final String pattern;
  static const separator = '-';

  CommonDoseTimeFormatter({required this.pattern});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > pattern.length) return oldValue;
        if (newValue.text.length < pattern.length && pattern[newValue.text.length - 1] == separator) {
          return TextEditingValue(
              text: '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
              selection: TextSelection.collapsed(offset: newValue.selection.end + 1));
        }
      }
    }
    return newValue;
  }
}

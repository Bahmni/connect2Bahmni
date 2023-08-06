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
  late Map<dynamic, dynamic>? _selectedUnitType;
  late Map<dynamic, dynamic>? _selectedRouteType;
  late Map<dynamic, dynamic>? _selectedFrequencyType;
  late Map<dynamic, dynamic>? _selectedDurationType;
  late Map<dynamic, dynamic>? _selectedDosingInstructions;
  String lblTitle = " ";
  late BahmniDrugOrder _medication;
  late final Map<dynamic, dynamic>? _dosageInstructions;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  static const lblAddMedication = "Add Medication";
  static const lblEnterMedicationNote = "Enter note for the medication";
  final ValueNotifier<bool> _typeChangeAllowed = ValueNotifier<bool>(true);
  double totalQuantity=0.0;
  late Future<Map?> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture=fetchFromApi()!;
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
        }
        else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
          appBar: AppBar(
            title: Text(lblAddMedication),
          ),
          body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _medicationDisplay(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    alignment: Alignment.centerRight,
                    child: IconButton(onPressed: () {},
                        icon: Icon(
                          Icons.compare_arrows,
                        )
                    ),
                  ),
                  SizedBox(height: 20),
                  _numericRow("Dose", _doseController),
                  SizedBox(height: 20),
                  _unitRow("Dose Units", _dosageInstructions?['doseUnits']),
                  SizedBox(height: 20),
                  _frequencyRow(
                      "Frequency", _dosageInstructions?['frequencies']),
                  SizedBox(height: 20),
                  _routeRow("Routes", _dosageInstructions?['routes']),
                  SizedBox(height: 20),
                  _numericRow("Duration", _durationController),
                  SizedBox(height: 20),
                  _durationUnitRow(
                      "Duration Units", _dosageInstructions?['durationUnits']),
                  SizedBox(height: 20),
                  _startDateRow("Start Date"),
                  SizedBox(height: 20),
                  _totalQuantityRow("Total Quantity"),
                  SizedBox(height: 20),
                  _unitRow("Units", _dosageInstructions?['doseUnits']),
                  SizedBox(height: 20),
                  _dosingInstructionsRow("Dosing Instructions",
                      _dosageInstructions?['dosingInstructions']),
                  SizedBox(height: 20),
                  _commentToFulfiller(),
                  SizedBox(height: 20),
                  Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50)),
                    child: TextButton(
                      autofocus: false,
                      onPressed: () {
                        _medication.dosingInstructions?.doseUnits =
                        _selectedUnitType?['name'];
                        _medication.dosingInstructions?.quantityUnits =
                        _selectedUnitType?['name'];
                        _medication.dosingInstructions?.route =
                        _selectedRouteType?['name'];
                        _medication.dosingInstructions?.frequency =
                        _selectedFrequencyType?['name'];
                        _medication.durationUnits =
                        _selectedDurationType?['name'];
                        _medication.dosingInstructions?.administrationInstructions =
                        _selectedDosingInstructions?['name'];
                        _medication.commentToFulfiller = _notesController.text;
                        _medication.dosingInstructions?.quantity =
                            totalQuantity;
                        Navigator.pop(context, _medication);
                      },
                      child:
                      const Text('Update', style: TextStyle(color: Colors
                          .white)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        );
        }
      }
    );
  }

  Widget _medicationDisplay() {
    String? display = _medication.concept?.name ?? '';
    return Text(display, style: TextStyle(fontSize: 20));
  }

  Padding _unitRow(String lblTitle, List<dynamic> items) {
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
                  return DropdownButton(
                    value: _selectedUnitType,
                    alignment: Alignment.centerRight,
                    onChanged: (newvalue) {
                      setState(() {
                        _selectedUnitType = newvalue!;
                      });
                    },
                    items: (items)
                        .map<DropdownMenuItem<Map<dynamic, dynamic>>>((vt) =>
                            DropdownMenuItem(
                                value: vt,
                                child: Text(vt['name'] ?? 'unknown')))
                        .toList(),
                  );
                },
                valueListenable: _typeChangeAllowed,
              ))
        ]));
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
                  return DropdownButton(
                    value: _selectedRouteType,
                    alignment: Alignment.centerRight,
                    onChanged: (newvalue) {
                      setState(() {
                        _selectedRouteType = newvalue!;
                      });
                    },
                    items: (items)
                        .map<DropdownMenuItem<Map<dynamic, dynamic>>>((vt) =>
                            DropdownMenuItem(
                                value: vt,
                                child: Text(vt['name'] ?? 'unknown')))
                        .toList(),
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
                  return DropdownButton(
                    value: _selectedFrequencyType,
                    alignment: Alignment.centerRight,
                    onChanged: (newvalue) {
                      setState(() {
                        _selectedFrequencyType = newvalue!;
                      });
                    },
                    items: (items)
                        .map<DropdownMenuItem<Map<dynamic, dynamic>>>((vt) =>
                            DropdownMenuItem(
                                value: vt,
                                child: Text(vt['name'] ?? 'unknown')))
                        .toList(),
                  );
                },
                valueListenable: _typeChangeAllowed,
              ))
        ]));
  }

  Padding _durationUnitRow(String lblTitle, List<dynamic> items) {
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
                  return DropdownButton(
                    value: _selectedDurationType,
                    alignment: Alignment.centerRight,
                    onChanged: (newvalue) {
                      setState(() {
                        _selectedDurationType = newvalue!;
                      });
                    },
                    items: (items)
                        .map<DropdownMenuItem<Map<dynamic, dynamic>>>((vt) =>
                            DropdownMenuItem(
                                value: vt,
                                child: Text(vt['name'] ?? 'unknown')))
                        .toList(),
                  );
                },
                valueListenable: _typeChangeAllowed,
              ))
        ]));
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
                  return DropdownButton(
                    value: _selectedDosingInstructions,
                    alignment: Alignment.centerRight,
                    onChanged: (newvalue) {
                      setState(() {
                        _selectedDosingInstructions = newvalue!;
                      });
                    },
                    items: (items)
                        .map<DropdownMenuItem<Map<dynamic, dynamic>>>((vt) =>
                            DropdownMenuItem(
                                value: vt,
                                child: Text(vt['name'] ?? 'unknown')))
                        .toList(),
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
          Container(
            alignment: Alignment.centerRight,
            width: 100,
            child: TextField(
                keyboardType: TextInputType.number,
                controller: controller,
                onTapOutside: (_) {
                  setState(() {
                    if(controller==_doseController) {
                      _medication.dosingInstructions?.dose =
                          double.tryParse(_doseController.text);
                    }
                    else{
                      _medication.duration =
                          int.tryParse(_durationController.text);
                    }
                    _updateResult();
                  });
                }),
          )
        ]));
  }
  void _updateResult() {
    double value1 = double.tryParse(_doseController.text) ?? 0.0;
    double value2 = double.tryParse(_durationController.text) ?? 0.0;
    setState(() {
      if(_selectedDurationType?['name'] == 'Seconds'){
        _quantityCalculate(1/86400, value1, value2);
      }
      else if(_selectedDurationType?['name'] == 'Minutes'){
        _quantityCalculate(1/1440, value1, value2);
      }
      else if(_selectedDurationType?['name'] == 'Hours'){
        _quantityCalculate(1/24, value1, value2);
      }
      else if(_selectedDurationType?['name']=='Days'){
        _quantityCalculate(1, value1, value2);
      }
      else if(_selectedDurationType?['name'] == 'Weeks'){
        _quantityCalculate(7, value1, value2);
      }
      else if(_selectedDurationType?['name'] == 'Months'){
        _quantityCalculate(30, value1, value2);
      }
      else if(_selectedDurationType?['name'] == 'Years'){
        _quantityCalculate(365, value1, value2);
      }
    });
  }
  void _quantityCalculate(double factor, double value1, double value2){
      if(_selectedFrequencyType?['name']=='Once a day'){
        totalQuantity=factor*value1*value2;
      }
      else if(_selectedFrequencyType?['name']=='Twice a day' || _selectedFrequencyType?['name']=='Every 12 hours'){
        totalQuantity=factor*value1*value2*2;
      }
      else if(_selectedFrequencyType?['name']=='Thrice a day' || _selectedFrequencyType?['name']=='Every 8 hours'){
        totalQuantity=factor*value1*value2*3;
      }
      else if(_selectedFrequencyType?['name']=='Four times a day' || _selectedFrequencyType?['name']=='Every 6 hours'){
        totalQuantity=factor*value1*value2*4;
      }
      else if(_selectedFrequencyType?['name']=='Every 4 hours'){
        totalQuantity=factor*value1*value2*6;
      }
      else if(_selectedFrequencyType?['name']=='Every 3 hours'){
        totalQuantity=factor*value1*value2*8;
      }
      else if(_selectedFrequencyType?['name']=='Every 2 hours'){
        totalQuantity=factor*value1*value2*12;
      }
      else if(_selectedFrequencyType?['name']=='Every hour'){
        totalQuantity=factor*value1*value2*24;
      }
      else if(_selectedFrequencyType?['name']=='On alternate days'){
        totalQuantity=value1*value2/2;
      }
      else if(_selectedFrequencyType?['name']=='Once a week'){
        totalQuantity=factor*value1*value2/7;
      }
      else if(_selectedFrequencyType?['name']=='Twice a week'){
        totalQuantity=factor*value1*(value2/7)*2;
      }
      else if(_selectedFrequencyType?['name']=='Thrice a week'){
        totalQuantity=factor*value1*(value2/7)*3;
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
              width: 150,
              alignment: Alignment.centerRight,
              child: TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                      // icon: Icon(Icons.calendar_today),
                      suffixIcon: Icon(Icons.calendar_today)),
                  readOnly: true,
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
    String? quantity=_medication.dosingInstructions?.quantity == null ? totalQuantity.toString() : _medication.dosingInstructions?.quantity.toString();
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(lblTitle),
            Container(
              width: 150,
              alignment: Alignment.centerRight,
              child: Text(quantity.toString()),
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
    await Future.delayed(Duration(seconds: 2));
    return  ConceptDictionary().dosageInstruction().then((value) {
      setState(() {
        _dosageInstructions = value;
        _selectedUnitType = _dosageInstructions?['doseUnits'].first;
        _selectedFrequencyType = _dosageInstructions?['frequencies'].first;
        _selectedRouteType = _dosageInstructions?['routes'].first;
        _selectedDurationType = _dosageInstructions?['durationUnits'].first;
        _selectedDosingInstructions =
            _dosageInstructions?['dosingInstructions'].first;
      });
      return null;
    });
  }
}

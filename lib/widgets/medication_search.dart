import 'dart:async';
import 'package:connect2bahmni/domain/models/bahmni_drug_order.dart';
import 'package:flutter/material.dart';
import '../utils/debouncer.dart';
import '../utils/app_failures.dart';
import '../services/concept_dictionary.dart';

class MedicationSearch extends StatefulWidget {
  const MedicationSearch({super.key});

  @override
  State<MedicationSearch> createState() => _MedicationSearchWidgetState();
}

class _MedicationSearchWidgetState extends State<MedicationSearch> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer();
  final List<DrugConcept> medicationList = [];
  late DrugConcept selectedMedication;

  static const lblAddMedications = 'Add Medications';
  static const lblSearchForMedications = "Search for Medications";
  static const errMedicationSearch = 'Error occurred while searching for medications';

  @override

  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(_searchForMedication);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lblAddMedications)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFDBE2E7)),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                      child: SearchBar(
                          hintText: lblSearchForMedications,
                          hintStyle:  WidgetStateProperty.resolveWith((states) {
                            return Theme.of(context).textTheme.bodyLarge?.merge(
                                TextStyle(fontFamily: 'Lexend Deca', color: Color(0xFF95A1AC), fontSize: 15, fontWeight: FontWeight.normal));
                          }),
                          backgroundColor: WidgetStateColor.resolveWith((states) => Colors.white),
                          controller: searchController,
                          leading: IconButton(icon: Icon(Icons.search), color: Color(0xFF95A1AC), onPressed: () => _searchForMedication())
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height:350,
                      child:ListView.builder(
                        itemCount: medicationList.length,
                        itemBuilder: (BuildContext context, int index) {
                          DrugConcept result=medicationList[index];
                          return ListTile(
                            title: Text(result.name.toString()),
                            trailing: IconButton(onPressed: (){
                              setState(() {
                                _debouncer.stop();
                                selectedMedication=result;
                                Navigator.pop(context,selectedMedication);
                              });
                            }, icon: Icon(Icons.keyboard_arrow_right)),
                          );
                        },
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _searchForMedication() {
    if (searchController.text.trim().isEmpty) return;
    if (searchController.text.trim().length < 3) return;
    _debouncer.run(() {
      if (searchController.text.isEmpty) {
        setState(() {
          medicationList.clear();
        });
        return;
      }
      ConceptDictionary().searchMedication(searchController.text).then((results) {
        if(mounted) {
          setState(() {
            medicationList.clear();
            medicationList.addAll(results);
          });
        }
      }).onError((error, stackTrace) {
        if (!mounted) return;
        String errorMsg = error is Failure ? error.message : errMedicationSearch;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Search failed. $errorMsg')),
        );
      });
    });
  }
}

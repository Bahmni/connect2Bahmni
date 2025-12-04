import 'dart:async';
import 'package:flutter/material.dart';
import '../domain/models/omrs_concept.dart';
import '../utils/debouncer.dart';
import '../utils/app_failures.dart';
import '../services/concept_dictionary.dart';

class InvestigationSearch extends StatefulWidget {
  const InvestigationSearch({super.key});

  @override
  State<InvestigationSearch> createState() => _InvestigationSearchWidgetState();
}

class _InvestigationSearchWidgetState extends State<InvestigationSearch> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer();
  final List<OmrsConcept> investigationList = [];
  late OmrsConcept selectedInvestigation;

  static const lblAddInvestigations = 'Add Investigations';
  static const lblSearchForInvestigations = "Search for Investigations";
  static const errInvestigationSearch = 'Error occurred while searching for investigations';

  @override

  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(_searchForInvestigation);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lblAddInvestigations)),
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
                        hintText: lblSearchForInvestigations,
                        hintStyle:  WidgetStateProperty.resolveWith((states) {
                            return Theme.of(context).textTheme.bodyLarge?.merge(
                                TextStyle(fontFamily: 'Lexend Deca', color: Color(0xFF95A1AC), fontSize: 15, fontWeight: FontWeight.normal));
                        }),
                        backgroundColor: WidgetStateColor.resolveWith((states) => Colors.white),
                        controller: searchController,
                        leading: IconButton(icon: Icon(Icons.search), color: Color(0xFF95A1AC), onPressed: () => _searchForInvestigation())
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
                    itemCount: investigationList.length,
                    itemBuilder: (BuildContext context, int index) {
                    OmrsConcept result=investigationList[index];
                    return ListTile(
                    title: Text(result.display.toString()),
                      trailing: IconButton(onPressed: (){
                        setState(() {
                          _debouncer.stop();
                          selectedInvestigation=result;
                          Navigator.pop(context,selectedInvestigation);
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
  void _searchForInvestigation() {
    if (searchController.text.trim().isEmpty) return;
    if (searchController.text.trim().length < 3) return;
    _debouncer.run(() {
      if (searchController.text.isEmpty) {
        setState(() {
          investigationList.clear();
        });
        return;
      }
      ConceptDictionary().searchInvestigation(searchController.text).then((results) {
        if(mounted) {
          setState(() {
            investigationList.clear();
            investigationList.addAll(results);
          });
        }
      }).onError((error, stackTrace) {
        if (!mounted) return;
        String errorMsg = error is Failure ? error.message : errInvestigationSearch;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Search failed. $errorMsg')),
        );
      });
    });
  }
}

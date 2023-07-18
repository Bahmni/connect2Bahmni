import 'dart:async';
import 'dart:convert';
import 'package:connect2bahmni/screens/models/consultation_board.dart';
import 'package:connect2bahmni/screens/patient_dashboard.dart';
import 'package:flutter/material.dart';

import '../utils/app_urls.dart';
import '../utils/debouncer.dart';
import '../utils/app_failures.dart';
import '../domain/models/omrs_concept.dart';
import '../services/concept_dictionary.dart';
import '../utils/shared_preference.dart';
class InvestigationSearch extends StatefulWidget {
  const InvestigationSearch({Key? key}) : super(key: key);

  @override
  State<InvestigationSearch> createState() => _InvestigationSearchWidgetState();
}

class _InvestigationSearchWidgetState extends State<InvestigationSearch> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer();
  List<OmrsConcept> investigationList = [];
  String selectedInvestigation = '';

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
      appBar: AppBar(title: Text('Investigations Page')),
      body: Column(
        children: [

          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFDBE2E7),
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                    child: SearchBar(
                      hintText: "Find labs",
                      controller: searchController,
                      leading:IconButton(
                            icon: Icon(
                              Icons.search
                            )
                      , onPressed: () {
                              return _searchForInvestigation();
                      },
                       )

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
                // for (var p in investigationList) _resultRow(p),
                Container(
                  height:350,
                  child:ListView.builder(
    itemCount: investigationList.length,
    itemBuilder: (BuildContext context, int index) {
    var result=investigationList[index].display.toString();
    return ListTile(
    title: Text(result),
    tileColor: Colors.white70,
    onTap: (){
      setState(() {
        _debouncer.stop();
        selectedInvestigation=result;
        // print(selectedInvestigationList);
        Navigator.pop(context,selectedInvestigation);
      });
    },
    // height: 20,
    // padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
    );
    },
    )),
              ],
            ),
          ),
        ],
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
      final Future<List<OmrsConcept>> request = ConceptDictionary().searchConcept(searchController.text);
      request.then((results) {
        if(mounted) {
          setState(() {
            investigationList.clear();
            investigationList.addAll(results);
          });
        }
      },
          onError: (err) {
            String errorMsg = err is Failure ? err.message : '';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Search failed. $errorMsg')),
            );
          });
    });
  }
}


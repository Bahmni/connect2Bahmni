import 'dart:async';
import 'package:connect2bahmni/domain/models/omrs_concept.dart';
import 'package:connect2bahmni/domain/models/omrs_order.dart';
import 'package:connect2bahmni/services/emr_api_service.dart';
import 'package:flutter/material.dart';
import '../utils/debouncer.dart';
import '../utils/app_failures.dart';
import '../services/concept_dictionary.dart';
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
  late OmrsConcept selectedInvestigation;

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
      body: SingleChildScrollView(
        child: Column(
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
                              ),
                          onPressed: () {
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
                  Container(
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
                 // selectedInvestigation!=null ? Text(selectedInvestigation.display.toString()):Text(''),
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
      final Future<List<OmrsConcept>> request = ConceptDictionary().searchInvestigation(searchController.text);
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


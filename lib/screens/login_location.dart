import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/locations.dart';
import '../providers/auth.dart';
import '../domain/models/omrs_location.dart';
import '../utils/app_routes.dart';

class LoginLocation extends StatefulWidget {
  const LoginLocation({Key? key}) : super(key: key);

  @override
  _LoginLocationState createState() => _LoginLocationState();
}

class _LoginLocationState extends State<LoginLocation> {
  final _formKey = GlobalKey<FormState>();
  String? selectedValue;
  AuthProvider? _authenticator;

  @override
  Widget build(BuildContext context) {
    _authenticator = Provider.of<AuthProvider>(context);
    Map? assignedLocations = ModalRoute.of(context)?.settings.arguments as Map?;
    Future<List<DropdownMenuItem<String>>> _locationsFuture = (assignedLocations != null)
        ? _fetchPresetLoginLocations(assignedLocations)
        : _fetchAllLoginLocations();
    return FutureBuilder<List<DropdownMenuItem<String>>>(
        future: _locationsFuture,
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List<DropdownMenuItem<String>>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            //write to log
            return const Center(child: Text("Failed to load locations"),);
          }
          if (snapshot.hasData) {
            return _locationForm(context, snapshot.data!);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );
  }

  Scaffold _locationForm(BuildContext context, List<DropdownMenuItem<String>> locationList) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Connect2 Bahmni'),
          elevation: 0.1,
        ),
        body: Container(
          padding: const EdgeInsets.all(40.0),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Login Location', style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButtonFormField<String>(
                      // decoration: InputDecoration(
                      //   enabledBorder: OutlineInputBorder(
                      //     //borderSide: const BorderSide(color: Colors.blue, width: 2),
                      //     borderRadius: BorderRadius.circular(20),
                      //   ),
                      //   border: OutlineInputBorder(
                      //     //borderSide: const BorderSide(color: Colors.blue, width: 2),
                      //     borderRadius: BorderRadius.circular(20),
                      //   ),
                      //   // filled: true,
                      //   // fillColor: Colors.blueAccent,
                      // ),
                      validator: (value) => value == null ? "Select a country" : null,
                      //dropdownColor: Colors.blueAccent,
                      value: selectedValue,
                      onChanged: (newVal)  {
                        selectedValue = newVal;
                      },
                      items: locationList),
                  const SizedBox(height: 5.0),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _authenticator!.updateSessionLocation(OmrsLocation( uuid: selectedValue!, name: '')).then((value) {
                            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                          },
                          onError: (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Login failed. error $e')),
                            );
                          });
                        }
                      },
                      child: const Text("Submit"))
                ],
              ))
        ),
    );
  }

  Future<List<DropdownMenuItem<String>>> _fetchPresetLoginLocations(Map locationsMap) {
    List<DropdownMenuItem<String>> locationList = [];
    for (var element in locationsMap.entries) {
      locationList.add(DropdownMenuItem(child: Text(element.value), value: element.key));
    }
    return Future.delayed(const Duration(seconds: 2), () => locationList,);
  }
  Future<List<DropdownMenuItem<String>>> _fetchAllLoginLocations() {
    var completer = Completer<List<DropdownMenuItem<String>>>();
    print('Fetching all locations ... ');
    Locations().allOmrsLoginLocations().then((values) {
      var list = List<DropdownMenuItem<String>>.of(values.map((loc) => DropdownMenuItem(child: Text(loc.name!), value: loc.uuid)));
      completer.complete(list);
    });
    return completer.future;
  }
}
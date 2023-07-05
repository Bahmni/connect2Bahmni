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
  State<LoginLocation> createState() => _LoginLocationState();
}

const msgFailedToLoadLocations = "Failed to load locations";
const lblProceed = 'Proceed';
const lblHeader = 'Connect2 Bahmni';
const lblLoginLocation = 'Login Location';

class _LoginLocationState extends State<LoginLocation> {
  final _formKey = GlobalKey<FormState>();
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    Map? assignedLocations = ModalRoute.of(context)?.settings.arguments as Map?;
    Future<List<DropdownMenuItem<String>>> locationsFuture = (assignedLocations != null)
        ? _fetchPresetLoginLocations(assignedLocations)
        : _fetchAllLoginLocations();
    return FutureBuilder<List<DropdownMenuItem<String>>>(
        future: locationsFuture,
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List<DropdownMenuItem<String>>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text(msgFailedToLoadLocations),);
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
          title: const Text(lblHeader),
          elevation: 0.1,
        ),
        body: Container(
          padding: const EdgeInsets.all(40.0),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 5.0),
                  DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          // borderSide: const BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) => value == null ? "Select a location" : null,
                      icon: const Icon(Icons.location_on_outlined),
                      value: selectedValue,
                      onChanged: (newVal)  {
                        selectedValue = newVal;
                      },
                      hint: const Text(lblLoginLocation),
                      items: locationList
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50)),
                    child: TextButton(
                      autofocus: false,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Provider.of<AuthProvider>(context, listen: false).updateSessionLocation(OmrsLocation( uuid: selectedValue!, name: '')).then((value) {
                            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                          },
                              onError: (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Login failed. error $e')),
                                );
                              });
                        }
                      },
                      child: const Text(lblProceed,
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ))
        ),
    );
  }

  Future<List<DropdownMenuItem<String>>> _fetchPresetLoginLocations(Map locationsMap) {
    List<DropdownMenuItem<String>> locationList = [];
    for (var element in locationsMap.entries) {
      locationList.add(DropdownMenuItem(value: element.key, child: Text(element.value)));
    }
    return Future.delayed(const Duration(seconds: 2), () => locationList,);
  }
  Future<List<DropdownMenuItem<String>>> _fetchAllLoginLocations() {
    debugPrint("Calling Fetching all locations API");
    var completer = Completer<List<DropdownMenuItem<String>>>();
    Locations().allOmrsLoginLocations().then((values) {
      var list = List<DropdownMenuItem<String>>.of(values.map((loc) => DropdownMenuItem(value: loc.uuid, child: Text(loc.name!))));
      completer.complete(list);
    });
    return completer.future;
  }
}
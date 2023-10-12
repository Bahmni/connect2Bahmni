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
  Future<List<OmrsLocation>>? _locationsFuture;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map? assignedLocations = ModalRoute.of(context)?.settings.arguments as Map?;
    _locationsFuture = (assignedLocations != null)  ? _fetchPresetLoginLocations(assignedLocations) : _fetchAllLoginLocations();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OmrsLocation>>(
        future: _locationsFuture,
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List<OmrsLocation>> snapshot) {
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

  Scaffold _locationForm(BuildContext context, List<OmrsLocation> locationList) {
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
                      items: locationList.map((element) => DropdownMenuItem(value: element.uuid, child: Text(element.name ?? 'unknown'))).toList()
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

  Future<List<OmrsLocation>> _fetchPresetLoginLocations(Map locationsMap) {
    List<OmrsLocation> locations = [];
    for (var element in locationsMap.entries) {
      locations.add(OmrsLocation(uuid: element.key, name: element.value));
    }
    return Future.value(locations);
  }

  Future<List<OmrsLocation>> _fetchAllLoginLocations() {
    return Locations().allOmrsLoginLocations();
  }
}
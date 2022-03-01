import '../domain/models/session.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart';

enum Status {
  notLoggedIn,
  notRegistered,
  loggedIn,
  registered,
  authenticating,
  registering,
  loggedOut
}

class AuthProvider with ChangeNotifier {

  Status _loggedInStatus = Status.notLoggedIn;
  //Status _registeredInStatus = Status.notRegistered;

  Status get loggedInStatus => _loggedInStatus;
  //Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(String username, String password) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    _loggedInStatus = Status.authenticating;
    notifyListeners();

//    Response response = await post(
//      Uri.parse('https://demo.mybahmni.org/openmrs/ws/rest/v1/session'),
//      body: json.encode({}),
//      headers: {'Content-Type': 'application/json'}
//    );

    Response response = await get(Uri.parse('https://qa-02.hip.bahmni-covid19.in/openmrs/ws/rest/v1/session'),
          headers: <String, String>{'authorization': basicAuth, 'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      Session session = Session.fromJson(responseData);
      //UserPreferences().saveUser(authUser);
      _loggedInStatus = Status.loggedIn;
      notifyListeners();
      return {'status': true, 'message': 'Successful', 'session': session};
    } else {
      _loggedInStatus = Status.notLoggedIn;
      //notifyListeners();
      return {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
  }

}
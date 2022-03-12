import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../domain/models/session.dart';
import '../domain/models/omrs_provider.dart';
import '../utils/app_urls.dart';
import '../utils/shared_preference.dart';
import '../services/providers.dart';

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
    Response response = await get(Uri.parse(AppUrls.omrs.session),
          headers: <String, String>{'authorization': basicAuth, 'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      Session session = Session.fromJson(responseData);
      var providerResponse = await Providers().omrsProviderbyUserId(session.user.uuid, () => Future.value(session.sessionId));
      if (providerResponse['status']) {
        session.user.provider = providerResponse['result'] as OmrsProvider;
      }
      _loggedInStatus = Status.loggedIn;
      notifyListeners();
      return {'status': true, 'message': 'Successful', 'session': session};
    } else {
      _loggedInStatus = Status.notLoggedIn;
      notifyListeners();
      return {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
  }

  Future<String?> get sessionId {
    return UserPreferences().getSessionId();
  }

}
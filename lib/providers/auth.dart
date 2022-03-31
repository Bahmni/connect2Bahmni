import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../domain/models/session.dart';
import '../utils/app_urls.dart';
import '../utils/shared_preference.dart';
import '../services/providers.dart';
import '../utils/app_failures.dart';
import '../domain/models/omrs_location.dart';

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
  Status get loggedInStatus => _loggedInStatus;

  //Status _registeredInStatus = Status.notRegistered;
  //Status get registeredInStatus => _registeredInStatus;

  OmrsLocation? _sessionLocation;
  OmrsLocation? get sessionLocation => _sessionLocation;

  Future<Map<String, dynamic>> authenticate(String username, String password) async {
    _loggedInStatus = Status.authenticating;
    notifyListeners();
    Response response = await
      get(Uri.parse(AppUrls.omrs.session),
          headers: <String, String>{
                'authorization': 'Basic ' + base64Encode(utf8.encode('$username:$password')),
                'Content-Type': 'application/json'
          });
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (!responseData['authenticated']) {
        _loggedInStatus = Status.notLoggedIn;
        notifyListeners();
        return {
          'status': false,
          'message': 'Authentication Failed'
        };
      }
      Session session = Session.fromJson(responseData);
      var providerResponse = await Providers().omrsProviderbyUserId(session.user.uuid, () => Future.value(session.sessionId));
      if (providerResponse != null) {
        session.user.provider = providerResponse;
      }
      UserPreferences().saveSession(session);
      _loggedInStatus = Status.loggedIn;
      notifyListeners();
      return {'status': true, 'message': 'Successful', 'session': session };
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

  Future<String> logout() async {
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
      throw 'Logged out already!';
    }

    await delete(
      Uri.parse(AppUrls.omrs.session),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Cookie': 'JSESSIONID=$sessionId',
      },
    );
    return 'Logged out';
  }

  Future<String> updateSessionLocation(OmrsLocation location) async {
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
        throw 'Invalid Session!';
    }
    debugPrint('updateSessionLocation: updating session $sessionId');
    debugPrint('calling URL ${AppUrls.omrs.session}');
    Response response = await post(
      Uri.parse(AppUrls.omrs.session),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Cookie': 'JSESSIONID=$sessionId',
      },
      body: jsonEncode({
        'sessionLocation': location.uuid,
        'locale':'en'
      }),
    );
    debugPrint('updateSessionLocation:   response code = ${response.statusCode}');
    debugPrint('updateSessionLocation:   response body = ${response.body}');
    switch(response.statusCode) {
      case 200: {
        var session = await UserPreferences().getSession();
        _sessionLocation = location;
        session!.sessionLocation = location;
        UserPreferences().saveSession(session);
        return 'Success';
      }
      case 204: {
        throw 'Success';
      }
      default: {
        throw Failure('Could not set login location', response.statusCode);
      }
    }
  }

  Future<Session?> getSession() {
    return UserPreferences().getSession();
  }

  Future<String?> getServerUrl() {
    return UserPreferences().getServerUrl();
  }

}
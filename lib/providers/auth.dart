import 'dart:convert';
import 'dart:io';
import 'package:connect2bahmni/services/domain_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  http.Client? client;
  AuthProvider({this.client});

  Status _loggedInStatus = Status.notLoggedIn;
  Status get loggedInStatus => _loggedInStatus;

  //Status _registeredInStatus = Status.notRegistered;
  //Status get registeredInStatus => _registeredInStatus;

  OmrsLocation? _sessionLocation;
  OmrsLocation? get sessionLocation => _sessionLocation;

  Future<AuthResponse> authenticate(String username, String password) async {
    _loggedInStatus = Status.authenticating;
    notifyListeners();
    var client = _httpClient();
    try {
        var response = await client.get(Uri.parse(AppUrls.omrs.session),
            headers: <String, String>{
              'authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
              'Content-Type': 'application/json'
            });
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          if (!responseData['authenticated']) {
            _loggedInStatus = Status.notLoggedIn;
            notifyListeners();
            return AuthResponse(status: false, message: 'Authentication Failed');
          }
          Session session = Session.fromJson(responseData);
          var cookie = Cookie.fromSetCookieValue(response.headers['set-cookie'] ?? "");
          //debugPrint('cookie - name=${cookie.name}, value=${cookie.value}, domain = ${cookie.domain}, httpOnly = ${cookie.httpOnly}, expires= ${cookie.expires}');
          if (cookie.name == 'JSESSIONID') {
            session.sessionId = cookie.value;
          } else {
             //no sessionId. should throw error
          }
          var providerResponse = await Providers().omrsProviderForUser(
              session.user.uuid, () => Future.value(session.sessionId));
          if (providerResponse != null) {
            session.user.provider = providerResponse;
          }
          UserPreferences().saveSession(session);
          _loggedInStatus = Status.loggedIn;
          notifyListeners();
          return AuthResponse(status: true, session: session, message: 'Successful');
        } else {
          var error = DomainService().handleErrorResponse(response);
          _loggedInStatus = Status.notLoggedIn;
          notifyListeners();
          return AuthResponse(status: false, message: error.message);
        }
    } finally {
        client.close();
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
    var httpClient = _httpClient();
    try  {
      await http.delete(
        Uri.parse(AppUrls.omrs.session),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Accept": "application/json",
          'Cookie': 'JSESSIONID=$sessionId',
        },
      );
      return 'Logged out';
    } finally {
      httpClient.close();
    }
  }

  Future<String> updateSessionLocation(OmrsLocation location) async {
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
        throw 'Invalid Session!';
    }
    var httpClient = _httpClient();
    try {
        var response = await httpClient.post(
          Uri.parse(AppUrls.omrs.session),
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Accept": "application/json",
            'Cookie': 'JSESSIONID=$sessionId',
          },
          body: jsonEncode({
            'sessionLocation': location.uuid,
            'locale': 'en'
          }),
        );
        switch (response.statusCode) {
          case 200:
            {
              var session = await UserPreferences().getSession();
              _sessionLocation = location;
              session!.sessionLocation = location;
              UserPreferences().saveSession(session);
              notifyListeners();
              return 'Success';
            }
          case 204:
            {
              throw 'Success';
            }
          default:
            {
              throw Failure('Could not set login location', response.statusCode);
            }
        }
    } finally {
        httpClient.close();
    }
  }

  Future<Session?> getSession() {
    return UserPreferences().getSession();
  }

   http.Client _httpClient() {
    return client ?? http.Client();
  }
}

class AuthResponse {
  final String? message;
  final Session? session;
  final bool status;

  AuthResponse({required this.status, this.session, this.message});
}
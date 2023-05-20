import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/session.dart';

class UserPreferences {
  Future<bool> saveSession(Session session) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("session", jsonEncode(session.toJson()));
    prefs.setString("sessionId", session.sessionId!);
    if (session.sessionLocation != null) {
      prefs.setString("sessionLocationId", session.sessionLocation!.uuid);
    }
    return Future.value(true);
  }

  Future<Session?> getSession() {
    var completer = Completer<Session?>();
    SharedPreferences.getInstance().then((prefs) {
      var sessionInfo = prefs.getString('session');
      Session? userSession = sessionInfo != null ? Session.fromJson(jsonDecode(sessionInfo)) : null;
      completer.complete(userSession);
    });
    return completer.future;
  }

  Future<String?> getSessionId() {
    var completer = Completer<String?>();
    SharedPreferences.getInstance().then((prefs) {
      completer.complete(prefs.getString("sessionId"));
    });
    return completer.future;
  }

  void removeSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("session");
    prefs.remove("sessionId");
    prefs.remove("sessionLocationId");
  }

  Future<String?> getServerUrl() {
    var completer = Completer<String?>();
    SharedPreferences.getInstance().then((prefs) {
      completer.complete(prefs.getString("serverUrl"));
    });
    return completer.future;
  }

}
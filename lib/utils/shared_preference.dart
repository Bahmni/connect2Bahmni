import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/session.dart';

class UserPreferences {
  Future<bool> saveSession(Session session) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("session", jsonEncode(session.toJson()));
    prefs.setString("sessionId", session.sessionId);
    if (session.sessionLocation != null) {
      prefs.setString("sessionLocationId", session.sessionLocation!.uuid);
    }
    return Future.value(true);
  }

  Future<Session?> getSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionInfo = prefs.getString("session");
    Session? userSession = sessionInfo != null ? Session.fromJson(jsonDecode(sessionInfo)) : null;
    return Future.value(userSession);
  }

  Future<String?> getSessionId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future.value(prefs.getString("sessionId"));
  }

  void removeSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("session");
    prefs.remove("sessionId");
    prefs.remove("sessionLocationId");
  }

}
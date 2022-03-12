import 'dart:convert';


import 'package:http/http.dart';
import '../domain/models/bahmni_appointment.dart';
import '../utils/shared_preference.dart';
import '../utils/app_urls.dart';
import '../utils/app_failures.dart';

class Appointments {
  static const errorInvalidSession = 'Invalid session';
  final errorLoadingAppointments = 'Failed to load appointments';
  static const errorUnAuthorized = 'Session expired please re-login.';
  static const errorForbiddenAccess = 'Access denied. Try to re-login.';

  Future<List<BahmniAppointment>> allAppointments(DateTime forDate) async {
    var searchForDate = DateTime(forDate.year, forDate.month, forDate.day).toIso8601String();
    String url = AppUrls.bahmni.appointment + '/all?forDate=$searchForDate';
    print('calling URL $url');
    String? sessionId = await UserPreferences().getSessionId();
    print('sessionId = $sessionId');
    if (sessionId == null) {
      throw Failure(errorInvalidSession, 401);
    }

    Response response = await get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': 'JSESSIONID=$sessionId',
      },
    );
    return _handleResponse(response);
  }

  List<BahmniAppointment> _handleResponse(Response response) {
    print('response code = ${response.statusCode}');
    switch(response.statusCode) {
      case 200: {
        return _mapToList(response);
      }
      case 401: {
        throw Failure(errorUnAuthorized, 401);
      }
      case 403: {
        throw Failure(errorForbiddenAccess, 403);
      }
      default: {
        throw Failure(errorLoadingAppointments, response.statusCode);
      }
    }
  }

  Future<List<BahmniAppointment>> forPractitioner(String? uuid, DateTime fromDate, DateTime tillDate) async {
    var startDate = DateTime(fromDate.year, fromDate.month, fromDate.day).toIso8601String();
    var endDate = tillDate.toIso8601String();
    String url = AppUrls.bahmni.appointments + '/search';
    print('Searching appointments $url, startDate = $startDate, endDate = $endDate');
    String? sessionId = await UserPreferences().getSessionId();
    if (sessionId == null) {
      throw Exception(errorInvalidSession);
    }
    Response response = await post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Cookie': 'JSESSIONID=$sessionId',
      },
      body: jsonEncode({
        'providerUuid': uuid,
        'startDate': startDate,
        'endDate': endDate
      }),
    );

    return _handleResponse(response);
  }

  List<BahmniAppointment> _mapToList(Response response) {
    var responseJson = jsonDecode(response.body);
    var resultList = responseJson ?? [];
    var appointmentList = List<BahmniAppointment>.from(resultList.map((model) {
      return BahmniAppointment.fromJson(model);
    }));
    return appointmentList;
  }

}
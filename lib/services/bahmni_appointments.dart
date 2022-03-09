import 'dart:convert';

import 'package:bahmni_doctor/domain/models/bahmni_appointment.dart';
import 'package:http/http.dart';

import '../utils/app_urls.dart';

class Appointments {
  Future<List<BahmniAppointment>> allAppointments(DateTime forDate, Future<String?> Function() fetchSessionId) async {
    var searchForDate = DateTime(forDate.year, forDate.month, forDate.day).toIso8601String();
    String url = AppUrls.bahmni.appointmentUrl + '/all?forDate=$searchForDate';
    print('calling URL $url');
    String? sessionId = await fetchSessionId();
    print('sessionId = $sessionId');
    if (sessionId == null) {
      throw Exception('Invalid session. Please login again');
    }

    Response response = await get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': 'JSESSIONID=$sessionId',
      },
    );
    print('response code = ${response.statusCode}');

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      var resultList = responseJson ?? [];
      var appointmentList = List<BahmniAppointment>.from(resultList.map((model) {
        return BahmniAppointment.fromJson(model);
      }));
      return appointmentList;
    }
    throw Exception('Failed to load appointments');
  }
}
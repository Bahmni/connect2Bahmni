
import 'dart:io';

import 'package:connect2bahmni/main.dart';
import 'package:connect2bahmni/providers/auth.dart';
import 'package:connect2bahmni/utils/app_urls.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

void main() {
  test('Login test', () async {
    HttpOverrides.global = DevHttpOverrides();
    Map<String, dynamic> loginResponse = await AuthProvider().authenticate("superman", "Admin1234");
    expect(loginResponse["status"], true);
  });

  // test('fetch session details', () async {
  //   HttpOverrides.global = DevHttpOverrides();
  //   String sessionId = 'DA8DC715F7C88245995CF409B09BFA7F';
  //   Response response = await get(
  //     Uri.parse(AppUrls.omrs.session),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Cookie': 'JSESSIONID=$sessionId',
  //     },
  //   );
  //   print(response.body);
  // });
}
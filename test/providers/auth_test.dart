import 'package:connect2bahmni/providers/auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Login test', () async {
    Map<String, dynamic> loginResponse = await AuthProvider().login("superman", "Admin1234");
    expect(loginResponse["status"], true);
  });
}
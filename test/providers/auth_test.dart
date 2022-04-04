import 'package:connect2bahmni/providers/auth.dart';
import 'package:connect2bahmni/utils/app_urls.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'auth_test.mocks.dart';


@GenerateMocks([http.Client])
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  test('Login test', () async {
    var client = MockClient();
    when(client
        .get(Uri.parse(AppUrls.omrs.session), headers: {
             'authorization': 'Basic ZHJPbmU6dGVzdA==',
             'Content-Type': 'application/json'
        }))
        .thenAnswer((_) async =>
        http.Response('{"authenticated": false, "sessionId": "xyz"}', 200));
    var loginResponse = await AuthProvider(client: client).authenticate("drOne", "test");
    expect(loginResponse.status, false);
  });
}
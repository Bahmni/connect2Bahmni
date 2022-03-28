import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static bool get fhirSupport => dotenv.env['fhir.support'] == 'true';
}
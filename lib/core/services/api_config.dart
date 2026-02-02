import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { test, prod }

class ApiConfig {
  static final Environment environment = dotenv.env['ENVIRONMENT'] == 'test'
      ? Environment.test
      : Environment.prod;

  static String get baseUrl {
    switch (environment) {
      case Environment.prod:
        return dotenv.env['API_URL_PROD'] ?? '';
      case Environment.test:
        return dotenv.env['API_URL_TEST'] ?? '';
    }
  }

  // static String get iosClientId => dotenv.env['IOS_CLIENT_ID'] ?? '';
  static String get webClientId => Platform.isIOS
      ? dotenv.env['IOS_CLIENT_ID'] ?? ""
      : kDebugMode
      ? dotenv.env['WEB_CLIENT_ID_DEBUG'] ?? ''
      : dotenv.env['WEB_CLIENT_ID'] ?? '';
  static String get serverClientId => dotenv.env['SERVER_CLIENT_ID'] ?? "";
}

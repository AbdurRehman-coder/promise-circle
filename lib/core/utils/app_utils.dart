import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class AppUtils {
  static Future<bool> checkAndroidVersion() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final is14OrAbove = androidInfo.version.sdkInt >= 34;
      return is14OrAbove;
    } else {
      return false;
    }
  }
}

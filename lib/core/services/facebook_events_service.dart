// import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
// import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class FacebookEventsService {
  FacebookEventsService._internal();

  static final FacebookEventsService _instance =
      FacebookEventsService._internal();

  factory FacebookEventsService() => _instance;

  // final FacebookAppEvents _facebookAppEvents = FacebookAppEvents();

  Future<void> logEvent({
    required String name,
    required WidgetRef ref,
    required String screenName,
    Map<String, dynamic>? parameters,
    String? testEventCode,
  }) async {
    // try {
    //   final user = ref.read(authenticationProvider).authUser?.user;
    //   parameters ??= {};

    //   // if (testEventCode != null) {
    //   // parameters['_test_event_code'] =testEventCode;
    //   // }

    //   if (user != null) {
    //     // Set user data for better matching in Facebook Events
    //     await _facebookAppEvents.setUserData(
    //       email: user.email,
    //       firstName: user.name?.split(' ').first,
    //       lastName: (user.name?.split(' ').length ?? 0) > 1
    //           ? user.name?.split(' ').last
    //           : null,
    //     );

    //     parameters.addAll({"Name": user.name ?? "", "Email": user.email ?? ""});
    //   }
    //   parameters.addAll({"Screen": screenName});

    //   await _facebookAppEvents.logEvent(name: name, parameters: parameters);

    //   if (kDebugMode) {
    //     print(
    //       '[FacebookEventsHelper] Event logged: $name, Params: $parameters',
    //     );
    //   }
    // } catch (e, stackTrace) {
    //   if (kDebugMode) {
    //     print('[FacebookEventsHelper] Error logging event: $e\n$stackTrace');
    //   }
    // }
  }

  Future<void> logAppLaunch({String? testEventCode}) async {
    // final Map<String, dynamic> parameters = {
    //   'timestamp': DateTime.now().toIso8601String(),
    //   'platform': defaultTargetPlatform.name,
    // };

    // // if (testEventCode != null) {
    // //   parameters['_test_event_code'] = testEventCode;
    // // }

    // await _facebookAppEvents.logEvent(
    //   name: 'app_launch',
    //   parameters: parameters,
    // );
  }

  Future<void> setAdvertiserTracking({required bool enabled}) async {
    try {
      // await _facebookAppEvents.setAdvertiserTracking(enabled: enabled);
    } catch (e) {
      if (kDebugMode) {
        print('[FacebookEventsHelper] Error setting tracking: $e');
      }
    }
  }

  Future<void> requestIOSATT() async {
    try {
      // if (defaultTargetPlatform == TargetPlatform.iOS) {
      //   final status =
      //       await AppTrackingTransparency.trackingAuthorizationStatus;
      //   if (status == TrackingStatus.notDetermined) {
      //     await AppTrackingTransparency.requestTrackingAuthorization();
      //   }
      // }
    } catch (e) {
      if (kDebugMode) {
        print('[FacebookEventsHelper] Error requesting ATT: $e');
      }
    }
  }
}

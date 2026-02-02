import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

import '../../features/seven_day_challenge/data/challenge_data.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint('[Background] Handling message: ${message.messageId}');
// }

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  bool _isInitialized = false;

  bool _areNotificationsEnabled = true;

  static const String _sevenDayChallengeTag = 'seven_day_challenge_v1';
  static const String _androidGroupKey = 'com.sbp.seven_day_challenge';

  // static const String _generalTopic = 'reminder';

  static const AndroidNotificationChannel _challengeChannel =
      AndroidNotificationChannel(
        'challenge_channel_v6',
        'Daily Challenge',
        description: 'Reminders for your 7-Day Promise',
        importance: Importance.max,
        playSound: true,
      );

  static const AndroidNotificationChannel _pushChannel =
      AndroidNotificationChannel(
        'high_importance_channel',
        'Push Notifications',
        description: 'Important announcements and updates',
        importance: Importance.max,
        playSound: true,
      );

  void _log(String message, [Object? error, StackTrace? stackTrace]) {
    String logOutput = '[NotificationService] $message';
    if (error != null) logOutput += '\nError: $error';
    if (stackTrace != null) logOutput += '\nStack: $stackTrace';
    debugPrint(logOutput);
  }

  Future<void> init() async {
    if (_isInitialized) return;

    _log('Initializing NotificationService...');
    try {
      await _setupTimezones();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          );

      await _flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        ),
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          _handleNotificationTap(response);
        },
      );

      final androidPlatform = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      await androidPlatform?.createNotificationChannel(_challengeChannel);
      await androidPlatform?.createNotificationChannel(_pushChannel);

      // await _setupFirebaseHandlers();

      // if (await isPermissionGranted()) {
      //   await _firebaseMessaging.subscribeToTopic(_generalTopic);
      // }

      _isInitialized = true;
      _log('Initialization complete.');
    } catch (e, stack) {
      _log('CRITICAL ERROR initializing NotificationService', e, stack);
    }
  }

  Future<void> _setupTimezones() async {
    tz.initializeTimeZones();
    String timeZoneName;
    try {
      timeZoneName = await FlutterTimezone.getLocalTimezone();
    } catch (e) {
      timeZoneName = 'UTC';
    }
    try {
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      _log('Local location set to: $timeZoneName');
    } catch (e) {
      tz.setLocalLocation(tz.UTC);
    }
  }

  // Future<void> _setupFirebaseHandlers() async {
  //   // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //   // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   //   // 1. Check if user has disabled notifications in the app toggle
  //   //   if (!_areNotificationsEnabled) {
  //   //     _log("Foreground message received but suppressed by user preference.");
  //   //     return;
  //   //   }

  //   //   _log("Got a message whilst in the foreground!");
  //   //   RemoteNotification? notification = message.notification;
  //   //   AndroidNotification? android = message.notification?.android;

  //   //   // If notification is present, we show a Local Notification manually
  //   //   if (notification != null && android != null) {
  //   //     _flutterLocalNotificationsPlugin.show(
  //   //       notification.hashCode,
  //   //       notification.title,
  //   //       notification.body,
  //   //       NotificationDetails(
  //   //         android: AndroidNotificationDetails(
  //   //           _pushChannel.id,
  //   //           _pushChannel.name,
  //   //           channelDescription: _pushChannel.description,
  //   //           icon: android.smallIcon,
  //   //           importance: Importance.max,
  //   //           priority: Priority.high,
  //   //         ),
  //   //         iOS: const DarwinNotificationDetails(
  //   //           presentAlert: true,
  //   //           presentBadge: true,
  //   //           presentSound: true,
  //   //         ),
  //   //       ),
  //   //       payload: jsonEncode(message.data),
  //   //     );
  //   //   }
  //   // });

  //   // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   //   _log("App opened from background via notification");
  //   //   debugPrint("Payload: ${message.data}");
  //   // });
  // }

  void _handleNotificationTap(NotificationResponse response) {
    final String? payload = response.payload;
    _log('Notification clicked: $payload');

    if (payload == _sevenDayChallengeTag) {
      _log("Navigating to Challenge Screen...");
    } else {
      try {
        final data = jsonDecode(payload ?? '{}');
        _log("Navigating based on Push Data: $data");
      } catch (e) {
        _log("Unknown payload format");
      }
    }
  }

  Future<bool> requestPermissions() async {
    if (!_isInitialized) await init();

    bool granted = false;
    try {
      // NotificationSettings settings = await _firebaseMessaging
      //     .requestPermission(
      //       alert: true,
      //       badge: true,
      //       sound: true,
      //       provisional: false,
      //     );
      // _log('Firebase Permission: ${settings.authorizationStatus}');

      // await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      //   alert: true,
      //   badge: true,
      //   sound: true,
      // );

      if (Platform.isAndroid) {
        final androidImplementation = _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

        if (androidImplementation != null) {
          final bool? alarmResult = await androidImplementation
              .requestExactAlarmsPermission();

          final bool? notifResult = await androidImplementation
              .requestNotificationsPermission();

          granted =
              // (settings.authorizationStatus ==
              //     AuthorizationStatus.authorized) &&
              (alarmResult ?? true) && (notifResult ?? true);
        }
      } else {
        // iOS
        granted =
            true; // settings.authorizationStatus == AuthorizationStatus.authorized;
      }
    } catch (e) {
      _log('Error requesting permissions: $e');
    }
    return granted;
  }

  Future<bool> isPermissionGranted() async {
    try {
      // final settings = await _firebaseMessaging.getNotificationSettings();
      // return settings.authorizationStatus == AuthorizationStatus.authorized ||
      //     settings.authorizationStatus == AuthorizationStatus.provisional;
      return true;
    } catch (e) {
      _log('Error checking permission status: $e');
      return false;
    }
  }

  /// Handles both Local and Push toggling
  Future<void> toggleNotifications(bool enable) async {
    _areNotificationsEnabled = enable;

    if (enable) {
      // 1. Request Permission
      await requestPermissions();
      // 2. Subscribe to Push Topic (FCM)
      // await _firebaseMessaging.subscribeToTopic(_generalTopic);
      // _log('Subscribed to $_generalTopic');
    } else {
      // 1. Cancel Local Schedules
      await cancelAllNotifications();
      // 2. Unsubscribe from Push Topic (FCM)
      // This stops background messages from this specific topic.
      // await _firebaseMessaging.unsubscribeFromTopic(_generalTopic);
      // _log('Unsubscribed from $_generalTopic and cancelled local schedules.');

      // Note: If you send pushes to specific tokens (not topics),
      // you must also call your backend API here to update the user's flag.
    }
  }

  Future<void> cancelSevenDayNotifications() async {
    _log('Cancelling Seven Day Challenge notifications by Payload Tag...');
    try {
      final List<PendingNotificationRequest> pendingNotifications =
          await _flutterLocalNotificationsPlugin.pendingNotificationRequests();

      for (final notification in pendingNotifications) {
        if (notification.payload == _sevenDayChallengeTag) {
          await _flutterLocalNotificationsPlugin.cancel(notification.id);
          _log('Cancelled scheduled ID: ${notification.id}');
        }
      }
      _log('Seven Day Challenge cleanup complete.');
    } catch (e, stack) {
      _log('Error during dynamic cancellation', e, stack);
    }
  }

  Future<void> scheduleNotificationAfterDuration({
    required int id,
    required String title,
    required String body,
    required Duration delay,
    String? payload,
  }) async {
    if (!_isInitialized) await init();

    try {
      final location = tz.local;
      final scheduledTime = tz.TZDateTime.now(location).add(delay);

      await _executeZonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledTime: scheduledTime,
        payload: payload ?? _sevenDayChallengeTag,
      );

      _log('Scheduled ID $id after duration $delay at $scheduledTime');
    } catch (e, stack) {
      _log('Failed to schedule duration-based notification ID: $id', e, stack);
    }
  }

  Future<void> scheduleDayContentWithFutureNudges({
    required int dayIndex,
    required String morningBody,
    required String afternoonBody,
    required String eveningBody,
  }) async {
    if (!_isInitialized) await init();

    if (!await isPermissionGranted() || !_areNotificationsEnabled) {
      _log(
        'Permissions not granted or user disabled toggle. Skipping schedule.',
      );
      return;
    }

    _log('--- Scheduling Content for Day $dayIndex ---');

    try {
      await cancelSevenDayNotifications();

      final DateTime now = DateTime.now().add(const Duration(days: 1));
      final Random random = Random();
      final int baseId = dayIndex * 1000;

      await _scheduleOneShot(
        id: baseId + 1,
        title: "7-Day Promise Reset",
        body: morningBody,
        targetDate: now,
        hour: 9,
        minute: 0,
      );

      await _scheduleOneShot(
        id: baseId + 2,
        title: "Quick Check-in",
        body: afternoonBody,
        targetDate: now,
        hour: 14,
        minute: 0,
      );

      await _scheduleOneShot(
        id: baseId + 3,
        title: "End of Day",
        body: eveningBody,
        targetDate: now,
        hour: 20,
        minute: 0,
      );

      if (inactivityNudges.isNotEmpty) {
        for (int i = 1; i <= 14; i++) {
          final DateTime futureDate = now.add(Duration(days: i));
          final int randomIndex = random.nextInt(inactivityNudges.length);
          final int nudgeId = baseId + 100 + i;

          await _scheduleOneShot(
            id: nudgeId,
            title: "The 7-Day Promise Reset",
            body: inactivityNudges[randomIndex],
            targetDate: futureDate,
            hour: 11,
            minute: 0,
          );
        }
      }
      _log('--- Schedule Logic Finished ---');
    } catch (e, stack) {
      _log('Error during scheduling', e, stack);
    }
  }

  Future<void> _scheduleOneShot({
    required int id,
    required String title,
    required String body,
    required DateTime targetDate,
    required int hour,
    required int minute,
  }) async {
    try {
      final location = tz.local;
      final nowLoc = tz.TZDateTime.now(location);

      final tz.TZDateTime scheduledTime = tz.TZDateTime(
        location,
        targetDate.year,
        targetDate.month,
        targetDate.day,
        hour,
        minute,
      );

      if (scheduledTime.isBefore(nowLoc)) {
        _log('SKIP ID $id: in the past.');
        return;
      }

      await _executeZonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledTime: scheduledTime,
        payload: _sevenDayChallengeTag,
      );

      _log('SCHEDULED ID $id at $scheduledTime');
    } catch (e, stack) {
      _log('Failed to schedule notification ID: $id', e, stack);
    }
  }

  Future<void> _executeZonedSchedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
    required String payload,
  }) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _challengeChannel.id,
          _challengeChannel.name,
          channelDescription: _challengeChannel.description,
          importance: _challengeChannel.importance,
          priority: Priority.high,
          playSound: true,
          groupKey: _androidGroupKey,
        ),
        iOS: DarwinNotificationDetails(
          threadIdentifier: _androidGroupKey,
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'default',
          interruptionLevel: InterruptionLevel.active,
        ),
      ),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    _log('All notifications cancelled.');
  }

  Future<String?> getFCMToken() async {
    // return await _firebaseMessaging.getToken();
    return null;
  }
}

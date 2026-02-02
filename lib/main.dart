import 'dart:developer';
import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flashy_flushbar/flashy_flushbar_provider.dart';
import 'package:flutter/foundation.dart' hide debugPrint;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sbp_app/core/services/facebook_events_service.dart';
import 'package:sbp_app/core/services/shared_prefs_services.dart';
import 'package:sbp_app/core/theming/app_theme.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/features/shared/widgets/flushbar.dart';
import 'core/navigation/app_routes.dart' show AppGenerateRoute;
import 'core/services/app_services.dart';
import 'core/services/notification_service.dart';
import 'core/utils/app_utils.dart';
import 'features/splash/presentation/screens/ui_splash.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  // await Firebase.initializeApp();

  // FirebaseMessaging.instance.getToken().then((val) => print(val));
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermissions();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await dotenv.load(fileName: ".env");
  final sharedPrefService = await SharedPrefServices.getInstance();
  initServices(sharedPrefService);
  final fbEvents = FacebookEventsService();
  if (Platform.isIOS) {
    await fbEvents.requestIOSATT();
    await fbEvents.setAdvertiserTracking(enabled: true);
  }
  await fbEvents.logAppLaunch();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  DateTime? _lastPressedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAndroidVersion();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkAndroidVersion() async =>
      await AppUtils.checkAndroidVersion();

  @override
  Future<bool> didPopRoute() async {
    final NavigatorState? nav = navigatorKey.currentState;

    if (nav != null && nav.canPop()) {
      return false;
    }

    final now = DateTime.now();
    final isWithinThreshold =
        _lastPressedAt != null &&
        now.difference(_lastPressedAt!) < const Duration(seconds: 2);

    if (!isWithinThreshold) {
      _lastPressedAt = now;
      if (nav != null && nav.context.mounted) {
        FlashMessage.showSuccess(nav.context, "Press back again to exit!");
      }
      return true;
    }

    await SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [MyNavigatorObserver()],
      navigatorKey: navigatorKey,
      onGenerateRoute: AppGenerateRoute.generateRoute,
      theme: AppTheme.lightTheme,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      title: 'Promise Circles',
      builder: (context, child) {
        ResponsiveLayout.init(context);
        return FlashyFlushbarProvider.init()!(
          context,
          MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
      home: const SplashScreen(),
    );
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> routeStack = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.add(route);
    if (kDebugMode) {
      _logStack();
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.remove(route);
    if (kDebugMode) {
      _logStack();
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.remove(route);
    if (kDebugMode) {
      _logStack();
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) routeStack.remove(oldRoute);
    if (newRoute != null) routeStack.add(newRoute);
    if (kDebugMode) {
      _logStack();
    }
  }

  void _logStack() {
    final names = routeStack
        .map((route) => route.settings.name ?? 'anonymous')
        .toList();
    log('Current Stack: ${names.join(' -> ')}');
  }
}

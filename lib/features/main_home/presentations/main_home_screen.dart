import 'dart:developer';
// import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/features/invite/presentation/screens/invite_code_screen.dart';
import 'package:sbp_app/features/main_home/provider/main_home_provider.dart';
import 'package:sbp_app/features/profile/presentations/profile_screen.dart';
import 'package:sbp_app/features/promise/presentation/screens/promises_screen.dart';
import 'package:sbp_app/features/promise/presentation/screens/ui_promise_flow.dart';
import 'package:sbp_app/features/promise/provider/promise_controller.dart';
import 'package:sbp_app/features/promise/provider/promise_list_provider.dart';
import 'package:sbp_app/features/shared/widgets/squiggly_container.dart';
import 'package:sbp_app/main.dart';

import '../../../core/constants/assets.dart';
import '../../../core/utils/responsive_config.dart';
import '../../auth/provider/authentication_providr.dart';
import '../../keep.ai/presentation/keep.ai_sheet.dart';

class HomeDashboardPage extends ConsumerStatefulWidget {
  static const routeName = '/home-dashboard';
  const HomeDashboardPage({super.key});

  @override
  ConsumerState<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends ConsumerState<HomeDashboardPage> {
  bool _hasLoggedEvent = false;
  // final _facebookAppEvents = FacebookAppEvents();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ref.read(authenticationProvider).hasSubscription) {
        Future.delayed(Duration(seconds: 2)).then(
          (value) => Navigator.pushNamed(
            navigatorKey.currentContext!,
            InviteCodeScreen.routeName,
          ),
        );
      }
      _logHomeScreenView();
    });
  }

  Future<void> _logHomeScreenView() async {
    if (_hasLoggedEvent) return;
    _hasLoggedEvent = true;

    log('🔵 Facebook App Events: Logging home_screen_view event...');
    debugPrint('🔵 Facebook App Events: Logging home_screen_view event...');

    try {
      // await _facebookAppEvents.logEvent(
      //   name: 'home_screen_view',
      //   parameters: {
      //     'screen_name': 'HomeDashboard',
      //     'timestamp': DateTime.now().toIso8601String(),
      //   },
      // );
      log('✅ Facebook App Events: Home screen view event logged successfully');
      debugPrint(
        '✅ Facebook App Events: Home screen view event logged successfully',
      );
    } catch (e, stackTrace) {
      log('❌ Facebook App Events error: $e');
      log('Stack trace: $stackTrace');
      debugPrint('❌ Facebook App Events error: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  void showKeepIntroSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const KeepAiSheet();
      },
    );
  }

  Widget _buildKeepAiButton() {
    return Container(
      height: 64.h,
      width: 84.w,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.primaryBlackColor.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(40.r),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...[
            Container(
              height: 12.w,
              width: 12.w,
              decoration: BoxDecoration(
                color: Color(0xFFeb5757),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8.w),
          ],
          SvgPicture.asset(Assets.svgBottomBarMainIcon, height: 40.h),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final screens = const [
      PromisesScreen(),
      SizedBox.shrink(),
      ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: IndexedStack(index: currentIndex, children: screens),
      floatingActionButton: currentIndex == 0
          ? InkWell(
              onTap: () {
                showKeepIntroSheet(context);
              },
              child: _buildKeepAiButton(),
            )
          : null,
      floatingActionButtonLocation: CustomOffsetFloatingActionButtonLocation(
        offsetX: 10,
        offsetY: 10,
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.whiteColor,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavIcon(
                icon: Icons.home,
                label: "Home",
                active: currentIndex == 0,
                onTap: () =>
                    ref.read(bottomNavIndexProvider.notifier).state = 0,
              ),
              GestureDetector(
                onTap: () {
                  if (!ref.read(authenticationProvider).hasSubscription) {
                    Navigator.pushNamed(
                      navigatorKey.currentContext!,
                      InviteCodeScreen.routeName,
                    );
                    return;
                  }
                  ref.read(promiseControllerProvider.notifier).reset();

                  final hasPromises = ref
                      .read(promisesProvider)
                      .promises
                      .isNotEmpty;

                  final int startStep = hasPromises ? 2 : 0;

                  ref.read(promiseStepIndexProvider.notifier).state = startStep;

                  Navigator.pushNamed(context, UIPromiseFlowScreen.routeName);
                },
                child: SizedBox(
                  height: 50,
                  width: 50,

                  child: SquigglyContainer(
                    borderColor: Color(0xFF6CC163),
                    wavelength: 8,
                    child: Icon(Icons.add, size: 40, color: Color(0xFF6CC163)),
                  ),
                ),
              ),
              _NavIcon(
                icon: Icons.person,
                label: "Profile",
                active: currentIndex == 2,
                onTap: () {
                  if (currentIndex == 2) {
                    return;
                  }
                  ref
                      .read(authenticationProvider.notifier)
                      .loadUser(updateState: true);
                  ref.read(bottomNavIndexProvider.notifier).state = 2;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _NavIcon({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? Colors.black : Colors.grey),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: active ? Colors.black : Colors.grey,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomOffsetFloatingActionButtonLocation
    extends FloatingActionButtonLocation {
  final double offsetX;
  final double offsetY;

  CustomOffsetFloatingActionButtonLocation({
    this.offsetX = 0,
    this.offsetY = 0,
  });

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double x =
        scaffoldGeometry.scaffoldSize.width -
        scaffoldGeometry.floatingActionButtonSize.width -
        offsetX;

    final double y =
        scaffoldGeometry.contentBottom -
        scaffoldGeometry.floatingActionButtonSize.height -
        offsetY;

    return Offset(x, y);
  }
}

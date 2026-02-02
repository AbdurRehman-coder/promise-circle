import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/app_extensions.dart';
import 'package:sbp_app/core/utils/helper_functions.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/features/promise/presentation/screens/regular_reminders_screen.dart';
import 'package:sbp_app/features/promise/presentation/screens/ui_promise_flow.dart';
import 'package:sbp_app/features/promise/presentation/widgets/promise_card.dart';
import 'package:sbp_app/features/promise/provider/promise_controller.dart';
import 'package:sbp_app/features/promise/provider/promise_list_provider.dart';
import 'package:sbp_app/core/constants/assets.dart';

import '../../../../core/utils/responsive_config.dart';
import '../widgets/promise_detail_sheet.dart';

class PromisesScreen extends ConsumerStatefulWidget {
  const PromisesScreen({super.key});

  @override
  ConsumerState<PromisesScreen> createState() => _PromisesScreenState();
}

class _PromisesScreenState extends ConsumerState<PromisesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // void _scrollToTop() {
  //   if (_scrollController.hasClients) {
  //     _scrollController.animateTo(
  //       0,
  //       duration: const Duration(milliseconds: 500),
  //       curve: Curves.easeOutQuart,
  //     );
  //   }
  // }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Good Morning 🌤️";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon ☀️";
    } else {
      return "Good Evening 🌙";
    }
  }

  @override
  Widget build(BuildContext context) {
    final promisesState = ref.watch(promisesProvider);
    final user = ref.watch(
      authenticationProvider.select((s) => s.authUser?.user),
    );
    // bool isFirstTime = ref.watch(
    //   authenticationProvider.select((s) => s.isFirstTime ?? false),
    // );

    // ref.listen(promisesProvider, (previous, next) {
    //   if (!next.isLoading && next.promises.isEmpty && next.error == null) {
    //     ref.read(promiseStepIndexProvider.notifier).state = 0;
    //     if (!isFirstTime) {
    //       Navigator.pushNamed(
    //         context,
    //         PromiseProfileScreen.routeName,
    //         arguments: user!.onboarding,
    //       );
    //     } else {
    //       Navigator.pushNamed(context, UIPromiseFlowScreen.routeName);
    //     }
    //   }

    //   if (previous?.isLoading == true &&
    //       !next.isLoading &&
    //       next.promises.isNotEmpty) {
    //     _scrollToTop();
    //   }
    // });

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 60.h,
              bottom: 30.h,
            ),
            child: Row(
              children: [
                Container(
                  height: 50.h,
                  width: 50.w,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.r),
                    child: (user?.displayPictureURL?.isNotEmpty ?? false)
                        ? Image.network(
                            user!.displayPictureURL!,
                            fit: BoxFit.cover,
                          )
                        : SvgPicture.asset(
                            Assets.svgBottomBarMainIcon,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi ${user?.name ?? ''}",
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          color: AppColors.greyColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        _getGreeting(),
                        style: AppTextStyles.headingTextStyleBogart.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    Assets.svgMenuIcon,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async =>
                  ref.read(promisesProvider.notifier).fetchPromises(),
              color: AppColors.secondaryBlueColor,
              backgroundColor: Colors.white,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 20.w,
                        right: 20.w,
                        bottom: 20.h,
                      ),
                      child: Text(
                        "Here are the Promises you’re keeping today!",
                        style: AppTextStyles.headingTextStyleBogart.copyWith(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Center(
                        child: Text(
                          "Click on a Promise Card to mark it kept.",
                          style: AppTextStyles.headingTextStyleBogart.copyWith(
                            fontSize: 16.sp,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (promisesState.isLoading && promisesState.promises.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.secondaryBlueColor,
                        ),
                      ),
                    )
                  else if (promisesState.promises.isEmpty)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 400.h,
                        child: Center(
                          child: Text(
                            "No promises yet. Pull to refresh or add one below.",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyTextStyle,
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.only(
                        left: 20.w,
                        right: 20.w,
                        top: 0,
                        bottom: 0,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final promise = promisesState.promises[index];
                          return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) =>
                                    PromiseDetailSheet(promise: promise),
                              );
                            },
                            child: PromiseCard(
                              color: index.isEven
                                  ? AppColors.greenColor
                                  : AppColors.blueColor,
                              category: promise.categories!.length > 1
                                  ? "${promise.categories![0].capitalize} +"
                                  : promise.categories![0].capitalize,
                              keptCount: promise.keptCount ?? 0,
                              description: promise.description ?? '',
                              isTrackingStarted:
                                  promise.reminders != null &&
                                  promise.reminders!.isNotEmpty,
                              onEdit: () {
                                ref
                                    .read(promiseControllerProvider.notifier)
                                    .loadForEdit(promise);
                                ref
                                        .read(promiseStepIndexProvider.notifier)
                                        .state =
                                    2;
                                Navigator.pushNamed(
                                  context,
                                  UIPromiseFlowScreen.routeName,
                                );
                              },
                              onShare: () {
                                final provider = ref.read(
                                  authenticationProvider,
                                );
                                final name =
                                    provider.authUser?.user.name ?? " Unknown";
                                HelperFunctions.sharePromise(
                                  context,
                                  result: promise,
                                  name: name, screenName: 'Dashboard', ref: ref,
                                );
                              },
                              onTrack: () {
                                Navigator.pushNamed(
                                  context,
                                  RegularRemindersScreen.routeName,
                                  arguments: {"promise": promise},
                                );
                              },
                            ),
                          );
                        }, childCount: promisesState.promises.length),
                      ),
                    ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // ref
                            //     .read(promiseControllerProvider.notifier)
                            //     .reset();
                            // final hasPromises = ref
                            //     .read(promisesProvider)
                            //     .promises
                            //     .isNotEmpty;
                            // final int startStep = hasPromises ? 2 : 0;
                            // ref.read(promiseStepIndexProvider.notifier).state =
                            //     startStep;
                            // Navigator.pushNamed(
                            //   context,
                            //   UIPromiseFlowScreen.routeName,
                            // );
                          },
                          child: Container(
                            height: 150.h,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              Assets.svgAddMorePromisesIcon,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

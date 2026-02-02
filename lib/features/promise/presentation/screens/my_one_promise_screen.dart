import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbp_app/core/constants/assets.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/helper_functions.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/promise/presentation/screens/regular_reminders_screen.dart';
import 'package:sbp_app/features/shared/widgets/bottom_height_widget.dart';
import 'package:sbp_app/features/shared/widgets/w_app_safe_area.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import '../../../../core/utils/app_extensions.dart';
import '../../../../core/utils/responsive_config.dart';
import '../../../auth/provider/authentication_providr.dart';
import '../../../main_home/presentations/main_home_screen.dart';
import '../../../shared/widgets/squiggly_container.dart';
import '../../provider/promise_list_provider.dart';

class MyOnePromiseScreen extends ConsumerStatefulWidget {
  static const String routeName = '/my-one-promise';

  final dynamic result;
  final bool isNextInvite;
  const MyOnePromiseScreen({
    super.key,
    required this.result,
    required this.isNextInvite,
  });

  @override
  ConsumerState<MyOnePromiseScreen> createState() => _MyOnePromiseScreenState();
}

class _MyOnePromiseScreenState extends ConsumerState<MyOnePromiseScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = ref.read(authenticationProvider);
    final promises = ref.read(promisesProvider).promises.reversed.toList();

    int promiseNo = promises.indexWhere((p) => p.id == widget.result.id) + 1;
    if (promiseNo == 0) {
      promiseNo = promises.length;
    }

    final name = authProvider.authUser?.user.name ?? " Unknown";

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: AppSafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 36.h),
                  SvgPicture.asset(Assets.svgAppNameIcon, height: 32.h),
                  SizedBox(height: 30.h),
                  Text(
                    promiseNo == 1 ? 'My One Promise.' : "Promise #$promiseNo",
                    style: AppTextStyles.headingTextStyleBogart.copyWith(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlackColor,
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverToBoxAdapter(
                child: SquigglyContainer(
                  borderColor: const Color(0xFF6CC163),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 25.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(Assets.svgAppNameIcon, height: 28.h),
                        SizedBox(height: 8.h),
                        Text(
                          promiseNo == 1
                              ? 'MY ONE PROMISE 2026'
                              : "PROMISE #$promiseNo",

                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryBlackColor.withValues(
                              alpha: 0.6,
                            ),
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        _buildSectionDivider(
                          context,
                          (widget.result.categories ?? [])
                              .map((e) => (e as String).capitalizeA.trim())
                              .join(" • "),
                        ),
                        SizedBox(height: 26.h),
                        Text(
                          'I Promise',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headingTextStyleBogart.copyWith(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlackColor,
                          ),
                        ),
                        Text(
                          _cleanDescription(widget.result.description ?? ""),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headingTextStyleBogart.copyWith(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryBlackColor,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        _buildStarDivider(),
                        SizedBox(height: 24.h),
                        Text(
                          '${promiseNo == 1 ? "This is my ONE Promise." : "Here’s my Promise."} Hold me to it!',
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlackColor.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "— ${name.split(' ')[0]}",
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlackColor.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 40.h),
                    _buildActionButton(
                      onTap: () {
                        HelperFunctions.sharePromise(
                          context,
                          result: widget.result,
                          name: name, screenName: 'One Promise', ref: ref,
                        );
                      },
                      label: "Share this Promise",
                      backgroundColor: AppColors.primaryBlackColor,
                      textColor: Colors.white,
                      trailing: Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              Assets.instagramIcon,
                              height: 18.h,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            SvgPicture.asset(
                              Assets.threadIcon,
                              height: 18.h,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            SvgPicture.asset(
                              Assets.tiktokIcon,
                              height: 18.h,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if ((widget.result).reminders == null ||
                        (widget.result).reminders!.isEmpty) ...[
                      SizedBox(height: 12.h),
                      _buildActionButton(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegularRemindersScreen(
                                promiseResult: widget.result,
                              ),
                            ),
                          );
                          setState(() {});
                        },
                        label: "⏱️ Track Promise",

                        backgroundColor: Colors.transparent,
                        textColor: AppColors.primaryBlackColor,
                        borderColor: Colors.black12,
                        isOutlined: true,
                        // spaceBetween: true,

                        // trailing: Text(
                        //   "SOON",
                        //   style: AppTextStyles.bodyTextStyle.copyWith(
                        //     fontSize: 12.sp,
                        //     color: AppColors.greyColor.withValues(alpha: 0.5),
                        //   ),
                        // ),
                      ),
                    ],

                    SizedBox(height: 12.h),
                    _buildActionButton(
                      onTap: () {
                        ref.read(promisesProvider.notifier).fetchPromises();
                        // if (widget.isNextInvite) {
                        //   Navigator.pushNamedAndRemoveUntil(
                        //     context,
                        //     InviteCodeScreen.routeName,
                        //     (route) => false,
                        //   );
                        // } else {
                        bool isHomeFound = false;
                        Navigator.of(context).popUntil((route) {
                          if (route.settings.name ==
                              HomeDashboardPage.routeName) {
                            isHomeFound = true;
                            return true;
                          }
                          return route.isFirst;
                        });

                        if (!isHomeFound) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            HomeDashboardPage.routeName,
                            (route) => false,
                          );
                        }
                        // }
                      },
                      isOutlined: true,
                      label: "💬  Make More Promises",
                      backgroundColor: Colors.white,
                      textColor: AppColors.primaryBlackColor,
                      borderColor: Colors.black12,
                    ),
                    BottomHeightWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionDivider(BuildContext context, String title) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.black12, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: AppTextStyles.headingTextStyleBogart.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlackColor,
                ),
              ),
            ),
          ),
        ),
        const Expanded(child: Divider(color: Colors.black12, thickness: 1)),
      ],
    );
  }

  Widget _buildStarDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.black12, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SvgPicture.asset(
            Assets.svgTwinkleStarsBlackIcon,
            height: 20.h,
            width: 20.w,
          ),
        ),
        const Expanded(child: Divider(color: Colors.black12, thickness: 1)),
      ],
    );
  }

  String _cleanDescription(String desc) {
    String cleaned = desc;
    if (cleaned.toLowerCase().startsWith('i promise')) {
      cleaned = cleaned.substring(9).trim();
    }
    return cleaned;
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback? onTap,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    Widget? trailing,
    bool isOutlined = false,
    bool spaceBetween = false,
  }) {
    return PrimaryButton(
      onPressed: onTap ?? () {},
      text: label,
      icon: trailing,
      borderColor: borderColor,
      textColor: textColor,
      iconLeading: false,
      isOutlined: isOutlined,
      spaceBetween: spaceBetween,
    );
  }
}

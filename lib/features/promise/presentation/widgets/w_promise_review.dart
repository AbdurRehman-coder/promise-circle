import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/app_extensions.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/promise/models/promise_result.dart';
import 'package:sbp_app/features/shared/widgets/squiggly_container.dart';
import 'package:sbp_app/core/constants/assets.dart';

class PromiseReview extends ConsumerStatefulWidget {
  final PromiseResult result;

  const PromiseReview({super.key, required this.result});

  @override
  ConsumerState<PromiseReview> createState() => _PromiseReviewStateV2();
}

class _PromiseReviewStateV2 extends ConsumerState<PromiseReview>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _pulseController;

  late Animation<Offset> _cardSlideAnimation;
  late Animation<double> _cardFadeAnimation;
  late Animation<Offset> _imageDropAnimation;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _cardSlideAnimation =
        Tween<Offset>(begin: const Offset(-1.1, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
          ),
        );

    _cardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _imageDropAnimation =
        Tween<Offset>(begin: const Offset(0.0, -1.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: const Interval(0.4, 0.9, curve: Curves.bounceOut),
          ),
        );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseController.repeat(reverse: true);

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            SlideTransition(
              position: _imageDropAnimation,
              child: Padding(
                padding: EdgeInsets.only(bottom: 24.0.h),
                child: Image.asset(
                  Assets.pngPromiseLockedIn,
                  height: 240.h,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.medium,
                ),
              ),
            ),

            FadeTransition(
              opacity: _cardFadeAnimation,
              child: SlideTransition(
                position: _cardSlideAnimation,
                child: SquigglyContainer(
                  borderColor: const Color(0xFF6CC163),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0.w,
                      vertical: 24.h,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'YOU’VE MADE A REAL PROMISE!',
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greyColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: Colors.black12,
                                thickness: 1,
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),

                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.65,
                                ),

                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    widget.result.categories
                                        .fold(
                                          "",
                                          (a, b) =>
                                              "${a.capitalizeA.trim()} • ${b.capitalizeA.trim()}",
                                        )
                                        .substring(2),
                                    style: AppTextStyles.headingTextStyleBogart
                                        .copyWith(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryBlackColor,
                                        ),
                                  ),
                                ),
                              ),
                            ),

                            const Expanded(
                              child: Divider(
                                color: Colors.black12,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'I Promise',
                          style: AppTextStyles.headingTextStyleBogart.copyWith(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryBlackColor,
                            height: 1.0.h,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          widget.result.description.length < 8
                              ? widget.result.description
                              : widget.result.description.substring(10),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headingTextStyleBogart.copyWith(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryBlackColor,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: Colors.black12,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: _buildPulsingStar(),
                            ),
                            const Expanded(
                              child: Divider(
                                color: Colors.black12,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "We’re proud of you.\nNow let’s look it over.",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.primaryBlackColor.withValues(
                              alpha: 0.8,
                            ),
                            height: 1.4.h,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 32.h),

            _buildFadingSection(
              index: 0,
              child: _buildSection(
                icon: "✨",
                title: 'WHY AM I DOING THIS',
                content: [
                  widget.result.reasons.reason1,
                  widget.result.reasons.reason2,
                  widget.result.reasons.reason3,
                ].where((s) => s != null && s.isNotEmpty).join("\n"),
              ),
            ),
            _buildFadingSection(
              index: 1,
              child: _buildSection(
                icon: "⚠️",
                title: 'IF I DON\'T KEEP IT',
                content: widget.result.breakCost,
              ),
            ),
            if (widget.result.who.isNotEmpty)
              _buildFadingSection(
                index: 2,
                child: _buildSection(
                  icon: "🧑‍🤝‍🧑",
                  title: 'WHO THIS AFFECTS',
                  content: widget.result.who
                      .map(
                        (w) => (w.names != null && w.names!.isNotEmpty)
                            ? '${w.option} - ${w.names}'
                            : w.option,
                      )
                      .join(', '),
                ),
              ),
            if (widget.result.feel.isNotEmpty)
              _buildFadingSection(
                index: 3,
                child: _buildSection(
                  icon: "😊",
                  title: 'HOW WILL I FEEL',
                  content:
                      "I'll Feel ${widget.result.feel.map((f) => (f.customValue != null && f.customValue!.isNotEmpty) ? f.customValue! : f.option).join(', ')}",
                  isLast: true,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPulsingStar() {
    final Animation<double> scaleAnimation = Tween<double>(begin: 1.0, end: 1.3)
        .animate(
          CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
        );

    return ScaleTransition(
      scale: scaleAnimation,
      child: SvgPicture.asset(
        Assets.svgTwinkleStarsBlackIcon,
        height: 20.h,
        width: 20.w,
      ),
    );
  }

  Widget _buildFadingSection({required int index, required Widget child}) {
    final double beginOffset = 0.7 + (index * 0.08);
    final double endOffset = beginOffset + 0.2;

    final Animation<double> fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Interval(
          beginOffset.clamp(0.0, 1.0),
          endOffset.clamp(0.0, 1.0),
          curve: Curves.easeOut,
        ),
      ),
    );

    return FadeTransition(opacity: fade, child: child);
  }

  Widget _buildSection({
    required String icon,
    required String title,
    required String content,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 48.h,
                width: 48.w,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(icon, style: TextStyle(fontSize: 16.sp)),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: AppColors.greyColor,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        content,
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.4.h,
                          color: AppColors.primaryBlackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(color: AppColors.grey200Color, height: 1, thickness: 1),
      ],
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sbp_app/core/constants/assets.dart';
import 'package:sbp_app/core/services/app_services.dart';
import 'package:sbp_app/core/services/notification_service.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/string_hasher.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/features/promise/models/promise_model.dart';
import 'package:sbp_app/features/promise/presentation/widgets/promise_reflection_sheet.dart';
import 'package:sbp_app/features/promise/provider/promise_list_provider.dart';
import 'package:sbp_app/features/shared/widgets/squiggly_container.dart';
import 'package:sbp_app/features/promise/services/promise_services.dart';
import '../../../../core/services/facebook_events_service.dart';
import '../../../../core/utils/app_extensions.dart';
import '../../../../core/utils/responsive_config.dart';
import '../../../shared/widgets/elastic_drag_sheet.dart';
import '../../../shared/widgets/w_primary_button.dart';
import 'promise_outcome_sheet.dart';
// Import the separate file we created above
// import 'widgets/elastic_drag_sheet.dart';

class PromiseDetailSheet extends ConsumerStatefulWidget {
  final PromiseModel promise;

  const PromiseDetailSheet({super.key, required this.promise});

  @override
  ConsumerState<PromiseDetailSheet> createState() => _PromiseDetailSheetState();
}

class _PromiseDetailSheetState extends ConsumerState<PromiseDetailSheet> {
  bool _isKeptLoading = false;
  bool _isBrokeLoading = false;

  Future<void> _handleStatusUpdate(String status) async {
    final bool isKept = status == "KEPT";
    setState(() {
      if (isKept) {
        _isKeptLoading = true;
      } else {
        _isBrokeLoading = true;
      }
    });

    try {
      final promiseService = locator<PromiseServices>();
      final String now = DateTime.now().toIso8601String();
      final reminderType = widget.promise.reminders?.isNotEmpty == true
          ? widget.promise.reminders!.first.reminderType.toUpperCase()
          : null;

      final success = await promiseService.createPromiseHistory(
        promiseId: widget.promise.id ?? "",
        status: status,
        keptAt: now,
        reminderType: reminderType,
        keptDate: reminderType == "ONE_TIME" ? now : null,
        keptDays: reminderType != "ONE_TIME" ? 1 : null,
      );

      if (success && mounted) {
        final fbEvents = FacebookEventsService();

        fbEvents.logEvent(
          name: isKept ? "promise_kept" : 'promise_broke',
          parameters: {'timestamp': DateTime.now().toIso8601String()},
          ref: ref,
          screenName: 'Promise Detail',
        );
        ref.read(promisesProvider.notifier).fetchPromises();
        Navigator.pop(context);
        _showOutcomeSheet(context, isKept: isKept);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isKeptLoading = false;
          _isBrokeLoading = false;
        });
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final bool anyLoading = _isKeptLoading || _isBrokeLoading;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return ElasticDragSheet(
      builder: (context, physics) {
        return Container(
          constraints: BoxConstraints(maxHeight: screenHeight * 0.95),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Fixed Handle Bar
              SizedBox(height: 12.h),
              Container(
                height: 5.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(height: 12.h),

              Flexible(
                fit: FlexFit.loose,
                child: SingleChildScrollView(
                  physics: physics,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10.h),
                      // Streak Section
                      (widget.promise.keptCount ?? 0) > 0
                          ? SizedBox(
                              height: screenHeight * 0.15,
                              child: FittedBox(
                                child: Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          Assets.svgFlameIcon,
                                          height: 110.h,
                                          fit: BoxFit.contain,
                                        ),
                                        Positioned(
                                          top: 48.h,
                                          child: Container(
                                            height: 34.h,
                                            width: 34.w,
                                            alignment: Alignment.center,
                                            child: FittedBox(
                                              child: Text(
                                                (widget.promise.keptCount ?? 0)
                                                    .toString(),
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: AppTextStyles
                                                    .bodyTextStyle
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 32.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Time${(widget.promise.keptCount ?? 0) > 1 ? "s" : ""} Promise kept",
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.bodyTextStyle
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20.sp,
                                          ),
                                    ),
                                    SizedBox(height: 26.h),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox.shrink(),

                      // Main Promise Content
                      SquigglyContainer(
                        borderColor: const Color(0xFF6CC163),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 25.h,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildSectionDivider(
                                context,
                                (widget.promise.categories ?? [])
                                    .map((e) => (e).capitalizeA.trim())
                                    .join(" • "),
                              ),
                              SizedBox(height: 26.h),
                              Text(
                                'I Promise',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.headingTextStyleBogart
                                    .copyWith(
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryBlackColor,
                                    ),
                              ),
                              AutoSizeText(
                                _cleanDescription(
                                  widget.promise.description ?? "",
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: AppTextStyles.headingTextStyleBogart
                                    .copyWith(
                                      fontSize: 26.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryBlackColor,
                                    ),
                              ),
                              SizedBox(height: 32.h),
                              _buildStarDivider(),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Details List
                      _buildDetailRow(
                        icon: "✨",
                        title: "WHY YOU MADE THIS PROMISE",
                        content: [
                          widget.promise.reasons?.reason1 ?? "",
                          widget.promise.reasons?.reason2 ?? "",
                          widget.promise.reasons?.reason3 ?? "",
                        ].where((e) => e.isNotEmpty).join("\n"),
                      ),
                      _buildDetailRow(
                        icon: "⚠️",
                        title: "IF YOU DON'T KEEP IT",
                        content: widget.promise.breakCost ?? "",
                      ),
                      if (widget.promise.who != null &&
                          widget.promise.who!.isNotEmpty)
                        _buildDetailRow(
                          icon: "🧑‍🤝‍🧑",
                          title: "WHO THIS PROMISE AFFECTS",
                          content: widget.promise.who!
                              .map((e) => e.option)
                              .join(", "),
                        ),
                      if (widget.promise.feel != null &&
                          widget.promise.feel!.isNotEmpty)
                        _buildDetailRow(
                          icon: "😊",
                          title: "HOW KEEPING IT MAKES YOU FEEL",
                          content:
                              "I'll Feel ${widget.promise.feel!.map((e) => e.option).join(', ')}",
                          isLast: true,
                        ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),

              // 3. Fixed Buttons Area
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        onPressed: anyLoading
                            ? () {}
                            : () => _handleStatusUpdate("KEPT"),
                        isLoading: _isKeptLoading,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 16.h,
                        ),
                        text: "Kept",
                        icon: const Icon(Icons.check_circle_outline, size: 20),
                        iconLeading: true,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: PrimaryButton(
                        onPressed: anyLoading
                            ? () {}
                            : () => _handleStatusUpdate("BROKE"),
                        isLoading: _isBrokeLoading,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 16.h,
                        ),
                        isOutlined: true,
                        textColor: AppColors.primaryBlackColor,
                        text: "Broke",
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: PrimaryButton(
                        onPressed: anyLoading
                            ? () {}
                            : () {
                                final fbEvents = FacebookEventsService();

                                fbEvents.logEvent(
                                  name: "promise_snooze(More Time)",
                                  parameters: {
                                    'timestamp': DateTime.now()
                                        .toIso8601String(),
                                  },
                                  ref: ref,
                                  screenName: 'Promise Detail',
                                );
                                String name = ref
                                    .read(authenticationProvider)
                                    .authUser!
                                    .user
                                    .name!
                                    .split(' ')
                                    .first;
                                String notificationBody =
                                    "Hey $name, it’s time to check back in with that Promise.";
                                Navigator.pop(context);
                                NotificationService()
                                    .scheduleNotificationAfterDuration(
                                      title: "",
                                      id: StringHasher.getDeterministicInt(
                                        widget.promise.id!,
                                      ),
                                      body: notificationBody,
                                      delay: Duration(hours: 1),
                                    );
                                _showReflectionsheet(context);
                              },
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 16.h,
                        ),
                        isOutlined: true,
                        textColor: AppColors.primaryBlackColor,
                        text: "More Time",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h), // Bottom safe area margin
            ],
          ),
        );
      },
    );
  }

  void _showOutcomeSheet(BuildContext context, {required bool isKept}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          PromiseOutcomeSheet(isKept: isKept, promise: widget.promise),
    );
  }

  void _showReflectionsheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReflectionSheet(promise: widget.promise),
    );
  }

  Widget _buildDetailRow({
    required String icon,
    required String title,
    required String content,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40.h,
                width: 40.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(icon, style: TextStyle(fontSize: 16.sp)),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyTextStyle.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.greyColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      content,
                      style: AppTextStyles.bodyTextStyle.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryBlackColor,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(color: Colors.grey.shade200, height: 1),
      ],
    );
  }
}

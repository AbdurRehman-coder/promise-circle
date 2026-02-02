import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sbp_app/core/constants/promise_profile_data.dart';
import 'package:sbp_app/features/shared/widgets/loacked_content.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/utils/text_styles.dart';
import '../../../core/utils/responsive_config.dart';

class PromiseProfileSlider extends StatefulWidget {
  const PromiseProfileSlider({
    super.key,
    required this.label,
    required this.isSliderLocked,
  });
  final String label;
  final bool isSliderLocked;

  @override
  State<PromiseProfileSlider> createState() => _PromiseProfileSliderState();
}

class _PromiseProfileSliderState extends State<PromiseProfileSlider> {
  int _currentSliderIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  late final List<Map<String, dynamic>> _sliderItems;
  bool _isUserInteracting = false;

  @override
  void initState() {
    super.initState();
    // Ensure data exists, fallback to empty list if key is missing to prevent crash
    _sliderItems = promiseProfilesData[widget.label] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    if (_sliderItems.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      // Root listener to pause autoPlay during interaction
      onPanDown: (_) => setState(() => _isUserInteracting = true),
      onPanCancel: () => setState(() => _isUserInteracting = false),
      onPanEnd: (_) => setState(() => _isUserInteracting = false),
      child: Container(
        width: double.infinity,
        height: 430.h,
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: _sliderItems.length,
                itemBuilder: (context, index, realIndex) {
                  final item = _sliderItems[index];
                  return _buildSlideContent(
                    item['icon'],
                    item['title'],
                    item['content'],
                    item['isBullet'],
                    index,
                  );
                },
                options: CarouselOptions(
                  height: double.infinity,
                  viewportFraction: 1.0,
                  autoPlay: !_isUserInteracting,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.easeInOut,
                  enableInfiniteScroll: false,
                  pageSnapping: true,
                  // Standard physics that work on both iOS and Android
                  scrollPhysics: const BouncingScrollPhysics(),
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentSliderIndex = index;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // Pagination Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _sliderItems.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _carouselController.animateToPage(entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: _currentSliderIndex == entry.key ? 24.w : 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: _currentSliderIndex == entry.key
                          ? AppColors.primaryBlackColor
                          : AppColors.greyColor.withValues(alpha: 0.3),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideContent(
    String icon,
    String title,
    dynamic content,
    bool isBullet,
    int index,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      // FIX: Removed RawGestureDetector here.
      // The parent CarouselSlider will now correctly handle the drag events on iOS.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 64.h,
            width: 64.w,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primaryBlackColor.withValues(alpha: 0.2),
              ),
              shape: BoxShape.circle,
            ),
            child: Text(icon, style: TextStyle(fontSize: 24.sp)),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.headingTextStyleBogart.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlackColor,
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: widget.isSliderLocked && index != 0
                ? LockedContent(
                    overlayText: "Login to reveal",
                    onTap: null,
                    child: _buildDescription(isBullet, content),
                  )
                : _buildDescription(isBullet, content),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(bool isBullet, dynamic content) {
    if (isBullet) {
      final List<String> bulletPoints = List<String>.from(content);
      return Center(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: bulletPoints.map((point) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.0.h),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "•  ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                          color: AppColors.primaryBlackColor,
                        ),
                      ),
                      TextSpan(
                        text: point,
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    return Center(
      child: Text(
        content as String,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyTextStyle.copyWith(
          fontSize: 14.sp,
          height: 1.5,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlackColor,
        ),
      ),
    );
  }
}

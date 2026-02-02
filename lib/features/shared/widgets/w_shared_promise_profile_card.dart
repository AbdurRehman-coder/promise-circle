import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sbp_app/core/constants/assets.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/features/onboarding/provider/onboarding_provider.dart';
import 'package:sbp_app/features/promise/provider/promise_controller.dart';
import 'package:sbp_app/features/shared/providers/ai_examples_provider.dart';
import 'package:sbp_app/features/shared/widgets/squiggly_frame_widget.dart';
import 'package:sbp_app/features/shared/widgets/staggered_column.dart';
import 'package:sbp_app/features/shared/widgets/w_promise_profile_slider.dart';

class SharedPromiseProfileCard extends ConsumerStatefulWidget {
  final String profileLabel;
  final String profileKey;
  final String intentText;
  final String motivationText;
  final String obstacleText;
  final String supportStyleText;
  final bool showCelebration;
  final bool showPromiseExample;
  final bool isSliderLocked;

  const SharedPromiseProfileCard({
    super.key,
    required this.profileLabel,
    required this.profileKey,
    required this.intentText,
    required this.motivationText,
    required this.obstacleText,
    required this.supportStyleText,
    required this.showCelebration,
    required this.showPromiseExample,
    required this.isSliderLocked,
  });

  @override
  ConsumerState<SharedPromiseProfileCard> createState() =>
      _SharedPromiseProfileCardState();
}

class _SharedPromiseProfileCardState
    extends ConsumerState<SharedPromiseProfileCard>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _ambientController;

  late Animation<double> _scaleAnimation;
  late Animation<Offset> _floatAnimation;
  late Animation<double> _glowAnimation;

  late bool _shouldShowCelebration;
  late final String promiseExample;

  @override
  void initState() {
    super.initState();
    promiseExample =
        ((ref.read(aiExamplesControllerProvider).value?.samplePromise) ??
                ref
                    .read(promiseControllerProvider.notifier)
                    .getRandomPromiseExample(ref))
            .substring(9);
    _shouldShowCelebration = widget.showCelebration;

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.elasticOut),
    );

    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _floatAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(0, -0.05),
        ).animate(
          CurvedAnimation(
            parent: _ambientController,
            curve: Curves.easeInOutSine,
          ),
        );

    _glowAnimation = Tween<double>(begin: 10.0, end: 30.0).animate(
      CurvedAnimation(parent: _ambientController, curve: Curves.easeInOutSine),
    );

    _entranceController.forward();

    _ambientController.repeat(reverse: true);

    if (_shouldShowCelebration) {
      Future.delayed(const Duration(milliseconds: 300), () {
        HapticFeedback.heavyImpact();
      });

      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) setState(() => _shouldShowCelebration = false);
      });
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 50.h,
          child: AnimatedBuilder(
            animation: _ambientController,
            builder: (context, child) {
              return Container(
                width: 300.w,
                height: 400.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9B8FD9).withValues(alpha: 0.4),
                      blurRadius: 60 + _glowAnimation.value,
                      spreadRadius: _glowAnimation.value,
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        ScaleTransition(
          scale: _scaleAnimation,
          child: StaggeredColumn(
            delay: const Duration(milliseconds: 400),
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(),
              SizedBox(height: 16.h),
              _buildInfoGrid(),
              SizedBox(height: 16.h),
              PromiseProfileSlider(
                label: widget.profileLabel,
                isSliderLocked: widget.isSliderLocked,
              ),
              widget.showPromiseExample
                  ? Column(
                      children: [
                        SizedBox(height: 18.h),
                        Center(
                          child: Text(
                            'Here’s an example of a strong first promise',
                            style: AppTextStyles.bodyTextStyle.copyWith(
                              fontSize: 14,
                              color: AppColors.primaryBlackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        SquigglyFrameWidget(
                          title: SvgPicture.asset(Assets.svgStarsIcon),
                          descriptionText: promiseExample,
                          frameBorderColor: const Color(0XFF6CC163),
                          descriptionStartText: "I Promise",
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),

        if (_shouldShowCelebration)
          Positioned.fill(
            child: IgnorePointer(child: _RealisticConfettiOverlay()),
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // gradient: const LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [Color(0xFF9B8FD9), Color(0xFF6258B5)],
        // ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryBlackColor, AppColors.secondaryBlueColor],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6258B5).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'YOUR',
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteColor.withValues(alpha: 0.6),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            SvgPicture.asset(Assets.svgAppNameWhiteIcon, height: 25.h),
            SizedBox(height: 5.h),
            Text(
              'PROFILE IS',
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor.withValues(alpha: 0.6),
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                widget.profileLabel,
                style: AppTextStyles.headingTextStyleBogart.copyWith(
                  fontSize: 46.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              widget.profileKey.replaceAll("-", " • "),
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColor.withValues(alpha: 0.9),
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 35.h),
            SlideTransition(
              position: _floatAnimation,
              child: _buildProfileImage(),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (widget.profileLabel == "Competitor") {
      return Image.asset(Assets.pngCompetitorOnboardingResult, height: 290.h);
    } else if (promiseProfileValues.containsKey(widget.profileLabel)) {
      return SvgPicture.asset(
        promiseProfileValues[widget.profileLabel]!,
        height: 290.h,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildInfoGrid() {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildInfoCard(0, '🎯 INTENT', widget.intentText),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: _buildInfoCard(
                  1,
                  '🔥 MOTIVATION',
                  widget.motivationText,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildInfoCard(2, '🌀 OBSTACLE', widget.obstacleText),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: _buildInfoCard(
                  3,
                  '🤝 HERE FOR',
                  widget.supportStyleText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(int index, String title, String content) {
    BorderRadius radius;
    switch (index) {
      case 0:
        radius = BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(4.r),
          bottomLeft: Radius.circular(4.r),
          bottomRight: Radius.circular(4.r),
        );
        break;
      case 1:
        radius = BorderRadius.only(
          topRight: Radius.circular(16.r),
          topLeft: Radius.circular(4.r),
          bottomLeft: Radius.circular(4.r),
          bottomRight: Radius.circular(4.r),
        );
        break;
      case 2:
        radius = BorderRadius.only(
          bottomLeft: Radius.circular(16.r),
          topRight: Radius.circular(4.r),
          topLeft: Radius.circular(4.r),
          bottomRight: Radius.circular(4.r),
        );
        break;
      case 3:
        radius = BorderRadius.only(
          bottomRight: Radius.circular(16.r),
          topRight: Radius.circular(4.r),
          bottomLeft: Radius.circular(4.r),
          topLeft: Radius.circular(4.r),
        );
        break;
      default:
        radius = BorderRadius.zero;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7E4),
        borderRadius: radius,
        border: Border.all(
          color: AppColors.whiteColor.withValues(alpha: 0.4),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.greyColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlackColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedCheckmark extends StatefulWidget {
  const _AnimatedCheckmark();

  @override
  State<_AnimatedCheckmark> createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<_AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: CustomPaint(painter: _CheckPainter(_animation)),
    );
  }
}

class _CheckPainter extends CustomPainter {
  final Animation<double> animation;
  _CheckPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6258B5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(5, 10);
    path.lineTo(9, 14);
    path.lineTo(15, 6);

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      final extractPath = metric.extractPath(
        0.0,
        metric.length * animation.value,
      );
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) => true;
}

class _RealisticConfettiOverlay extends StatefulWidget {
  @override
  State<_RealisticConfettiOverlay> createState() =>
      _RealisticConfettiOverlayState();
}

class _RealisticConfettiOverlayState extends State<_RealisticConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_PhysicsParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _initExplosion();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  void _initExplosion() {
    final colors = [
      const Color(0xFF6CC163), // Green
      const Color(0xFF3E92E5), // Blue
      const Color(0xFFE47239), // Orange
      const Color(0xFF9B8FD9), // Purple
      const Color(0xFFFFD700), // Gold
    ];

    for (int i = 0; i < 80; i++) {
      double angle = -pi / 2 + (_random.nextDouble() * 2 - 1);
      double speed = _random.nextDouble() * 10 + 5;

      _particles.add(
        _PhysicsParticle(
          color: colors[_random.nextInt(colors.length)],
          x: 0.0,
          y: 0.0,
          vx: cos(angle) * speed,
          vy: sin(angle) * speed,
          size: _random.nextDouble() * 6 + 4,
          rotationSpeed: _random.nextDouble() * 0.2 - 0.1,
          wobbleSpeed: _random.nextDouble() * 0.1 + 0.05,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _PhysicsConfettiPainter(
            progress: _controller.value,
            particles: _particles,
          ),
        );
      },
    );
  }
}

class _PhysicsParticle {
  Color color;
  double x;
  double y;
  double vx;
  double vy;
  double size;
  double rotation = 0;
  double rotationSpeed;
  double wobble = 0;
  double wobbleSpeed;

  _PhysicsParticle({
    required this.color,
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.rotationSpeed,
    required this.wobbleSpeed,
  });
}

class _PhysicsConfettiPainter extends CustomPainter {
  final double progress;
  final List<_PhysicsParticle> particles;

  _PhysicsConfettiPainter({required this.progress, required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0 || progress == 1) return;

    final paint = Paint()..style = PaintingStyle.fill;
    final centerX = size.width / 2;
    final centerY = size.height / 2 - 100;

    const double dt = 0.8;
    const double gravity = 0.35;
    const double airResistance = 0.96;

    for (var p in particles) {
      p.x += p.vx * dt;
      p.y += p.vy * dt;

      p.vy += gravity;
      p.vx *= airResistance;
      p.vy *= airResistance;

      p.rotation += p.rotationSpeed;
      p.wobble += p.wobbleSpeed;

      double drawX = centerX + p.x;
      double drawY = centerY + p.y;

      double opacity = 1.0;
      if (progress > 0.8) {
        opacity = (1.0 - progress) * 5;
      }
      paint.color = p.color.withValues(alpha: opacity.clamp(0.0, 1.0));

      double width3D = p.size * cos(p.wobble);

      canvas.save();
      canvas.translate(drawX, drawY);
      canvas.rotate(p.rotation);

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: width3D,
          height: p.size * 1.2,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _PhysicsConfettiPainter oldDelegate) => true;
}

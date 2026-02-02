import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:sbp_app/core/services/app_services.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/features/promise/presentation/screens/my_one_promise_screen.dart';
import 'package:sbp_app/features/seven_day_challenge/provider/challenge_provider.dart';
import 'package:sbp_app/features/seven_day_challenge/services/challenge_services.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/features/onboarding/presentation/widgets/w_progress_header.dart';
import 'package:sbp_app/features/promise/data/options.dart';
import 'package:sbp_app/features/promise/presentation/widgets/broken_promise_step.dart';
import 'package:sbp_app/features/promise/presentation/widgets/promise_categories_flow.dart';
import 'package:sbp_app/features/promise/presentation/widgets/w_define_step.dart';
import 'package:sbp_app/features/promise/presentation/widgets/w_multi_select_step.dart';
import 'package:sbp_app/features/promise/presentation/widgets/w_promise_review.dart';
import 'package:sbp_app/features/promise/presentation/widgets/w_text_input_step.dart';
import 'package:sbp_app/features/promise/presentation/widgets/w_why_step.dart';
import 'package:sbp_app/features/promise/presentation/widgets/w_transform_step.dart';
import 'package:sbp_app/features/promise/provider/promise_controller.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/services/facebook_events_service.dart';
import '../../../../core/utils/helper_functions.dart';
import '../../../../core/utils/responsive_config.dart';
import '../../../auth/provider/authentication_providr.dart';
import '../../../shared/widgets/w_app_safe_area.dart';

class UIPromiseFlowScreen extends ConsumerStatefulWidget {
  static const String routeName = '/promise';
  const UIPromiseFlowScreen({
    super.key,
    required this.isChallengePromise,
    required this.dayKey,
  });

  final bool isChallengePromise;
  final String dayKey;

  @override
  ConsumerState<UIPromiseFlowScreen> createState() =>
      _UIPromiseFlowScreenState();
}

class _UIPromiseFlowScreenState extends ConsumerState<UIPromiseFlowScreen> {
  late int _initialStartStep;
  final ScrollController _scrollController = ScrollController();

  static const int _stepTransform = 1;
  static const int _stepDefine = 2;
  static const int _stepWhy = 4;
  static const int _stepCost = 5;
  static const int _stepAffect = 6;
  static const int _stepFeel = 7;
  static const int _stepReview = 8;
  static const int _totalSteps = 9;

  @override
  void initState() {
    super.initState();
    _initialStartStep = ref.read(promiseStepIndexProvider);
    debugPrint(
      '[UIPromiseFlowScreen] Init. Initial Start Step: $_initialStartStep',
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _navigateBack(int currentStepIndex) {
    if (currentStepIndex == _initialStartStep) {
      Navigator.pop(context);
    } else {
      if (currentStepIndex > _initialStartStep &&
          currentStepIndex != _stepReview) {
        debugPrint('[UIPromiseFlowScreen] Decrementing Step Index');
        ref.read(promiseStepIndexProvider.notifier).state =
            currentStepIndex - 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStepIndex = ref.watch(promiseStepIndexProvider);
    final isLoading = ref.watch(promiseLoadingProvider);

    final isReviewStep = currentStepIndex >= _stepReview;
    final showHeader =
        currentStepIndex > _stepTransform && currentStepIndex < _stepReview;

    final isContinueEnabled =
        isReviewStep ||
        ref.watch(
          promiseControllerProvider.select(
            (controller) => ref
                .read(promiseControllerProvider.notifier)
                .isContinueEnabled(currentStepIndex),
          ),
        );

    ref.listen(promiseStepIndexProvider, (previous, next) {
      if (previous != next) {
        _scrollToTop();
      }
    });

    return PopScope(
      canPop: currentStepIndex == _initialStartStep,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          ref.read(promiseControllerProvider.notifier).reset();
          return;
        }
        _navigateBack(currentStepIndex);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: AppSafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 20.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    if (currentStepIndex == _stepTransform)
                      _buildBackButton(currentStepIndex),
                    _buildAnimatedHeader(
                      showHeader,
                      currentStepIndex,
                      _totalSteps,
                    ),
                    Container(
                      key: ValueKey<int>(currentStepIndex),
                      child: isReviewStep
                          ? _buildReviewContent()
                          : _buildStep(currentStepIndex),
                    ),
                  ]),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 10.h),
                    if (isReviewStep) _buildShareButton(),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 32.h,
                        left: 20.w,
                        right: 20.w,
                      ),
                      child: PrimaryButton(
                        enabled: isContinueEnabled,
                        isLoading: isLoading,
                        text: _getButtonText(currentStepIndex),
                        onPressed: () => _handleContinue(currentStepIndex),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(int currentStepIndex) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 20.w),
        child: GestureDetector(
          onTap: () => _navigateBack(currentStepIndex),
          child: SvgPicture.asset(
            Assets.svgArrowBackward,
            height: 24.h,
            width: 24.w,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader(
    bool showHeader,
    int currentStepIndex,
    int totalSteps,
  ) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 400),
      child: AnimatedOpacity(
        opacity: showHeader ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: showHeader
            ? Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: HeaderWithProgress(
                      backButton: true,
                      currentStep: currentStepIndex - 2,
                      totalSteps: totalSteps - 2,
                      onBack: () => _navigateBack(currentStepIndex),
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildReviewContent() {
    return Consumer(
      builder: (context, ref, child) {
        final result = ref.watch(promiseResultProvider);
        if (result != null) {
          return PromiseReview(result: result);
        }
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
            child: const CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildShareButton() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 16.h),
      child: PrimaryButton(
        iconLeading: true,
        icon: SvgPicture.asset(Assets.svgShareBlackIcon),
        isOutlined: true,
        text: "Share my Promise",
        borderColor: AppColors.primaryBlackColor.withValues(alpha: 0.3),
        onPressed: () async {
          final result = ref.read(promiseResultProvider);
          final provider = ref.read(authenticationProvider);
          final name = provider.authUser?.user.name ?? " Unknown";
          HelperFunctions.sharePromise(
            context,
            result: result,
            name: name,
            screenName: 'Promise Review',
            ref: ref,
          );
        },
      ),
    );
  }

  Widget _buildStep(int index) {
    switch (index) {
      case 0:
        return BrokenStep();
      case _stepTransform:
        return const TransformStep();
      case _stepDefine:
        return const DefineStep();
      case 3:
        return const CategorySelectionScreen();
      case _stepWhy:
        return WhyStep();
      case _stepCost:
        return TextInputStep(
          stepIndex: 5,
          title: "What might it cost you if you break this promise?",
          description:
              "This is just about understanding what’s at stake, not judging yourself.",
          fields: const [
            TextInputField(
              key: 'breakCost',
              hint: "Type here",
              label: 'If I break this promise...',
            ),
          ],
        );
      case _stepAffect:
        return MultiSelectStep(
          stepIndex: 6,
          title: "Who does keeping this promise really affect?",
          description:
              "Choose who this affects. If it’s someone specific, add their name.",
          options: whoSelectOptions,
          needsNameInput: true,
        );
      case _stepFeel:
        return MultiSelectStep(
          stepIndex: 7,
          title: "How would you really feel if you kept this promise?",
          description:
              "Be honest. How does keeping this feel now,  and how do you think it’ll feel later?",
          options: feelSelectOptions,
          needsCustomInput: true,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  String _getButtonText(int index) {
    if (index == _stepTransform) return "Create a new Promise instead";
    if (index == _stepFeel) return 'Lock In this Promise 🔓';
    if (index >= _stepReview) return 'Start Keeping Promises!';
    return 'Continue';
  }

  Future<void> _handleContinue(int index) async {
    debugPrint('[UIPromiseFlowScreen] Continue Pressed. Passed Index: $index');

    if (index > _stepReview) {
      debugPrint('[UIPromiseFlowScreen] Ignored tap on invalid index $index');
      return;
    }

    final controller = ref.read(promiseControllerProvider.notifier);
    final indexNotifier = ref.read(promiseStepIndexProvider.notifier);

    void nextStep() => indexNotifier.state = index + 1;

    try {
      switch (index) {
        case _stepTransform:
          controller.setDescription("I Promise ");
          await controller.getPromiseExampleFromBroken(ref);
          nextStep();
          break;

        case _stepDefine:
          await controller.getPromiseReasonExample(ref);
          nextStep();
          break;

        case _stepWhy:
          await controller.getPromiseCostExample(ref);
          nextStep();
          break;

        case _stepFeel:
          if (ref.read(promiseLoadingProvider)) return;

          debugPrint('[UIPromiseFlowScreen] Submitting Promise...');
          await controller.submitPromise(
            context,
            controller.selectedPromise != null,
          );
          final fbEvents = FacebookEventsService();

           fbEvents.logEvent(
            name: 'promise_create',
            parameters: {'timestamp': DateTime.now().toIso8601String()},
            ref: ref,
            screenName: 'Promise Creation',
          );
          if (widget.isChallengePromise) {
            await locator.get<ChallengeServices>().updateDay(widget.dayKey);
            final challengeNotifier = ref.read(challengeProvider.notifier);
            final updatedChallenge = await challengeNotifier.loadChallenge();
            challengeNotifier.updateNotifications(updatedChallenge);
          }

          if (!mounted) return;

          final result = ref.read(promiseResultProvider);
          if (result != null) {
            debugPrint('[UIPromiseFlowScreen] Submit Success. To Step 8.');
            indexNotifier.state = _stepReview;
          }
          break;

        case _stepReview:
          debugPrint('[UIPromiseFlowScreen] Finishing Flow.');
          controller.reset();
          final result = ref.read(promiseResultProvider);

          if (!mounted) return;

          final authState = ref.read(authenticationProvider);
          if (widget.isChallengePromise) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              MyOnePromiseScreen.routeName,
              (route) => false,
              arguments: {
                'result': result,
                'is_next_invite': !authState.hasSubscription,
              },
            );
          } else {
            Navigator.pushReplacementNamed(
              context,
              MyOnePromiseScreen.routeName,
              arguments: {
                'result': result,
                'is_next_invite': !authState.hasSubscription,
              },
            );
          }
          break;

        default:
          debugPrint('[UIPromiseFlowScreen] Moving to next step: ${index + 1}');
          nextStep();
          break;
      }
    } catch (e) {
      debugPrint('[UIPromiseFlowScreen] Error handling continue: $e');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/services/app_services.dart';
import 'package:sbp_app/core/services/facebook_events_service.dart';
import 'package:sbp_app/core/services/shared_prefs_services.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/auth/presentation/screens/ui_main_signup.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/features/onboarding/model/onboarding_data_model.dart';
import 'package:sbp_app/features/shared/widgets/bottom_height_widget.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/features/onboarding/services/onboarding_services.dart';
import 'package:sbp_app/features/shared/widgets/flushbar.dart';
import 'package:sbp_app/features/shared/widgets/staggered_column.dart';
import '../../../shared/providers/ai_examples_provider.dart';
import '../../../shared/widgets/w_app_safe_area.dart';
import '../../provider/onboarding_provider.dart';
import '../widgets/w_onbaording_gridview.dart';
import '../widgets/w_onbording_list_view.dart';
import '../widgets/w_progress_header.dart';

class UIOnboardingScreen extends ConsumerStatefulWidget {
  const UIOnboardingScreen({super.key});

  static const String routeName = '/onboarding';
  static String routePath = '/onboarding';

  @override
  ConsumerState<UIOnboardingScreen> createState() => _UIOnboardingScreenState();
}

class _UIOnboardingScreenState extends ConsumerState<UIOnboardingScreen> {
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steps = ref.watch(onboardingStepsProvider);
    final currentStepIndex = ref.watch(onboardingStepIndexProvider);
    ref.watch(onboardingControllerProvider);
    final step = steps[currentStepIndex];
    final controller = ref.read(onboardingControllerProvider.notifier);
    final isLoading = ref.watch(onboardingLoadingProvider);
    ref.listen(onboardingStepIndexProvider, (previous, next) {
      if (previous != next && _scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });

    return PopScope(
      canPop: currentStepIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          if (currentStepIndex > 0) {
            ref.read(onboardingStepIndexProvider.notifier).state--;
          }
        }
      },
      child: Scaffold(
        body: AppSafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    AnimatedSize(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutQuart,
                      child: AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Column(
                          children: [
                            HeaderWithProgress(
                              currentStep: currentStepIndex,
                              totalSteps: steps.length,
                              backButton: currentStepIndex != 0,
                              onBack: () {
                                if (currentStepIndex > 0) {
                                  ref
                                      .read(
                                        onboardingStepIndexProvider.notifier,
                                      )
                                      .state--;
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                            SizedBox(height: 32.h),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      key: ValueKey<int>(currentStepIndex),
                      child: StaggeredColumn(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            steps[currentStepIndex].question,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.headingTextStyleBogart,
                          ),
                          SizedBox(height: 32.h),
                          Text(
                            steps[currentStepIndex].description,
                            style: AppTextStyles.boldBodyTextStyle,
                          ),
                          SizedBox(height: 10.h),
                          steps[currentStepIndex].isGrid
                              ? OnboardingGridView(
                                  options: steps[currentStepIndex].options,
                                  maxSelection:
                                      steps[currentStepIndex].maxSelection,
                                  currentStepIndex: currentStepIndex,
                                )
                              : OnboardingListView(
                                  options: steps[currentStepIndex].options,
                                  currentStepIndex: currentStepIndex,
                                  maxSelection:
                                      steps[currentStepIndex].maxSelection,
                                ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: 10.h),
                      // if (isFinalScreen)
                      //   PrimaryButton(
                      //     iconLeading: true,
                      //     icon: SvgPicture.asset(Assets.svgShareBlackIcon),
                      //     isOutlined: true,
                      //     text: "Share my promise profile",
                      //     borderColor: AppColors.primaryBlackColor.withValues(
                      //       alpha: 0.3,
                      //     ),
                      //     onPressed: () async {
                      //       HelperFunctions.sharePromiseProfile(
                      //         context,
                      //         label: ref
                      //             .read(onboardingResultProvider)!
                      //             .profile
                      //             .label,
                      //         key: ref
                      //             .read(onboardingResultProvider)!
                      //             .profile
                      //             .key,
                      //       );
                      //     },
                      //   ),
                      // SizedBox(height: 16.h),
                      PrimaryButton(
                        enabled: controller.isContinueEnabled(
                          currentStepIndex,
                          step.maxSelection,
                          step.minSelection,
                        ),
                        isLoading: isLoading,
                        text: 'Continue',
                        onPressed: () =>
                            handleOnboardingTap(ref: ref, context: context),
                      ),
                      BottomHeightWidget(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleOnboardingTap({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final steps = ref.read(onboardingStepsProvider);
    final authProvider = ref.read(authenticationProvider.notifier);

    final currentStepIndex = ref.read(onboardingStepIndexProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final isLastStep = currentStepIndex == steps.length - 1;

    final loadingNotifier = ref.read(onboardingLoadingProvider.notifier);
    loadingNotifier.setLoading(true);

    try {
      if (isLastStep) {
        final answers = controller.buildFinalAnswers(steps);
        final services = locator.get<OnboardingServices>();
        final result = await services.completeOnboarding(answers: answers);

        if (!context.mounted) return;
        if (result != null) {
          final fbEvents = FacebookEventsService();
          fbEvents.logEvent(
            name: 'onboarding_complete',
            parameters: {'timestamp': DateTime.now().toIso8601String()},
            ref: ref,
            screenName: "Onboarding",
          );
          await ref.read(aiExamplesControllerProvider.notifier).init(result);
          authProvider.setOnboarding(
            OnboardingDataModel(
              onboardingResult: result,
              onboardingAnswers: answers,
            ),
          );
          final prefs = locator.get<SharedPrefServices>();
          prefs.saveOnboarding(
            OnboardingDataModel(
              onboardingResult: result,
              onboardingAnswers: answers,
            ),
          );
          ref.read(onboardingResultProvider.notifier).state = result;
          Navigator.pushNamedAndRemoveUntil(
            context,
            UiMainSignup.routeName,
            arguments: {'onboarding': result, 'show_celebration': true},
            (route) => false,
          );
        } else {
          FlashMessage.showError(
            context,
            "Something went wrong on early access",
          );
        }
      } else {
        ref.read(onboardingStepIndexProvider.notifier).state++;
      }
    } catch (e) {
      FlashMessage.showError(context, "Failed to complete onboarding.");
    } finally {
      loadingNotifier.setLoading(false);
    }
  }

  // _handleOnboardingComplete(BuildContext context, WidgetRef ref) async {
  //   final loadingNotifier = ref.read(onboardingLoadingProvider.notifier);
  //   loadingNotifier.setLoading(true);
  //   ref.read(authenticationProvider).isFirstTime = true;
  //   loadingNotifier.setLoading(false);
  //   if (!context.mounted) return;
  //   Navigator.pushNamed(context, UIPromiseFlowScreen.routeName);
  // }
}

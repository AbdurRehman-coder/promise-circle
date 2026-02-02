import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/promise/presentation/widgets/step_description_dynamic_text.dart'
    show StepDescriptionDynamicText;
import 'package:sbp_app/features/promise/provider/promise_list_provider.dart';
import 'package:sbp_app/features/shared/providers/ai_examples_provider.dart';
import 'package:sbp_app/features/shared/widgets/squiggly_frame_widget.dart';
import 'package:sbp_app/features/shared/widgets/w_app_text_logo.dart';
import 'package:sbp_app/features/shared/widgets/w_custom_form_field.dart';
import 'package:sbp_app/features/promise/provider/promise_controller.dart';
import 'package:sbp_app/core/constants/assets.dart';
import 'package:sbp_app/features/shared/widgets/staggered_column.dart';

class DefineStep extends ConsumerStatefulWidget {
  const DefineStep({super.key});

  @override
  ConsumerState<DefineStep> createState() => _DefineStepState();
}

class _DefineStepState extends ConsumerState<DefineStep> {
  late PromiseTextController _textController;
  final String _requiredPrefix = "I Promise ";
  bool _hasError = false;
  late final String promiseExample;

  @override
  void initState() {
    super.initState();

    promiseExample =
        ((ref.read(promisesProvider).hasPromises
                    ? ref
                          .read(aiExamplesControllerProvider)
                          .value
                          ?.samplePromise
                    : ref
                          .read(aiExamplesControllerProvider)
                          .value
                          ?.promiseFromBroken) ??
                ref
                    .read(promiseControllerProvider.notifier)
                    .getRandomPromiseExample(ref))
            .substring(9);
    final initialDescription = ref.read(promiseControllerProvider).description;

    String textToSet = initialDescription;

    if (textToSet.isEmpty) {
      textToSet = _requiredPrefix;
    } else if (!textToSet.toLowerCase().startsWith(
      _requiredPrefix.trim().toLowerCase(),
    )) {
      textToSet = _requiredPrefix + textToSet;
    }

    _textController = PromiseTextController(
      text: textToSet,
      boldPrefix: "I Promise",
      baseStyle: AppTextStyles.bodyTextStyle.copyWith(
        fontSize: 16.sp,
        color: AppColors.primaryBlackColor,
        fontWeight: FontWeight.w400,
      ),
    );

    if (initialDescription != textToSet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(promiseControllerProvider.notifier).setDescription(textToSet);
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleTextChange(String value) {
    final controller = ref.read(promiseControllerProvider.notifier);

    final isValid = value.trim().toLowerCase().startsWith("i promise");

    setState(() {
      _hasError = !isValid;
    });

    controller.setDescription(value);
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredColumn(
      children: [
        Center(child: AppNameLogo()),
        SizedBox(height: 45.h),
        SizedBox(
          width: double.infinity,
          height: 120.h,
          child: SvgPicture.asset(
            Assets.svgAddPromiseIcon,
            width: double.infinity,
            fit: BoxFit.fill,
            height: 120.h,
          ),
        ),
        SizedBox(height: 40.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "What's Your Promise?",
                textAlign: TextAlign.center,
                style: AppTextStyles.headingTextStyleBogart.copyWith(
                  fontSize: 28.sp,
                ),
              ),
              SizedBox(height: 10.h),
              StepDescriptionDynamicText(
                "Make it simple, measurable and meaningful.",
              ),

              SizedBox(height: 16.h),
              SquigglyFrameWidget(
                titleText: "Example",
                descriptionStartText: "I Promise",
                descriptionText: promiseExample,
                frameBorderColor: Color(0xFF6CC163),
              ),
              SizedBox(height: 32.h),
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Start with the words ",
                        style: AppTextStyles.mediumBodyTextStyle.copyWith(
                          color: AppColors.primaryBlackColor,
                        ),
                      ),
                      TextSpan(
                        text: "\"I Promise\"",
                        style: AppTextStyles.boldBodyTextStyle.copyWith(
                          color: AppColors.primaryBlackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: _textController,
                hintText:
                    "", // Hint text is hidden because we pre-fill "I Promise "
                showCounterText: false,
                expand: true,
                maxLines: 1,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                filledColor: AppColors.whiteColor,
                onChange: _handleTextChange,
                // The style here mainly affects the cursor and placeholder calculations
                // The actual text rendering is overridden by PromiseTextController
                style: AppTextStyles.bodyTextStyleBogart.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.primaryBlackColor,
                  height: 1.4,
                ),
              ),
              if (_hasError)
                Padding(
                  padding: EdgeInsets.only(top: 8.0.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16.sp,
                        color: AppColors.errorColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Your promise must start with \"I Promise\"",
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          fontSize: 13.sp,
                          color: AppColors.errorColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 16.h),
              Text(
                "Focus on what you will do or what you will stop doing. This doesn’t have to be big, just real.",
                textAlign: TextAlign.start,
                style: AppTextStyles.mediumBodyTextStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PromiseTextController extends TextEditingController {
  final TextStyle baseStyle;
  final String boldPrefix;

  PromiseTextController({
    super.text,
    required this.baseStyle,
    this.boldPrefix = "I Promise",
  });

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (text.isEmpty ||
        !text.toLowerCase().startsWith(boldPrefix.toLowerCase())) {
      return TextSpan(style: baseStyle, text: text);
    }

    final int prefixLength = boldPrefix.length;

    if (text.length < prefixLength) {
      return TextSpan(style: baseStyle, text: text);
    }

    final String firstPart = text.substring(0, prefixLength);
    final String secondPart = text.substring(prefixLength);

    return TextSpan(
      style: baseStyle,
      children: [
        TextSpan(
          text: firstPart,
          style: baseStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text: secondPart,
          style: baseStyle.copyWith(fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}

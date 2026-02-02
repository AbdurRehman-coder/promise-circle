import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/profile/models/support_option.dart';
import 'package:sbp_app/features/profile/presentations/send_email.dart';
import 'package:sbp_app/features/shared/widgets/back_button.dart';
import 'package:sbp_app/features/shared/widgets/screen_template.dart';
import 'package:sbp_app/core/constants/assets.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});
  static const String routeName = '/support';
  static String routePath = '/support';

  @override
  Widget build(BuildContext context) {
    final supportOptions = [
      SupportOption(title: 'FAQ', icon: Assets.svgUser, onTap: () {}),
      SupportOption(
        title: 'Send email',
        icon: Assets.svgEmailIcon,
        onTap: () {
          Navigator.pushNamed(context, SendEmail.routePath);
        },
      ),
      SupportOption(
        title: 'Report a problem',
        icon: Assets.svgReportIcon,
        onTap: () {},
      ),
      // SupportOption(
      //   title: 'Request refund',
      //   icon: Assets.svgRefundIcon,
      //   onTap: () {
      //     Navigator.pushNamed(context, RefundScreen.routePath);
      //   },
      // ),
    ];

    return ScreenTemplate(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BackButtonWidget(),
          const SizedBox(height: 16),
          Text(
            'Support',
            style: AppTextStyles.headingTextStyleBogart.copyWith(
              color: AppColors.blackColor,
              fontWeight: FontWeight.w600,
              fontSize: 32,
              letterSpacing: 0.9,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              Column(
                children: supportOptions
                    .asMap()
                    .entries
                    .map(
                      (entry) => SupportOptionItem(
                        index: entry.key,
                        option: entry.value,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class SupportOptionItem extends StatelessWidget {
  final int index;
  final SupportOption option;

  const SupportOptionItem({super.key, this.index = 0, required this.option});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (index == 0) Divider(color: AppColors.grey200Color),

        InkWell(
          onTap: option.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),

            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  child: SvgPicture.asset(option.icon, height: 22, width: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    option.title,
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}

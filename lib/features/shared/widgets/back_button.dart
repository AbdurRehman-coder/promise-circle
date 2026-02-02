import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/app_exports.dart';
import 'package:sbp_app/core/utils/text_styles.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.arrow_back, color: AppColors.blackColor, size: 20),
          const SizedBox(width: 5),
          Text(
            "Back",
            style: AppTextStyles.bodyTextStyle.copyWith(
              color: AppColors.blackColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

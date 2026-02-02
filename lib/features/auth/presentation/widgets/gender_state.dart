import 'package:flutter/material.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';

class GenderSelector extends StatefulWidget {
  final Function(String) onGenderSelected;
  final String? initialValue;

  const GenderSelector({
    super.key,
    required this.onGenderSelected,
    this.initialValue,
  });

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  late final ValueNotifier<String?> selectedGender;

  @override
  void initState() {
    super.initState();
    selectedGender = ValueNotifier<String?>(widget.initialValue);
  }

  @override
  void dispose() {
    selectedGender.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Gender',
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.blackColor,
            ),
            children: [
              TextSpan(
                text: ' (Optional)',
                style: AppTextStyles.bodyTextStyle.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyColor,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),
        ValueListenableBuilder<String?>(
          valueListenable: selectedGender,
          builder: (context, selected, child) {
            return Row(
              children: [
                Expanded(child: _buildGenderTile('Male', selected)),
                const SizedBox(width: 12),
                Expanded(child: _buildGenderTile('Female', selected)),
                const SizedBox(width: 12),
                Expanded(child: _buildGenderTile('Other', selected)),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildGenderTile(String gender, String? selected) {
    final isSelected = selected == gender;

    return GestureDetector(
      onTap: () {
        selectedGender.value = gender;
        widget.onGenderSelected(gender);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.blueColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            gender,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/promise/provider/promise_controller.dart';
import 'package:sbp_app/features/shared/widgets/squiggly_frame_widget.dart';
import 'package:sbp_app/features/shared/widgets/staggered_column.dart';

import '../../../../core/utils/responsive_config.dart';

class CategorySelectionScreen extends ConsumerWidget {
  const CategorySelectionScreen({super.key});

  final List<Map<String, String>> categories = const [
    {'name': 'Ambition', 'icon': '🚀'},
    {'name': 'Purpose', 'icon': '🌟'},
    {'name': 'Health', 'icon': '🍏'},
    {'name': 'Fitness', 'icon': '🏃'},
    {'name': 'Money', 'icon': '💵'},
    {'name': 'Finance', 'icon': '📈'},
    {'name': 'Focus', 'icon': '🎯'},
    {'name': 'Productivity', 'icon': '⚡'},
    {'name': 'Relationships', 'icon': "❤️"},
    {'name': 'Boundaries', 'icon': '🚧'},
    {'name': 'Self-worth', 'icon': '💫'},
    {'name': 'Growth', 'icon': '🌱'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndices = ref.watch(
      promiseControllerProvider.select((s) => s.selectedCategoryIndices),
    );
    final controller = ref.read(promiseControllerProvider.notifier);
    final promiseDes = ref.read(promiseControllerProvider).description.trim();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: StaggeredColumn(
        children: [
          const SizedBox(height: 10),
          SquigglyFrameWidget(
            titleText: "My Promise",
            descriptionStartText: "I Promise ",
            descriptionText: promiseDes.substring(10),
            frameBorderColor: Color(0xFF6CC163),
          ),
          SizedBox(height: 32.h),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Choose up to 3 categories for this promise",
              style: AppTextStyles.boldBodyTextStyle,
            ),
          ),
          SizedBox(height: 16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemBuilder: (context, index) {
              final isSelected = selectedIndices.contains(index);
              final category = categories[index];

              return GestureDetector(
                onTap: () {
                  controller.toggleCategory(index);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF5D5FEF)
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      if (!isSelected)
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.05),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category['icon']!,
                            style: TextStyle(fontSize: 24.sp, fontFamily: ''),
                          ),
                          Container(
                            padding: EdgeInsets.all(4.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.secondaryBlueColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: BoxBorder.all(
                                color: isSelected
                                    ? AppColors.secondaryBlueColor
                                    : AppColors.grey200Color,
                              ),
                            ),
                            child: Icon(
                              Icons.check,
                              size: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        category['name']!,
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          color: isSelected
                              ? const Color(0xFF5D5FEF)
                              : const Color(0xFF1C1C1E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

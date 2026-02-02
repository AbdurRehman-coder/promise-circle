import 'package:flutter/material.dart';
import 'package:sbp_app/core/theming/app_colors.dart';

class ReasonSelectionWidget extends StatefulWidget {
  final Function(String)? onSelected;   // returns snake_case string

  const ReasonSelectionWidget({
    super.key,
    this.onSelected,
  });

  @override
  State<ReasonSelectionWidget> createState() => _ReasonSelectionWidgetState();
}

class _ReasonSelectionWidgetState extends State<ReasonSelectionWidget> {
  // UI label → returned value
  final Map<String, String> reasons = {
    'Not as expected': 'not_as_expected',
    'Accidental purchase': 'accidental_purchase',
    'App issues': 'app_issue',
    'Not using': 'not_using',
    'Found alternative': 'found_alternative',
    'Technical problem': 'technical_problem',
    'Others': 'other',
  };

  String? selectedReason = 'App issues';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: reasons.entries.map((entry) {
        final label = entry.key;
        final value = entry.value;
        final isSelected = selectedReason == label;

        return GestureDetector(
          onTap: () {
            setState(() => selectedReason = label);

            if (widget.onSelected != null) {
              widget.onSelected!(value); // 🔥 returns snake_case
            }
          },
          child: Container(
            width: (MediaQuery.of(context).size.width - 24 * 2 - 12) / 2,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected
                    ? AppColors.secondaryBlueColor
                    : const Color(0xFFE0E0E0),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? AppColors.secondaryBlueColor
                      : Colors.black87,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
